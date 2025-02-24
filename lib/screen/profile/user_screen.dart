import 'package:flutter/material.dart';
import '../TEST/pose_sample.dart';
import 'dart:async';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  late Future<List<PoseSample>> poseSamplesFuture;

  @override
  void initState() {
    super.initState();
    poseSamplesFuture = PoseSample.loadPoseSamples("assets/pose/fitness_pose_samples.csv"); // ✅ Đã xóa dấu cách dư
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Screen")),
      body: FutureBuilder<List<PoseSample>>(
        future: poseSamplesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có dữ liệu"));
          }

          // ✅ In ra số lượng mẫu đọc được để kiểm tra
          print("📌 Đọc được ${snapshot.data!.length} mẫu từ CSV!");

          // Lấy dữ liệu mẫu đầu tiên để hiển thị
          PoseSample sample = snapshot.data![0];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tên mẫu: ${sample.name}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Bài tập: ${sample.className}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text("Tọa độ Left Shoulder: ${sample.landmarks[5]}", style: const TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}
