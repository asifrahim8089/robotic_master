// ignore_for_file: avoid_print, non_constant_identifier_names, prefer_typing_uninitialized_variables, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:robotek/Commons/SnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetDataProvider extends ChangeNotifier {
  bool loading = true;
  var data;
  var cartdata;
  var cartitem;
  var slider;
  var user;
  var delete;

  //* ADD TO CART
  Future addtocart({
    required context,
    required String qty,
    required String product_id,
    required String user_id,
    required String user_type,
  }) async {
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

      cartitem = output["data"];
      print(cartitem);

      // if (cartitem == null) {
      //   delete_cart_item(product_id,user, context);
      // }
    } else {
      showSnackBar(
        duration: Duration(milliseconds: 1000),
        context: context,
        message: "Not added",
      );
    }
    notifyListeners();
  }

//* DELETE FROM CART
  Future delete_cart_item(
      String product_id, dealerid, int index, context) async {
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
      delete = output["data"];
      fetchCart(context, dealerid);
    } else {
      showSnackBar(
        duration: Duration(milliseconds: 1000),
        context: context,
        message: "Could not delete",
      );
    }
    cartdata.removeAt(index);
    notifyListeners();
  }

  //FetchCart details

  void fetchCart(context, dealerdetails) async {
    print("fetch cart");
    SharedPreferences dealer = await SharedPreferences.getInstance();
    var status = dealer.getBool('isDealer') ?? false;
    Map<String, String> data = {
      "user_type": status ? "DEALER" : "RESELLER",
      "user_id": dealerdetails,
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://robotek.frantic.in/RestApi/fetch_cart'));
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Accept": "multipart/form-data",
    });
    request.fields['user_type'] = status ? "DEALER" : "RESELLER";
    request.fields['user_id'] = dealerdetails;
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      Map<String, dynamic> output = json.decode(responsed.body);
      cartdata = output["data"];
    } else {
      showSnackBar(
        duration: Duration(milliseconds: 10000),
        context: context,
        message: "Error",
      );
    }
    notifyListeners();
  }

  //GET USER DETAILS
  void fetch_dealer(context, dealerdetails) async {
    Map<String, String> data = {
      "id": dealerdetails.toString(),
    };

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://robotek.frantic.in/RestApi/fetch_dealer'));
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Accept": "multipart/form-data",
    });
    request.fields['id'] = dealerdetails.toString();

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responseData = json.decode(responsed.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> output = json.decode(responsed.body);
      user = output["data"];
    } else {
      showSnackBar(
        duration: Duration(milliseconds: 1000),
        context: context,
        message: "Not added",
      );
    }
  }
}
