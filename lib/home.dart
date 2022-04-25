// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, avoid_print, deprecated_member_use, unnecessary_new, prefer_collection_literals, non_constant_identifier_names, unrelated_type_equality_checks, unnecessary_null_comparison, prefer_typing_uninitialized_variables, unused_field, unused_element

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
import 'package:scroll_to_index/scroll_to_index.dart';
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
  // ignore: prefer_final_fields
  ItemScrollController _scrollController = ItemScrollController();

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
    _scrollController.scrollTo(
      curve: Curves.slowMiddle,
      alignment: 0.5,
      index: val + 1,
      duration: Duration(
        milliseconds: 1000,
      ),
    );
    print(val + 1);
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
    final getuser = Provider.of<GetDataProvider>(context);
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
                              : Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
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
                                  ),
                                );
                        }),
                  ),
                  Padding(padding: EdgeInsets.only(top: 25)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
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
                  ),
                  ScrollablePositionedList.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemScrollController: _scrollController,
                    itemCount: data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return expansionInnercard(
                        category: data[index]["category"],
                        products: data[index]["products"],
                        userid: widget.dealerdetails,
                        context: context,
                      );
                    },
                  ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
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
                              child: GestureDetector(
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
                return GestureDetector(
                  onTap: () {
                    selectUser();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
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
      drawer: getuser.user == null
          ? loadingShimmer()
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 40, 00, 40),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/businessMale.png',
                            height: 50,
                          ),
                          Padding(padding: EdgeInsets.only(left: 20)),
                          Expanded(
                            child: Text(
                              "Hi, ${getuser.user["name"]}".toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )),
                  ListTile(
                    title: const Text(
                      'My Orders',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.shopping_cart),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (Context) => MyOrdersDealer()));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'About Us',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (Context) => TermsCondition()));
                      },
                      icon: Image.asset('assets/team.png'),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (Context) => TermsCondition()));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Contact Us',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: IconButton(
                      onPressed: () {},
                      icon: Image.asset('assets/support.png'),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (Context) => CustomerSupport()));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Terms & Conditions',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (Context) => TermsCondition()));
                      },
                      icon: Image.asset('assets/terms-and-conditions.png'),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (Context) => TermsCondition()));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Privacy Policy',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (Context) => TermsCondition()));
                      },
                      icon: Image.asset('assets/privacy-policy (1).png'),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (Context) => TermsCondition()));
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'FAQ',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: IconButton(
                      onPressed: () {},
                      icon: Image.asset('assets/faq.png'),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      // ...
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Logout',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.logout),
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelectUser(),
                          ),
                          (route) => false);
                    },
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 40, 00, 40),
                    child: Image.asset(
                      'assets/RobotekLogo.png',
                      height: 90,
                    ),
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
