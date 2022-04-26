import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Providers/get_data_provider.dart';

class Product extends StatelessWidget {
  final data;
  final dealerdetails;
  Product(this.data, this.dealerdetails, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          children: [
            Text(
              data["name"].toString(),
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "${data["details"]} PCS",
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
        trailing: Container(
          width: 70,
          height: 30,
          child: Container(
            margin: const EdgeInsets.all(2),
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
                  // controller: _controller,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  onChanged: (value) async {
                    SharedPreferences dealer =
                        await SharedPreferences.getInstance();
                    var status = dealer.getBool('isDealer') ?? false;
                    Provider.of<GetDataProvider>(context, listen: false)
                        .addtocart(
                            product_id: data["id"],
                            user_id: dealerdetails,
                            qty: value,
                            user_type: status ? "DEALER" : "RESELLER",
                            context: context);
                    Provider.of<GetDataProvider>(context, listen: false)
                        .fetchCart(context, dealerdetails);
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
  }
}
