import 'dart:convert';

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:robotek/Commons/colorResource.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'Components/product_card.dart';

class Home extends StatefulWidget {
  final dealerdetails;
  const Home({Key? key, this.dealerdetails}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double height = 40;
  double width = 160;
  AutoScrollController scrollController = AutoScrollController();
  List<GlobalKey<ExpansionTileCardState>> cardKeys = [];
  var data;
  var slider;
  Color colorContainer = colorResource.primaryColor2;
  bool categoryVis = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 25,
              width: 25.0,
              child: Image.asset(
                "assets/search (1).png",
                height: 25,
              ),
            ),
          ),
        ],
      ),
      body: data == null
          ? loadingShimmer()
          : CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: 180,
                    margin: const EdgeInsets.all(10),
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
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 280,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(5),
                                      // ignore: prefer_const_literals_to_create_immutables
                                      boxShadow: [
                                        const BoxShadow(
                                            color: const Color(0x48EEEEEE),
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
                ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
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
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      cardKeys.add(GlobalKey());
                      return AutoScrollTag(
                        controller: scrollController,
                        key: ValueKey(index),
                        index: index,
                        child: buildExpansionTileCard(index, context),
                      );
                    },
                    childCount: data.length,
                  ),
                ),
                const SliverPadding(
                  padding: EdgeInsets.only(
                    bottom: 150,
                  ),
                ),
              ],
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
                await Future.delayed(const Duration(milliseconds: 400));
                setState(() {
                  categoryVis = false;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: width,
                // height: height,
                child: categoryVis
                    ? SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: const [
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
                        padding: const EdgeInsets.only(left: 10, top: 5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    scrollController.scrollToIndex(
                                      index,
                                      preferPosition: AutoScrollPosition.middle,
                                    );
                                    cardKeys[index].currentState?.expand();
                                    setState(() {
                                      categoryVis = true;
                                      colorContainer =
                                          colorResource.primaryColor2;
                                    });
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                        data[index]["category"]["name"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        width: width - 20,
                                        height: 1,
                                        color: Colors.black,
                                        margin: const EdgeInsets.only(
                                            top: 4, bottom: 4),
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
                                  child: const Center(
                                    child: const Text(
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
            const SizedBox(
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
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                "0 Items",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                        const Text(
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
                      margin: const EdgeInsets.fromLTRB(20, 40, 00, 40),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/businessMale.png',
                            height: 50,
                          ),
                          const Padding(padding: EdgeInsets.only(left: 20)),
                          Expanded(
                            child: Text(
                              "Hi, ${getuser.user["name"]}".toUpperCase(),
                              style: const TextStyle(
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
                      icon: const Icon(Icons.shopping_cart),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (Context) => const MyOrdersDealer()));
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
                                builder: (Context) => const TermsCondition()));
                      },
                      icon: Image.asset('assets/team.png'),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (Context) => const TermsCondition()));
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
                              builder: (Context) => const CustomerSupport()));
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
                                builder: (Context) => const TermsCondition()));
                      },
                      icon: Image.asset('assets/terms-and-conditions.png'),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (Context) => const TermsCondition()));
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
                                builder: (Context) => const TermsCondition()));
                      },
                      icon: Image.asset('assets/privacy-policy (1).png'),
                    ),
                    onTap: () {
                      // Update the state of the app.
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (Context) => const TermsCondition()));
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
                      icon: const Icon(Icons.logout),
                    ),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SelectUser(),
                          ),
                          (route) => false);
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 40, 00, 40),
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

  ExpansionTileCard buildExpansionTileCard(int index, BuildContext context) {
    return ExpansionTileCard(
      onExpansionChanged: (value) {
        if (value) {
          Future.delayed(const Duration(milliseconds: 500), () {
            for (var i = 0; i < cardKeys.length; i++) {
              if (index != i) {
                cardKeys[i].currentState?.collapse();
              }
            }
          });
        }
      },
      key: cardKeys[index],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 15,
            height: 18,
            child: Image.asset(
              "assets/fast-forward.png",
              color: Colors.yellow,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            data[index]["category"]["name"].toUpperCase(),
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
                decorationColor: colorResource.primaryColor),
          ),
        ],
      ),
      trailing: SizedBox(
        width: 30,
        height: 25,
        child: Image.asset("assets/download (1).png"),
      ),

      // ignore: prefer_const_literals_to_create_immutables
      children: <Widget>[
        ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data[index]["products"].length,
            itemBuilder: (BuildContext context, int indexproducts) {
              return Product(
                data[index]["products"][indexproducts],
                widget.dealerdetails,
              );
            })
      ],
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
