import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:untitled/root_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class LoginScreen extends StatefulWidget{
  final List<CameraDescription> cameras; // Thêm cameras vào constructor
  const LoginScreen({super.key, required this.cameras});
  @override
  _StateLogin createState() => _StateLogin();
}
class _StateLogin extends State<LoginScreen>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hidePassword = true;
  login() async {
    // get email
    print(emailController.text);
    // get password
    print(passwordController.text);
    // call login api
    // get auth bearer token
    // success -> save token to client storage ...
    // redirect -> Root page
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context)=> RootPage(cameras: widget.cameras),
        ),
    );
  }
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 250.0, horizontal: 30.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration:const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "Enter your email"
              ),
            ),
            const SizedBox(height: 20.0), // Thêm khoảng cách
            TextField(
              controller: passwordController,
              obscureText: _hidePassword,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                        _hidePassword?Icons.visibility_outlined:Icons.visibility_off_outlined
                    ),
                    onPressed: (){
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                  )
              ),
            ),
            const SizedBox(height: 30.0), // Thêm khoảng cách
            Padding(
              padding: EdgeInsets.all(20.0),
              child: FloatingActionButton(
                onPressed: login,
                child: Text("Login"),
              ),
            )
          ],
        ),
      ),
    );
  }
}