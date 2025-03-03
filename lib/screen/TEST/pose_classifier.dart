import 'dart:math';
import '../TEST/pose_sample.dart';
import '../TEST/pose_embedding.dart';
import '../TEST/point3d.dart';
import '../TEST/classification_result.dart';

class PoseClassifier {
  static const int maxDistanceTopK = 30;
  static const int meanDistanceTopK = 10;
  static final Point3D axesWeights = Point3D(1, 1, 0.2);

  final List<PoseSample> poseSamples;

  PoseClassifier(this.poseSamples);

  /// 🔹 Phân loại tư thế dựa trên danh sách keypoints
  ClassificationResult classify(List<Point3D> landmarks) {
    ClassificationResult result = ClassificationResult();

    // Nếu không phát hiện keypoints thì return sớm
    if (landmarks.isEmpty) {
      return result;
    }

    // Lật ngang tọa độ để tránh lỗi khi sử dụng camera trước
    List<Point3D> flippedLandmarks = landmarks.map((p) => Point3D(-p.x, p.y, p.z)).toList();

    // Lấy embedding từ tư thế người dùng
    List<Point3D> embedding = PoseEmbedding.getPoseEmbedding(landmarks);
    List<Point3D> flippedEmbedding = PoseEmbedding.getPoseEmbedding(flippedLandmarks);

    // 1️⃣ Chọn Top-K mẫu tư thế gần nhất dựa trên MAX khoảng cách
    List<MapEntry<PoseSample, double>> maxDistances = [];

    for (PoseSample sample in poseSamples) {
      List<Point3D> sampleEmbedding = sample.embedding;

      double originalMax = 0, flippedMax = 0;
      for (int i = 0; i < embedding.length; i++) {
        originalMax = max(originalMax, _maxAbs(_multiply(_subtract(embedding[i], sampleEmbedding[i]), axesWeights)));
        flippedMax = max(flippedMax, _maxAbs(_multiply(_subtract(flippedEmbedding[i], sampleEmbedding[i]), axesWeights)));
      }

      double minDistance = min(originalMax, flippedMax);
      maxDistances.add(MapEntry(sample, minDistance));

      if (maxDistances.length > maxDistanceTopK) {
        maxDistances.sort((a, b) => a.value.compareTo(b.value));
        maxDistances.removeLast();
      }
    }

    // 2️⃣ Chọn Top-K mẫu tư thế gần nhất dựa trên MEAN khoảng cách
    List<MapEntry<PoseSample, double>> meanDistances = [];

    for (var sampleDist in maxDistances) {
      PoseSample sample = sampleDist.key;
      List<Point3D> sampleEmbedding = sample.embedding;

      double originalSum = 0, flippedSum = 0;
      for (int i = 0; i < embedding.length; i++) {
        originalSum += _sumAbs(_multiply(_subtract(embedding[i], sampleEmbedding[i]), axesWeights));
        flippedSum += _sumAbs(_multiply(_subtract(flippedEmbedding[i], sampleEmbedding[i]), axesWeights));
      }

      double meanDistance = min(originalSum, flippedSum) / (embedding.length * 2);
      meanDistances.add(MapEntry(sample, meanDistance));

      if (meanDistances.length > meanDistanceTopK) {
        meanDistances.sort((a, b) => a.value.compareTo(b.value));
        meanDistances.removeLast();
      }
    }

    // 3️⃣ Gán nhãn bài tập với điểm số cao nhất
    for (var sampleDist in meanDistances) {
      result.incrementClassConfidence(sampleDist.key.className);
    }

    return result;
  }

  /// Tính giá trị tuyệt đối lớn nhất của một điểm
  double _maxAbs(Point3D p) {
    return max(p.x.abs(), max(p.y.abs(), p.z.abs()));
  }

  /// Tính tổng giá trị tuyệt đối của một điểm
  double _sumAbs(Point3D p) {
    return p.x.abs() + p.y.abs() + p.z.abs();
  }

  /// Trừ hai điểm 3D
  Point3D _subtract(Point3D a, Point3D b) {
    return Point3D(a.x - b.x, a.y - b.y, a.z - b.z);
  }

  /// Nhân hai điểm 3D
  Point3D _multiply(Point3D a, Point3D b) {
    return Point3D(a.x * b.x, a.y * b.y, a.z * b.z);
  }
}
