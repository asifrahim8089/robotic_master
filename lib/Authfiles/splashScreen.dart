// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:robotek/Authfiles/dealerLogin.dart';
import 'package:robotek/home.dart';
import 'package:robotek/selectUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('assets/RobotekLogo.png', width: 180)),
    );
  }

  @override
  void initState() {
    super.initState();
    startHome();
  }

  Future<void> startHome() async {
    await Future.delayed(Duration(milliseconds: 2000));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn');
    SharedPreferences id = await SharedPreferences.getInstance();
    var value = prefs.getString('id');

    if (status != false && value != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            dealerdetails: value,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SelectUser(),
          ));
    }
  }

  // void navigateUser() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var status = prefs.getBool('isLoggedIn') ?? false;
  //   print(status);
  //   if (status) {
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Home(),
  //       ),
  //     );
  //   } else {
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => DealerLogin(),
  //         ));
  //   }
  // }
}
