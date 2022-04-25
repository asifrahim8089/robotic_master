// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, prefer_final_fields, unnecessary_new, avoid_print, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:robotek/Authfiles/dealerRegistration.dart';
import 'package:robotek/Commons/Constants.dart';
import 'package:robotek/Commons/SnackBar.dart';
import 'package:robotek/Commons/validators.dart';
import 'package:robotek/Commons/colorResource.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:robotek/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DealerLogin extends StatefulWidget {
  const DealerLogin({Key? key}) : super(key: key);

  @override
  _DealerLoginState createState() => _DealerLoginState();
}

class _DealerLoginState extends State<DealerLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool circular = false;
  var dealerdetails;

  void validateAndSave() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        circular = true;
      });
      Map<String, String> data = {
        "phone": _phoneController.text,
        "password": _passwordController.text,
      };

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://robotek.frantic.in/RestApi/login_dealer'));
      request.headers.addAll({
        "Content-Type": "multipart/form-data",
        "Accept": "multipart/form-data",
      });
      request.fields['phone'] = _phoneController.text;
      request.fields['password'] = _passwordController.text;
      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> output = json.decode(responsed.body);
        setState(() {
          dealerdetails = output["data"]["id"];
          print(dealerdetails);
        });
        if (output["response_string"] == "Log in Failed") {
          showSnackBar(
            duration: Duration(milliseconds: 1000),
            context: context,
            message: "Unable to Login",
          );
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          SharedPreferences dealer = await SharedPreferences.getInstance();
          await prefs.setBool('isDealer', true);
          SharedPreferences id = await SharedPreferences.getInstance();
          await prefs.setString('id', dealerdetails);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => Home(dealerdetails: dealerdetails),
              ),
              (route) => false);
        }
      } else {
        showSnackBar(
          duration: Duration(milliseconds: 1000),
          context: context,
          message: "Unable to Login",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  child: Image.asset(
                      'assets/sign-page-abstract-concept-illustration_335657-3875.jpg'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 80),
                ),
                Container(
                    height: 55,
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: nameValidator,
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: "Enter Phone Number",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                            ),
                            onChanged: (value) {
                              var number = value.toString();
                            },
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Container(
                    height: 55,
                    width: 300,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: nameValidator,
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: "Enter Password",
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.cyan),
                              ),
                            ),
                            onChanged: (value) {
                              var number = value.toString();
                            },
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 60),
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
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  onTap: () {
                    validateAndSave();
                    //   Navigator.push(context, MaterialPageRoute(builder: (Context)=>otpVerification()));
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        "Don't have a account? ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (Context) => DealerRegistration()));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            color: colorResource.primaryColor2,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    Constants.dealer = false;
  }
}
