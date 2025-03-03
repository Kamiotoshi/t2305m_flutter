import 'package:flutter/material.dart';
import 'package:untitled/screen/camera/camera_pushup/views/pose_detection_view.dart';
import 'package:untitled/screen/camera/camera_screen.dart';
import 'package:untitled/screen/cart/cart_screen.dart';
import 'package:untitled/screen/home/home_screen.dart';
import 'package:untitled/screen/profile/user_screen.dart';
import 'package:untitled/screen/search/search.dart';
import 'package:camera/camera.dart';


class RootPage extends StatefulWidget {
  final List<CameraDescription> cameras; // Thêm danh sách cameras

  const RootPage({super.key, required this.cameras}); // Bỏ 'const'

  @override
  State<StatefulWidget> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    // Truyền cameras vào CameraApp
    print("Cameras available: ${widget.cameras.length}"); // Log cameras

    screens = [
      HomeScreen(),
      SearchScreen(),
      CartScreen(),
      UserScreen(),
      CameraApp(cameras: widget.cameras),
      PoseDetectorView(),
    ];
  }

  int _selectIndex = 0;

  void changeScreen(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "T2305M",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: screens[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined), label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera), label: "Camera"),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_roll_sharp), label: "CameraText"),
        ],
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.black87,
        currentIndex: _selectIndex,
        onTap: (index) => changeScreen(index),
      ),
    );
  }
}
