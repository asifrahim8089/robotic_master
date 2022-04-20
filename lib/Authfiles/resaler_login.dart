// ignore_for_file: prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_const_constructors, unused_local_variable, prefer_final_fields, avoid_print, unnecessary_new

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:robotek/Authfiles/reseller_otp_verfication.dart';
import 'package:robotek/Commons/SnackBar.dart';
import 'package:robotek/Commons/validators.dart';
import 'package:robotek/Commons/Constants.dart';
import 'package:robotek/Commons/colorResource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnterYourNumber extends StatefulWidget {
  const EnterYourNumber({Key? key}) : super(key: key);

  @override
  _EnterYourNumberState createState() => _EnterYourNumberState();
}

class _EnterYourNumberState extends State<EnterYourNumber> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();

  bool circular = false;

  void validateAndSave() async {
    print("111111");
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        circular = true;
      });
      Map<String, String> data = {
        "phone": _phoneController.text,
      };
      print(data);

      var request = http.MultipartRequest(
          'POST', Uri.parse('https://robotek.frantic.in/RestApi/login_user'));
      request.headers.addAll({
        "Content-Type": "multipart/form-data",
        "Accept": "multipart/form-data",
      });
      request.fields['phone'] = _phoneController.text;
      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> output = json.decode(responsed.body);
        print(output);
        if (output["response_string"] == "Ok") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => otpVerification(
                  response: output["response_string"],
                  phoneNumber: _phoneController.text,
                  otp: output["data"],
                ),
              ),
              (route) => false);
        }
      } else {
        showSnackBar(
          duration: Duration(milliseconds: 10000),
          context: context,
          message: "Please Enter a Valid Phone Number",
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
          height: MediaQuery.of(context).size.height - 120,
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
                      'assets/sign-page-abstract-concept-illustration_335657-2242.jpg'),
                ),
                Container(
                  width: 320,
                  child: Column(
                    children: [
                      Text(
                        'Enter your phone number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: colorResource.primaryColor2),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      Text(
                        'We will send a code (via SMS text message) to your phone number',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Container(
                    height: 55,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Color(0xffefefef),
                        border: Border.all(color: Colors.black12, width: 1.0)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CountryCodePicker(
                          onChanged: print,
                          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                          initialSelection: 'IN',
                          favorite: ['+91', 'IN'],
                          // optional. Shows only country name and flag
                          showCountryOnly: false,
                          // optional. Shows only country name and flag when popup is closed.
                          showOnlyCountryWhenClosed: false,
                          // optional. aligns the flag and the Text left
                          alignLeft: false,
                        ),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            validator: phoneValidator,
                            controller: _phoneController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone Number",
                            ),
                            onChanged: (value) {
                              var number = value.toString();
                            },
                          ),
                        ),
                        Container(
                          key: Key("tickMark"),
                          margin: EdgeInsets.all(10),
                          height: 24,
                          width: 24,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(22),
                          ),
                        )
                      ],
                    )),
                InkWell(
                  child: Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        color: colorResource.primaryColorLight,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                      child: Text(
                        'Send OTP',
                        style: TextStyle(color: Colors.white, fontSize: 19),
                      ),
                    ),
                  ),
                  onTap: () {
                    validateAndSave();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void initState() {
    // TODO: implement initState
    super.initState();

    Constants.dealer = true;
  }
}
