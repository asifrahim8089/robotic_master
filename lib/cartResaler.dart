// ignore_for_file: avoid_print, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:robotek/Commons/SnackBar.dart';
import 'package:robotek/Commons/colorResource.dart';
import 'package:robotek/Commons/zerostate.dart';

import 'customDialogBox.dart';

class CartResaler extends StatefulWidget {
  final dealerid;
  final usertype;
  const CartResaler({Key? key, this.dealerid, this.usertype}) : super(key: key);

  @override
  _CartResalerState createState() => _CartResalerState();
}

class _CartResalerState extends State<CartResaler> {
  var cartdata;
  void fetchCart() async {
    Map<String, String> data = {
      "user_type": widget.usertype,
      "user_id": widget.dealerid,
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://robotek.frantic.in/RestApi/fetch_cart'));
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Accept": "multipart/form-data",
    });
    request.fields['user_type'] = widget.usertype;
    request.fields['user_id'] = widget.dealerid;
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      Map<String, dynamic> output = json.decode(responsed.body);
      setState(() {
        cartdata = output["data"];
      });
    } else {
      showSnackBar(
        duration: Duration(milliseconds: 10000),
        context: context,
        message: "Error",
      );
    }
  }

  @override
  void initState() {
    fetchCart();

    super.initState();
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
          title: Text(
            "Review items",
            style: TextStyle(
              color: colorResource.primaryColor2,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: cartdata == null
              ? zerostate(
                  size: 180,
                  height: 800,
                  icon: 'assets/nosearch.svg',
                  head: 'A Little Empty',
                  sub: 'Add items to fill me up!',
                )
              : Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 40)),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cartdata.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  cartdata[index]["category_name"].toString(),
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    // margin: EdgeInsets.only(
                                    //     bottom: 20, left: 40, right: 40),
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 2,
                                            // changes position of shadow
                                          ),
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            // ignore: prefer_const_literals_to_create_immutables
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  cartdata[index]
                                                          ["product_name"]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      decorationColor:
                                                          colorResource
                                                              .primaryColor),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          child: Center(
                                              child: Text(
                                            cartdata[index]["qty"].toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )),
                                          decoration: BoxDecoration(
                                              color:
                                                  colorResource.primaryColor2,
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: cartdata == null
          ? null
          : SizedBox(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomDialogBox(
                            title: "Rules",
                            descriptions:
                                "1. Rewards will be given after 1 day of competition ends."
                                "\n\n\n\n\n",
                            text: "Yes",
                            cartdata: cartdata,
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                        color: colorResource.primaryColor2,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Share",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: 35,
                            height: 35,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                                child: Image.asset(
                              "assets/share (2).png",
                              color: Colors.grey,
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
