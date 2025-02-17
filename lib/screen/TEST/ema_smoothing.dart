import 'dart:collection';
import 'classification_result.dart';

class EMASmoothing {
  static const int defaultWindowSize = 10;  // Kích thước cửa sổ EMA
  static const double defaultAlpha = 0.2;   // Hệ số alpha cho EMA
  static const int resetThresholdMs = 100;  // Ngưỡng reset nếu dữ liệu bị gián đoạn

  final int windowSize;
  final double alpha;
  final Queue<ClassificationResult> window = Queue<ClassificationResult>();

  int lastInputTimestamp = 0; // Thời gian cuối cùng dữ liệu được nhập

  EMASmoothing({this.windowSize = defaultWindowSize, this.alpha = defaultAlpha});

  /// Nhận `ClassificationResult` đầu vào và trả về kết quả làm mượt
  ClassificationResult getSmoothedResult(ClassificationResult currentResult, int timestamp) {
    // Kiểm tra nếu có gián đoạn quá lâu, reset dữ liệu
    if (lastInputTimestamp != 0 && (timestamp - lastInputTimestamp) > resetThresholdMs) {
      window.clear();
    }
    lastInputTimestamp = timestamp;

    // Nếu cửa sổ đầy, loại bỏ giá trị cũ nhất
    if (window.length >= windowSize) {
      window.removeLast();
    }

    // Thêm giá trị mới vào đầu danh sách
    window.addFirst(currentResult);

    // Lấy tất cả các lớp bài tập
    Set<String> allClasses = {};
    for (var result in window) {
      allClasses.addAll(result.getAllClasses());
    }

    ClassificationResult smoothedResult = ClassificationResult();

    // Tính trung bình EMA cho từng lớp bài tập
    for (String className in allClasses) {
      double factor = 1.0;
      double topSum = 0;
      double bottomSum = 0;

      for (var result in window) {
        double confidence = result.getClassConfidence(className);
        topSum += factor * confidence;
        bottomSum += factor;
        factor *= (1.0 - alpha); // Giảm trọng số theo thời gian
      }

      smoothedResult.putClassConfidence(className, topSum / bottomSum);
    }

    return smoothedResult;
  }
}
