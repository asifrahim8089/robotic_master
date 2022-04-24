// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, avoid_print, deprecated_member_use, unnecessary_new, prefer_collection_literals, non_constant_identifier_names, unrelated_type_equality_checks, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unused_field

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotek/Commons/SnackBar.dart';
import 'package:robotek/Commons/colorResource.dart';
import 'package:robotek/Commons/zerostate.dart';
import 'package:robotek/Components/cart_bottom_card.dart';
import 'package:robotek/Components/home_expansioncard.dart';
import 'package:robotek/Providers/get_data_provider.dart';
import 'package:robotek/Shimmers/bannerdummy.dart';
import 'package:robotek/Shimmers/checkoutdummy.dart';
import 'package:robotek/cartResaler.dart';
import 'package:robotek/customerSupport.dart';
import 'package:robotek/dealerCart.dart';
import 'package:robotek/myOrdersDealer.dart';
import 'package:robotek/selectUser.dart';
import 'package:robotek/terms&Conditions.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final dealerdetails;
  const Home({Key? key, this.dealerdetails}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double height = 40;
  double width = 160;
  final itemScrollController = ItemScrollController();
  var data;
  var slider;
  Color colorContainer = colorResource.primaryColor2;
  bool categoryVis = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = [];
  bool circular = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
//GetProductData
  Future getData(context) async {
    final Uri url = Uri.parse('http://robotek.frantic.in/RestApi/products');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        data = jsonData["data"];
      });
      // print(jsonData["data"]);
    } else {
      print("No data available");
    }
  }

//Get Sliders

  Future getslider(context) async {
    final Uri url = Uri.parse('http://robotek.frantic.in/RestApi/slider');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    var jsonData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        slider = jsonData["data"];
      });
    } else {
      print("No data available");
    }
  }

  Future scrollToItem(val) async {
    print(val);
    itemScrollController.scrollTo(
      curve: Curves.easeInOut,
      index: val + 1,
      duration: Duration(
        milliseconds: 400,
      ),
    );
  }

  @override
  void initState() {
    getData(context);
    Provider.of<GetDataProvider>(context, listen: false)
        .fetch_dealer(context, widget.dealerdetails);
    Provider.of<GetDataProvider>(context, listen: false)
        .fetchCart(context, widget.dealerdetails);
    getslider(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => scaffoldKey.currentState?.openDrawer(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/category.png",
            ),
          ),
        ),
        leadingWidth: 40,
        centerTitle: true,
        title: Image.asset(
          "assets/RobotekLogo.png",
          height: 30,
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Container(
              height: 25,
              width: 25.0,
              child: new Image.asset(
                "assets/search (1).png",
                height: 25,
              ),
            ),
          ),
        ],
      ),
      body: data == null
          ? loadingShimmer()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 180,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 2,
                        itemBuilder: (context, int index) {
                          return slider == null
                              ? bannerShimmer()
                              : Container(
                                  margin: EdgeInsets.only(right: 10),
                                  width: 280,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(5),
                                    // ignore: prefer_const_literals_to_create_immutables
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0x48EEEEEE),
                                          spreadRadius: 4,
                                          blurRadius: 20)
                                    ],
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "https://robotek.frantic.in/uploads/" +
                                              slider[index]["image"]),
                                    ),
                                  ),
                                );
                        }),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        "CATEGORIES",
                        style: TextStyle(
                            color: colorResource.primaryColorLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Flexible(
                        child: Text(
                          "DOWLOAD CATALOGUE",
                          style: TextStyle(
                              color: colorResource.primaryColor2,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                      )
                    ],
                  ),
                  ScrollablePositionedList.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemScrollController: itemScrollController,
                    itemCount: data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index1) {
                      return expansionInnercard(
                        category: data[index1]["category"],
                        products: data[index1]["products"],
                        userid: widget.dealerdetails,
                        context: context,
                      );
                    },
                  ),
                ],
              ),
            ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        // height: 40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            InkWell(
              onTap: () async {
                setState(() {
                  width = 160;
                  height = 100;
                  colorContainer = Colors.white;
                });
                await Future.delayed(Duration(milliseconds: 400));
                setState(() {
                  categoryVis = false;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                width: width,
                // height: height,
                child: categoryVis
                    ? SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            Icon(
                              Icons.menu,
                              size: 20,
                            ),
                            Text(
                              "Browse Categories",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () => setState(() {
                                    scrollToItem(index).then((value) {
                                      categoryVis = true;
                                      height = 60;
                                      width = 160;
                                      colorContainer =
                                          colorResource.primaryColor2;
                                    });
                                  }),
                                  child: Column(
                                    children: [
                                      Text(
                                        data[index]["category"]["name"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        width: width - 20,
                                        height: 1,
                                        color: Colors.black,
                                        margin:
                                            EdgeInsets.only(top: 4, bottom: 4),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ), // Text

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    categoryVis = true;
                                    height = 60;
                                    width = 160;
                                    colorContainer =
                                        colorResource.primaryColor2;
                                  });
                                },
                                child: Container(
                                  width: width - 20,
                                  height: 20,
                                  child: Center(
                                    child: Text(
                                      "Close",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  // margin: EdgeInsets.only(top: 4, bottom: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                decoration: BoxDecoration(
                  color: colorContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Consumer<GetDataProvider>(
              builder: (context, data, child) {
                return InkWell(
                  onTap: () {
                    selectUser();
                  },
                  child: Container(
                    width: 370,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        data.cartdata != null
                            ? Text(
                                "${data.cartdata.length.toString()}\tItems",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                "0 Items",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                        Text(
                          "Review List",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectUser() async {
    SharedPreferences dealer = await SharedPreferences.getInstance();
    var status = dealer.getBool('isDealer') ?? false;

    if (status) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DealerCart(
            dealerid: widget.dealerdetails,
            usertype: "DEALER",
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartResaler(
            dealerid: widget.dealerdetails,
            usertype: "RESELLER",
          ),
        ),
      );
    }
  }
}
