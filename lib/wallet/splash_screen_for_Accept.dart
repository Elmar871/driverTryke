import 'dart:async';

import 'package:drivers/screens/new_trip_screen.dart';
import 'package:flutter/material.dart';

import '../Assistants/assistant_methods.dart';
import '../global/global.dart';
import '../screens/login_screen.dart';
import '../screens/main_screen.dart';

class SplashScreenAccept extends StatefulWidget {
  const SplashScreenAccept({Key? key}) : super(key: key);

  @override
  State<SplashScreenAccept> createState() => _SplashScreenAcceptState();
}

class _SplashScreenAcceptState extends State<SplashScreenAccept> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();


    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000), // Set the duration of the animation
    );

    // Create animation
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    // Start the animation
    _animationController.forward();

    startTimer();
  }

  @override
  void dispose() {
    // Dispose animation controller
    _animationController.dispose();
    super.dispose();
  }

  startTimer() async {
    if(firebaseAuth.currentUser != null) {
      await AssistantMethods.readCurrentOnlineUserInfo();
      await AssistantMethods.readCurrentOnlineUserCarInfo();
      Timer(Duration(seconds: 7), () {
        //print("Car Type: ${carModelCurrentInfo!.type}");
        Navigator.push(context, MaterialPageRoute(builder: (c) => MainScreen()));
      });
    }
    else{
      Timer(Duration(seconds: 7), () {
        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFA0BFE0),
      body: Center(
        child: FadeTransition(
          opacity: _animation, // Apply the fade animation
          child: Image.asset(
            "images/logo1.png",
            height: 300,
            width: 300,
          ),
        ),
      ),
    );
  }
}