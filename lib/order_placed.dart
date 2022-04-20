// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:robotek/home.dart';

class OrderPlaced extends StatefulWidget {
  final dealerid;
  const OrderPlaced({
    Key? key,
    this.dealerid,
  }) : super(key: key);

  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/tick.json',
              width: 200,
              animate: true,
              repeat: true,
              height: 200,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Order Placed',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),

            // Text(
            //   '${outputDate(item["createdAt"])}',
            //   style: kHeadSubTitle,
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  Text(
                    'Sit back and Relax\n Your order has been Successfully placed.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.normal),
                  ),
                  Container(
                    height: 40,
                    width: 200,
                    margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                      color: Color(0xffE4C013),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextButton(
                      child: Text(
                        'Go Home',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (Context) => Home(
                                dealerdetails: widget.dealerid,
                              ),
                            ),
                            (route) => false);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
