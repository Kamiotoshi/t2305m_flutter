class ClassificationResult {
  final Map<String, double> _classConfidences = {};

  /// Trả về tất cả các lớp bài tập đã được phân loại.
  Set<String> getAllClasses() {
    return _classConfidences.keys.toSet();
  }

  /// Lấy độ chính xác của một lớp bài tập.
  double getClassConfidence(String className) {
    return _classConfidences.containsKey(className) ? _classConfidences[className]! : 0.0;
  }

  /// Trả về lớp có độ chính xác cao nhất.
  String getMaxConfidenceClass() {
    if (_classConfidences.isEmpty) return "unknown";
    return _classConfidences.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Tăng độ chính xác của một lớp bài tập.
  void incrementClassConfidence(String className, [double value = 1.0]) {
    _classConfidences[className] = (_classConfidences[className] ?? 0.0) + value;
  }

  /// Gán giá trị độ chính xác cho một lớp bài tập.
  void putClassConfidence(String className, double confidence) {
    _classConfidences[className] = confidence;
  }
}
