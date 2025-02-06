import 'dart:io';
import 'package:flutter/services.dart';

class PoseSample {
  final String name;
  final String className;
  final List<List<double>> landmarks; // Mỗi phần tử là [x, y, z]

  PoseSample({
    required this.name,
    required this.className,
    required this.landmarks,
  });

  // Hàm đọc file CSV và trả về danh sách PoseSample
  static Future<List<PoseSample>> loadPoseSamples(String csvPath) async {
    List<PoseSample> poseSamples = [];

    try {
      String csvContent = await rootBundle.loadString(csvPath);
      List<String> lines = csvContent.split('\n');

      for (String line in lines) {
        PoseSample? poseSample = PoseSample.fromCsv(line);
        if (poseSample != null) { // Chỉ thêm vào danh sách nếu dòng hợp lệ
          poseSamples.add(poseSample);
        }
      }
    } catch (e) {
      print("Lỗi khi đọc file CSV: $e");
    }

    return poseSamples;
  }

  // Chuyển 1 dòng CSV thành PoseSample
  static PoseSample? fromCsv(String csvLine) {
    // Kiểm tra nếu dòng trống hoặc chỉ chứa khoảng trắng thì bỏ qua
    if (csvLine.trim().isEmpty) {
      return null;
    }

    List<String> tokens = csvLine.split(',');

    // In số lượng phần tử để debug
    print("Dòng CSV có ${tokens.length} cột: $csvLine");

    // Kiểm tra xem dữ liệu có đủ không (2 giá trị đầu tiên là tên + loại bài tập)
    if (tokens.length < (33 * 3) + 2) {
      print("Lỗi: Dữ liệu không hợp lệ: $csvLine");
      return null;
    }

    String name = tokens[0]; // Tên ảnh mẫu
    String className = tokens[1]; // Loại bài tập (pushups_up, squats_down, v.v.)
    List<List<double>> landmarks = [];

    // Chuyển đổi tọa độ từ chuỗi thành số
    for (int i = 2; i < tokens.length; i += 3) {
      try {
        double x = double.parse(tokens[i]);
        double y = double.parse(tokens[i + 1]);
        double z = double.parse(tokens[i + 2]);
        landmarks.add([x, y, z]);
      } catch (e) {
        print("Lỗi chuyển đổi tọa độ: $e");
        return null;
      }
    }

    return PoseSample(name: name, className: className, landmarks: landmarks);
  }
}
