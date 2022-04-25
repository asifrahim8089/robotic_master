// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:robotek/Authfiles/dealerLogin.dart';
import 'package:robotek/Authfiles/resaler_login.dart';

class SelectUser extends StatefulWidget {
  const SelectUser({Key? key}) : super(key: key);

  @override
  _SelectUserState createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              SizedBox(
                width: 180,
                height: 180,
                child: Image.asset("assets/RobotekLogo.png"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
              ),
              Text(
                "Choose the type of the user",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (Context) => EnterYourNumber()));
                },
                child: Container(
                  width: 160,
                  height: 160,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 14),
                      ),
                      SizedBox(
                        height: 100,
                        child: Image.asset("assets/selectUserResaller.png"),
                      ),
                      Container(
                        height: 40,
                        width: 160,
                        child: Center(
                          child: Text(
                            "RESALER",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (Context) => DealerLogin()));
                },
                child: Container(
                  width: 160,
                  height: 160,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 14),
                      ),
                      SizedBox(
                        height: 100,
                        child: Image.asset("assets/selectUserDealer.png"),
                      ),
                      Container(
                        height: 40,
                        width: 160,
                        child: Center(
                          child: Text(
                            "DEALER",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 3),
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 60),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
