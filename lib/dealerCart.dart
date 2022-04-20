// ignore_for_file: avoid_print, prefer_const_constructors, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:robotek/Commons/SnackBar.dart';
import 'package:robotek/Commons/colorResource.dart';
import 'package:robotek/Commons/zerostate.dart';
import 'package:robotek/order_placed.dart';

class DealerCart extends StatefulWidget {
  final dealerid;
  final usertype;
  const DealerCart({Key? key, this.dealerid, this.usertype}) : super(key: key);

  @override
  _DealerCartState createState() => _DealerCartState();
}

class _DealerCartState extends State<DealerCart> {
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
      print(cartdata);
    } else {
      showSnackBar(
        duration: Duration(milliseconds: 10000),
        context: context,
        message: "Error",
      );
    }
  }

  void placeOrder() async {
    Map<String, String> data = {
      "user_type": widget.usertype,
      "user_id": widget.dealerid,
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://robotek.frantic.in/RestApi/place_order'));
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
      print(output);
      showSnackBar(
        duration: Duration(milliseconds: 10000),
        context: context,
        message: "ORDER PLACED SUCCESSFULLY",
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (Context) => OrderPlaced(
              dealerid: widget.dealerid,
            ),
          ),
          (route) => false);
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
        preferredSize: Size.fromHeight(50.0),
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
            "My cart",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          centerTitle: false,
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
                    // Padding(padding: EdgeInsets.only(top: 20)),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cartdata.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
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
                                Container(
                                  margin: EdgeInsets.only(
                                      bottom: 20, left: 0, right: 0),
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  height: 60,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0,
                                          blurRadius: 3,
                                          // changes position of shadow
                                        ),
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            "https://www.freepnglogos.com/uploads/airpods-png/airpods-apply-airpod-skins-mightyskins-3.png",
                                            height: 50,
                                            fit: BoxFit.fitHeight,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10)),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartdata[index]["product_name"]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 5),
                                              ),
                                              Text(
                                                cartdata[index]
                                                        ["product_details"]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            cartdata[index]["qty"].toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(3),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: () {
                          // print("order placed");
                          placeOrder();
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: Center(
                            child: Text(
                              "Place Order",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: colorResource.primaryColor2,
                              borderRadius: BorderRadius.circular(04),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 3,
                                  // changes position of shadow
                                ),
                              ]),
                        ),
                      ),
                    ),
                    // Container(
                    //   width: 350,
                    //   margin: EdgeInsets.only(bottom: 40, left: 0, right: 0),
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(20),
                    //       boxShadow: [
                    //         BoxShadow(
                    //           color: Colors.grey.withOpacity(0.5),
                    //           spreadRadius: 0,
                    //           blurRadius: 3,
                    //           // changes position of shadow
                    //         ),
                    //       ]),
                    //   child: Container(
                    //     margin: EdgeInsets.only(left: 20, right: 20),
                    //     child: Column(
                    //       children: [
                    //         Padding(padding: EdgeInsets.only(top: 13)),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: const [
                    //             Text(
                    //               "Subtotal",
                    //               style: TextStyle(fontSize: 16),
                    //             ),
                    //             Text(
                    //               "10000",
                    //               style: TextStyle(fontSize: 16),
                    //             ),
                    //           ],
                    //         ),
                    //         Padding(padding: EdgeInsets.only(top: 13)),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: const [
                    //             Text(
                    //               "Discount (10%)",
                    //               style: TextStyle(fontSize: 16),
                    //             ),
                    //             Text(
                    //               "1000",
                    //               style: TextStyle(fontSize: 16),
                    //             ),
                    //           ],
                    //         ),
                    //         Padding(padding: EdgeInsets.only(top: 13)),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: const [
                    //             Text(
                    //               "Shipping Charges",
                    //               style: TextStyle(fontSize: 16),
                    //             ),
                    //             Text(
                    //               "30",
                    //               style: TextStyle(fontSize: 16),
                    //             ),
                    //           ],
                    //         ),
                    //         Padding(padding: EdgeInsets.only(top: 18)),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: const [
                    //             Text(
                    //               "total",
                    //               style: TextStyle(
                    //                   fontSize: 18,
                    //                   fontWeight: FontWeight.bold,
                    //                   color: colorResource.primaryColor2),
                    //             ),
                    //             Text(
                    //               "9,930",
                    //               style: TextStyle(fontSize: 16),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
        ),
      ),
    );
  }
}
