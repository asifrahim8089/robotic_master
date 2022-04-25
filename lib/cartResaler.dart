// ignore_for_file: avoid_print, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotek/Commons/colorResource.dart';
import 'package:robotek/Commons/zerostate.dart';
import 'package:robotek/Providers/get_data_provider.dart';

import 'customDialogBox.dart';

class CartResaler extends StatefulWidget {
  final dealerid;
  final usertype;
  const CartResaler({Key? key, this.dealerid, this.usertype}) : super(key: key);

  @override
  _CartResalerState createState() => _CartResalerState();
}

class _CartResalerState extends State<CartResaler> {
  @override
  void initState() {
    Provider.of<GetDataProvider>(context, listen: false)
        .fetchCart(context, widget.dealerid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final getcart = Provider.of<GetDataProvider>(context);
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
          child: getcart.cartdata == null
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
                      itemCount: getcart.cartdata.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      getcart.cartdata[index]["category_name"]
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: IconButton(
                                        onPressed: () async {
                                          await getcart.delete_cart_item(
                                              getcart.cartdata[index]["id"],
                                              widget.dealerid,
                                              index,
                                              context);
                                        },
                                        icon: Icon(
                                          Icons.delete_forever,
                                          color: Colors.black,
                                        )),
                                  )
                                ],
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
                                                  getcart.cartdata[index]
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
                                            getcart.cartdata[index]["qty"]
                                                .toString(),
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
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
        ),
      ),
      floatingActionButton: getcart.cartdata == null
          ? null
          : SizedBox(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
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
                            cartdata: getcart.cartdata,
                            userid: null,
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
