// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, non_constant_identifier_names, prefer_typing_uninitialized_variables, unused_local_variable, avoid_print

import 'package:flutter/material.dart';
import 'package:robotek/Authfiles/dealerLogin.dart';
import 'package:robotek/Commons/SnackBar.dart';
import 'package:robotek/Commons/validators.dart';
import 'package:robotek/Commons/colorResource.dart';
import 'package:robotek/home.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DealerRegistration extends StatefulWidget {
  const DealerRegistration({Key? key}) : super(key: key);

  @override
  _DealerRegistrationState createState() => _DealerRegistrationState();
}

class _DealerRegistrationState extends State<DealerRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
        "email": _emailController.text,
        "name": _nameController.text,
        "company_name": _companyController.text,
        "password": _passwordController.text,
      };

      var request = http.MultipartRequest('POST',
          Uri.parse('http://robotek.frantic.in/RestApi/register_dealer'));
      request.headers.addAll({
        "Content-Type": "multipart/form-data",
        "Accept": "multipart/form-data",
      });
      request.fields['phone'] = _phoneController.text;
      request.fields['email'] = _emailController.text;
      request.fields['name'] = _nameController.text;
      request.fields['company_name'] = _companyController.text;
      request.fields['password'] = _passwordController.text;
      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> output = json.decode(responsed.body);
        setState(() {
          dealerdetails = output["data"]["id"];
        });
        print(output);
        if (output["response_string"] == "Registered Successfully") {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          SharedPreferences dealer = await SharedPreferences.getInstance();
          await prefs.setBool('isDealer', true);
          SharedPreferences id = await SharedPreferences.getInstance();
          await prefs.setString('id', dealerdetails);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                  dealerdetails: dealerdetails,
                ),
              ),
              (route) => false);
        } else {
          showSnackBar(
            duration: Duration(milliseconds: 1000),
            context: context,
            message: "Unable to Login",
          );
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (Context) => DealerLogin()));
            },
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
          ),
          leadingWidth: 50,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Dealer Registration",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xff3E3C3C),
              ),
            ),
          ),
          centerTitle: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 120,
          width: MediaQuery.of(context).size.width,
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * (6 / 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height:
                                MediaQuery.of(context).size.height * (2 / 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 180,
                                    child: TextFormField(
                                      validator: nameValidator,
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        labelText: "Name",
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.cyan),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        var number = value.toString();
                                      },
                                    )),
                                Container(
                                    height: 55,
                                    width: 180,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            validator: nameValidator,
                                            controller: _companyController,
                                            decoration: InputDecoration(
                                              labelText: "Company Name",
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.cyan),
                                              ),
                                            ),
                                            onChanged: (value) {
                                              var number = value.toString();
                                            },
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: CircleAvatar(
                                  radius: 100,
                                  child:
                                      Image.asset("assets/businessMale.png")),
                            ),
                          ),
                        ],
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
                                    labelText: "Enter Phone",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.cyan),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    var number = value.toString();
                                  },
                                ),
                              ),
                            ],
                          )),
                      Container(
                          height: 55,
                          width: 300,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: nameValidator,
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: "Enter Email",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.cyan),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    var number = value.toString();
                                  },
                                ),
                              ),
                            ],
                          )),
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
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.cyan),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    var number = value.toString();
                                  },
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 60),
                ),
                InkWell(
                  child: Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        color: colorResource.primaryColorLight,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  onTap: () {
                    validateAndSave();
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
