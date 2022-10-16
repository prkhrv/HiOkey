import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:pf_test/Controllers/auth_controller.dart';
// import 'package:pf_test/Pages/first_page.dart';
import 'package:get/get.dart';
import 'package:hiokey/controllers/auth_controller.dart';
import 'package:hiokey/pages/auth_page.dart';
import 'package:hiokey/pages/home.dart';
// import 'package:pf_test/Pages/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;
  final authController = Get.put(AuthController());

  _SplashScreenState(){

    Timer(const Duration(milliseconds: 2000), (){
      if(authController.isAuthenticated){
        Get.offAll(() => const HomePage());
      }else{
        Get.offAll(() => AuthPage());
      }
    });

    Timer(
        const Duration(milliseconds: 10),(){
      setState(() {
        _isVisible = true; // Now it is showing fade effect and navigating to Login page
      });
    }
    );

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white],
          begin: FractionalOffset(0, 0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: const Duration(milliseconds: 1200),
        child: Center(
          // child: Icon(Icons.ac_unit,color: Colors.red,size: 50),
            child: Image.asset('assets/1.png')
        ),
      ),
    );
  }
}