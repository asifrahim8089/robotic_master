// ignore_for_file: camel_case_types, unused_import, prefer_const_constructors, sized_box_for_whitespace, avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:robotek/Authfiles/reseller_signup.dart';
import 'package:robotek/Commons/SnackBar.dart';
import 'package:robotek/Commons/colorResource.dart';
import 'package:robotek/home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class otpVerification extends StatefulWidget {
  final String phoneNumber;
  final int otp;
  final String response;
  const otpVerification({
    Key? key,
    required this.phoneNumber,
    required this.otp,
    required this.response,
  }) : super(key: key);

  @override
  _otpVerificationState createState() => _otpVerificationState();
}

class _otpVerificationState extends State<otpVerification> {
  bool completed = false;
  late int serverOtp;
  late int typedotp;
  var dealerdetails;
  // final storage = new FlutterSecureStorage();
  @override
  void initState() {
    setState(() {
      serverOtp = widget.otp;
    });
    super.initState();
  }

  void _verifyUser(typedotp) async {
    Map<String, String> data = {
      "phone": widget.phoneNumber,
      "otp": typedotp.toString(),
    };
    print(data);

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://robotek.frantic.in/RestApi/verify_otp'));
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Accept": "multipart/form-data",
    });
    request.fields['phone'] = widget.phoneNumber;
    request.fields['otp'] = typedotp.toString();
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);
    print(responseData);
    if (response.statusCode == 200) {
      Map<String, dynamic> output = json.decode(responsed.body);
      print(output);
      if (output["error_code"] == 1) {
        setState(() {
          dealerdetails = output["data"]["id"];
          print(dealerdetails);
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        SharedPreferences id = await SharedPreferences.getInstance();
        await prefs.setString('id', dealerdetails);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              dealerdetails: dealerdetails,
            ),
          ),
          (route) => false,
        );
      } else if (output["error_code"] == 0) {
        showSnackBar(
          duration: Duration(milliseconds: 10000),
          context: context,
          message: "OTP Mismatch",
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpUser(
              phoneNumber: widget.phoneNumber,
            ),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 120,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 250,
                child: Image.asset(
                    'assets/enter-otp-concept-illustration_114360-7887.jpg'),
              ),
              Container(
                width: 320,
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      'Verification',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      'We have sent a 4 digit otp at your number. Please Enter it within 5 min Otp is $serverOtp ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
              Container(
                width: 250,
                child: PinCodeTextField(
                  appContext: context,
                  pastedTextStyle: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 4,

                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v!.length < 3) {
                      return "";
                    } else {
                      return null;
                    }
                  },
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      activeColor: Colors.greenAccent,
                      inactiveFillColor: Colors.white,
                      inactiveColor: Colors.black,
                      selectedColor: Colors.black,
                      selectedFillColor: Colors.white),
                  cursorColor: Colors.black,

                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,

                  keyboardType: TextInputType.number,
                  // ignore: prefer_const_literals_to_create_immutables
                  boxShadows: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  onCompleted: (v) {
                    typedotp = int.tryParse(v)!;
                    print("Completed");
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    // print(value);
                    setState(() {});
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                ),
              ),
              GestureDetector(
                child: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(
                      color: colorResource.primaryColorLight,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                onTap: () {
                  _verifyUser(typedotp);
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (Context) => SignUpUser()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
