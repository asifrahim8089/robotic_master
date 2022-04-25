// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print, prefer_final_fields, unnecessary_new, file_names, unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:robotek/Authfiles/resaler_login.dart';
import 'package:robotek/Commons/SnackBar.dart';
import 'package:robotek/Commons/validators.dart';
import 'package:robotek/Commons/colorResource.dart';
import 'package:robotek/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpUser extends StatefulWidget {
  final String phoneNumber;
  const SignUpUser({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  _SignUpUserState createState() => _SignUpUserState();
}

class _SignUpUserState extends State<SignUpUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool circular = false;
  var dealerdetails;
  void validateAndSave() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        circular = true;
      });
      Map<String, String> data = {
        "phone": widget.phoneNumber,
        "email": _emailController.text,
        "name": _nameController.text,
        "gender": selectedValue.toString(),
      };
      print(data);

      var request = http.MultipartRequest('POST',
          Uri.parse('https://robotek.frantic.in/RestApi/register_reseller'));
      request.headers.addAll({
        "Content-Type": "multipart/form-data",
        "Accept": "multipart/form-data",
      });
      request.fields['phone'] = widget.phoneNumber;
      request.fields['email'] = _emailController.text;
      request.fields['name'] = _nameController.text;
      request.fields['gender'] = selectedValue.toString();
      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> output = json.decode(responsed.body);
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
            (route) => false);
        // }
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
        preferredSize: Size.fromHeight(32.0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,

          leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (Context) => EnterYourNumber()));
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
              "Registration",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xff3E3C3C),
              ),
            ),
          ),
          centerTitle: false,

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //
          //   children: [
          //
          //
          //
          //
          //
          //
          //
          //     GestureDetector(
          //         onTap: (){
          //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (Context)=>Home()));
          //         },
          //
          //         child: ImageIcon( AssetImage("assets/cancel.png", ), color: Colors.black,size: 40,)),
          //   ],
          // ),
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
                  child:
                      Image.asset('assets/istockphoto-1286081871-170667a.png'),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50),
                ),
                Container(
                    height: 45,
                    width: 300,
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        color: Color(0xffefefef),
                        border: Border.all(color: Colors.black12, width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: nameValidator,
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Name",
                            ),
                            // onChanged: (value) {
                            //   var number = value.toString();
                            // },
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Container(
                    height: 45,
                    width: 300,
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        color: Color(0xffefefef),
                        border: Border.all(color: Colors.black12, width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: nameValidator,
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                            ),
                            // onChanged: (value) {
                            //   var number = value.toString();
                            // },
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Container(
                    height: 45,
                    width: 300,
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        color: Color(0xffefefef),
                        border: Border.all(color: Colors.black12, width: 1.0),
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            controller: _phoneController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: widget.phoneNumber,
                            ),
                            // onChanged: (value) {
                            //   var number = value.toString();
                            // },
                          ),
                        ),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Container(
                  height: 45,
                  width: 300,
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                      color: Color(0xffefefef),
                      border: Border.all(color: Colors.black12, width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      },
                      buttonHeight: 55,
                      buttonWidth: 300,
                      itemHeight: 40,
                    ),
                  ),
                ),
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
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  onTap: () {
                    validateAndSave();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (Context) => Home()));
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

  String? selectedValue;
  List<String> items = ['MALE', 'FEMALE', 'OTHERS'];
}
