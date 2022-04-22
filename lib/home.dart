// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, avoid_print, deprecated_member_use, unnecessary_new, prefer_collection_literals, non_constant_identifier_names, unrelated_type_equality_checks, unnecessary_null_comparison, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:robotek/Commons/SnackBar.dart';
import 'package:robotek/Commons/colorResource.dart';
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
  var cartdata;
  var cartitem;
  var slider;
  var user;
  var delete;
  Color colorContainer = colorResource.primaryColor2;

  bool categoryVis = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = [];

  // final TextEditingController _qtyController = TextEditingController();

  bool circular = false;

  void fetch_dealer(context) async {
    Map<String, String> data = {
      "id": widget.dealerdetails.toString(),
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://robotek.frantic.in/RestApi/fetch_dealer'));
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Accept": "multipart/form-data",
    });
    request.fields['id'] = widget.dealerdetails.toString();

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> output = json.decode(responsed.body);
      setState(() {
        user = output["data"];
      });
    } else {
      showSnackBar(
        duration: Duration(milliseconds: 1000),
        context: context,
        message: "Not added",
      );
    }
  }

  void addtocart({
    required String qty,
    required String product_id,
    required String user_id,
    required String user_type,
  }) async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      setState(() {
        circular = true;
      });
      Map<String, String> data = {
        "product_id": product_id,
        "user_id": user_id,
        "qty": qty,
        "user_type": user_type,
      };

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://robotek.frantic.in/RestApi/add_to_cart'));
      request.headers.addAll({
        "Content-Type": "multipart/form-data",
        "Accept": "multipart/form-data",
      });
      request.fields['product_id'] = product_id;
      request.fields['user_id'] = user_id;
      request.fields['qty'] = qty;
      request.fields['user_type'] = user_type;
      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> output = json.decode(responsed.body);
        setState(() {
          cartitem = output["data"];
        });

        if (cartitem == null) {
          delete_cart_item(product_id);
        }
      } else {
        showSnackBar(
          duration: Duration(milliseconds: 1000),
          context: context,
          message: "Not added",
        );
      }
    }
  }

  void delete_cart_item(String product_id) async {
    Map<String, String> data = {
      "cart_item_id": product_id,
    };

    var request = http.MultipartRequest('POST',
        Uri.parse('http://robotek.frantic.in/RestApi/delete_cart_item'));
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Accept": "multipart/form-data",
    });
    request.fields['cart_item_id'] = product_id;

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> output = json.decode(responsed.body);
      print(output);
      setState(() {
        delete = output["data"];
        print(delete);
      });
    } else {
      showSnackBar(
        duration: Duration(milliseconds: 1000),
        context: context,
        message: "Could not delete",
      );
    }
  }

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
    itemScrollController.scrollTo(
      curve: Curves.linear,
      alignment: 0.5,
      index: val,
      duration: Duration(
        milliseconds: 1000,
      ),
    );
    print(val);
  }

  @override
  void initState() {
    fetch_dealer(context);
    getData(context);
    getslider(context);
    fetchCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Container(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/category.png",
                      height: 25,
                    ),
                    Image.asset(
                      "assets/RobotekLogo.png",
                      height: 30,
                    ),
                    Image.asset(
                      "assets/search (1).png",
                      height: 25,
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 25)),
                GestureDetector(
                  onTap: () {},
                  child: Container(
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
                data == null
                    ? loadingShimmer()
                    : ScrollablePositionedList.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemScrollController: itemScrollController,
                        itemBuilder: (BuildContext context, int indexcategory) {
                          return InkWell(
                            onTap: () {},
                            child: ExpandablePanel(
                              theme: ExpandableThemeData(
                                hasIcon: false,
                                headerAlignment:
                                    ExpandablePanelHeaderAlignment.bottom,
                              ),
                              header: Container(
                                margin: EdgeInsets.only(bottom: 20),
                                padding: EdgeInsets.only(left: 20, right: 20),
                                width: MediaQuery.of(context).size.width,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 2,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 15,
                                                      height: 18,
                                                      child: Image.asset(
                                                        "assets/fast-forward.png",
                                                        color: Colors.yellow,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 10),
                                                      child: Text(
                                                        data[indexcategory]
                                                                    ["category"]
                                                                ["name"]
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            decorationColor:
                                                                colorResource
                                                                    .primaryColor),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                      height: 25,
                                      child: Image.asset(
                                          "assets/download (1).png"),
                                    )
                                  ],
                                ),
                              ),
                              collapsed: Column(),
                              expanded: Column(
                                children: [
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: int.parse(data[indexcategory]
                                        ["products_count"]["count"]),
                                    itemBuilder: (BuildContext context,
                                        int indexproducts) {
                                      _controllers
                                          .add(new TextEditingController());
                                      return Container(
                                        padding: EdgeInsets.all(5),
                                        margin:
                                            EdgeInsets.fromLTRB(00, 00, 00, 10),
                                        decoration: BoxDecoration(),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                    width: 70,
                                                    child: Image.network(
                                                      "https://www.freepnglogos.com/uploads/airpods-png/airpods-apply-airpod-skins-mightyskins-3.png",
                                                      height: 60,
                                                      fit: BoxFit.fitHeight,
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                    )),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  // ignore: prefer_const_literals_to_create_immutables
                                                  children: [
                                                    Text(
                                                      data[indexcategory][
                                                                      "products"]
                                                                  [
                                                                  indexproducts]
                                                              ["name"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 5),
                                                    ),
                                                    Text(
                                                      data[indexcategory][
                                                                      "products"]
                                                                  [
                                                                  indexproducts]
                                                              ["details"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "PCS",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(3),
                                                ),
                                                Container(
                                                  width: 70,
                                                  height: 30,
                                                  child: Container(
                                                    margin: EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                        color: Colors.black26,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                            width: 2,
                                                            color:
                                                                Colors.white)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 10.0,
                                                      ),
                                                      child: Center(
                                                        child: TextFormField(
                                                          controller:
                                                              _controllers[
                                                                  indexproducts],
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white),
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                          ),
                                                          onChanged:
                                                              (value) async {
                                                            SharedPreferences
                                                                dealer =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            var status =
                                                                dealer.getBool(
                                                                        'isDealer') ??
                                                                    false;

                                                            addtocart(
                                                              product_id: data[
                                                                              indexcategory]
                                                                          [
                                                                          "products"]
                                                                      [
                                                                      indexproducts]["id"]
                                                                  .toString(),
                                                              user_id: widget
                                                                  .dealerdetails
                                                                  .toString(),
                                                              qty: _controllers[
                                                                      indexproducts]
                                                                  .text,
                                                              user_type: status
                                                                  ? "DEALER"
                                                                  : "RESELLER",
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black26,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 20))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                Padding(padding: EdgeInsets.only(bottom: 120))
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 350,
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
                                  onTap: () => scrollToItem(index),
                                  // onTap: () => scrollToItem(index),
                                  // .then((value) => Navigator.pop(context)),
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
            Padding(padding: EdgeInsets.only(top: 5)),
            InkWell(
              onTap: () {
                selectUser();
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (Context) => DealerCart()));

                // toCart();
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
                    cartdata != null
                        ? Text(
                            "${cartdata.length.toString()}\tItems",
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
            ),
          ],
        ),
      ),
      drawer: user == null
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
                              "Hi, ${user["name"]}".toUpperCase(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void fetchCart() async {
    SharedPreferences dealer = await SharedPreferences.getInstance();
    var status = dealer.getBool('isDealer') ?? false;
    Map<String, String> data = {
      "user_type": status ? "DEALER" : "RESELLER",
      "user_id": widget.dealerdetails,
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://robotek.frantic.in/RestApi/fetch_cart'));
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Accept": "multipart/form-data",
    });
    request.fields['user_type'] = status ? "DEALER" : "RESELLER";
    request.fields['user_id'] = widget.dealerdetails;
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      Map<String, dynamic> output = json.decode(responsed.body);
      setState(() {
        cartdata = output["data"];
        cartdata == null
            ? print("0")
            : print("cart length is :${cartdata.length}");
      });
    } else {
      showSnackBar(
        duration: Duration(milliseconds: 10000),
        context: context,
        message: "Error",
      );
    }
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
          ));
    }
  }
}
