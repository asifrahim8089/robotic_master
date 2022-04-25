// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robotek/Commons/colorResource.dart';
import 'package:robotek/Providers/get_data_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget expansionInnercard(
    {@required category,
    @required products,
    @required userid,
    required BuildContext context}) {
  final List<TextEditingController> _controllers = [];
  return ExpansionTile(
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
        SizedBox(
          width: 10,
        ),
        Text(
          category["name"].toUpperCase(),
          style: TextStyle(
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
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (BuildContext context, int indexproducts) {
            _controllers.add(TextEditingController());
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: SizedBox(
                    width: 70,
                    child: Image.network(
                      "https://www.freepnglogos.com/uploads/airpods-png/airpods-apply-airpod-skins-mightyskins-3.png",
                      height: 60,
                      fit: BoxFit.fitHeight,
                      alignment: Alignment.bottomLeft,
                    )),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      products[indexproducts]["name"].toString(),
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${products[indexproducts]["details"]} PCS",
                      style: TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
                trailing: Container(
                  width: 70,
                  height: 30,
                  child: Container(
                    margin: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 2, color: Colors.white)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                      ),
                      child: Center(
                        child: TextFormField(
                          controller: _controllers[indexproducts],
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontSize: 14, color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (value) async {
                            SharedPreferences dealer =
                                await SharedPreferences.getInstance();
                            var status = dealer.getBool('isDealer') ?? false;
                            Provider.of<GetDataProvider>(context, listen: false)
                                .addtocart(
                                    product_id: products[indexproducts]["id"],
                                    user_id: userid,
                                    qty: _controllers[indexproducts].text,
                                    user_type: status ? "DEALER" : "RESELLER",
                                    context: context);
                            Provider.of<GetDataProvider>(context, listen: false)
                                .fetchCart(context, userid);
                          },
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            );
          })
    ],
  );
}
