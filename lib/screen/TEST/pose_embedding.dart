import 'dart:math';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PoseEmbedding {
  static const double torsoMultiplier = 2.5; // Hệ số nhân cho kích thước phần thân

  /// Chuyển đổi danh sách keypoints thành embedding (vector đặc trưng).
  static List<Point3D> getPoseEmbedding(List<Point3D> landmarks) {
    List<Point3D> normalizedLandmarks = normalize(landmarks);
    return getEmbedding(normalizedLandmarks);
  }

  /// Chuẩn hóa dữ liệu để giúp so sánh dễ dàng hơn.
  static List<Point3D> normalize(List<Point3D> landmarks) {
    List<Point3D> normalizedLandmarks = List.from(landmarks);

    // 1️⃣ Dịch chuyển để phần hông nằm ở trung tâm
    Point3D hipsCenter = average(
        landmarks[PoseLandmarkType.leftHip.index],
        landmarks[PoseLandmarkType.rightHip.index]
    );

    subtractAll(hipsCenter, normalizedLandmarks);

    // 2️⃣ Chuẩn hóa kích thước dựa trên phần thân (torso)
    double scale = 1 / getPoseSize(normalizedLandmarks);
    multiplyAll(normalizedLandmarks, scale * 100); // Nhân với 100 để dễ debug

    return normalizedLandmarks;
  }

  /// Tính toán kích thước của tư thế dựa trên khoảng cách giữa các bộ phận cơ thể
  static double getPoseSize(List<Point3D> landmarks) {
    Point3D hipsCenter = average(
        landmarks[PoseLandmarkType.leftHip.index],
        landmarks[PoseLandmarkType.rightHip.index]
    );

    Point3D shouldersCenter = average(
        landmarks[PoseLandmarkType.leftShoulder.index],
        landmarks[PoseLandmarkType.rightShoulder.index]
    );

    double torsoSize = l2Norm2D(subtract(hipsCenter, shouldersCenter));
    double maxDistance = torsoSize * torsoMultiplier;

    for (var landmark in landmarks) {
      double distance = l2Norm2D(subtract(hipsCenter, landmark));
      if (distance > maxDistance) {
        maxDistance = distance;
      }
    }
    return maxDistance;
  }

  /// Trích xuất các đặc trưng để tạo "embedding" dùng cho phân loại
  static List<Point3D> getEmbedding(List<Point3D> lm) {
    List<Point3D> embedding = [];

    // Một khớp
    embedding.add(subtract(
        average(lm[PoseLandmarkType.leftHip.index], lm[PoseLandmarkType.rightHip.index]),
        average(lm[PoseLandmarkType.leftShoulder.index], lm[PoseLandmarkType.rightShoulder.index])
    ));

    embedding.add(subtract(lm[PoseLandmarkType.leftShoulder.index], lm[PoseLandmarkType.leftElbow.index]));
    embedding.add(subtract(lm[PoseLandmarkType.rightShoulder.index], lm[PoseLandmarkType.rightElbow.index]));

    embedding.add(subtract(lm[PoseLandmarkType.leftElbow.index], lm[PoseLandmarkType.leftWrist.index]));
    embedding.add(subtract(lm[PoseLandmarkType.rightElbow.index], lm[PoseLandmarkType.rightWrist.index]));

    embedding.add(subtract(lm[PoseLandmarkType.leftHip.index], lm[PoseLandmarkType.leftKnee.index]));
    embedding.add(subtract(lm[PoseLandmarkType.rightHip.index], lm[PoseLandmarkType.rightKnee.index]));

    embedding.add(subtract(lm[PoseLandmarkType.leftKnee.index], lm[PoseLandmarkType.leftAnkle.index]));
    embedding.add(subtract(lm[PoseLandmarkType.rightKnee.index], lm[PoseLandmarkType.rightAnkle.index]));

    return embedding;
  }

  /// Tính trung bình của hai điểm
  static Point3D average(Point3D a, Point3D b) {
    return Point3D((a.x + b.x) / 2, (a.y + b.y) / 2, (a.z + b.z) / 2);
  }

  /// Trừ tất cả các điểm trong danh sách với một điểm `p`
  static void subtractAll(Point3D p, List<Point3D> pointsList) {
    for (int i = 0; i < pointsList.length; i++) {
      pointsList[i] = subtract(pointsList[i], p);
    }
  }

  /// Nhân tất cả các điểm trong danh sách với một giá trị `scale`
  static void multiplyAll(List<Point3D> pointsList, double scale) {
    for (int i = 0; i < pointsList.length; i++) {
      pointsList[i] = multiply(pointsList[i], scale);
    }
  }

  /// Trừ hai điểm 3D
  static Point3D subtract(Point3D a, Point3D b) {
    return Point3D(a.x - b.x, a.y - b.y, a.z - b.z);
  }

  /// Nhân một điểm 3D với giá trị `scale`
  static Point3D multiply(Point3D a, double scale) {
    return Point3D(a.x * scale, a.y * scale, a.z * scale);
  }

  /// Tính khoảng cách Euclidean 2D (bỏ qua trục Z)
  static double l2Norm2D(Point3D point) {
    return sqrt(point.x * point.x + point.y * point.y);
  }
}

/// Lớp đại diện cho một điểm trong không gian 3D
class Point3D {
  final double x, y, z;

  Point3D(this.x, this.y, this.z);

  @override
  String toString() => "($x, $y, $z)";
}
