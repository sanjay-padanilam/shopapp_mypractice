import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoping_ui_sample/model/productmodel.dart';

class ProductDetailsscreenController with ChangeNotifier {
  bool isloading = false;
  Productmodel? product;
  Future<void> getProductdetails(int productid) async {
    isloading = true;
    notifyListeners();
    final url = Uri.parse("https://fakestoreapi.com/products/$productid");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        product = Productmodel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print(e);
    }
    isloading = false;
    notifyListeners();
  }
}
