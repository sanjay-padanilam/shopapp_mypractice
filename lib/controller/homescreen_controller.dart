import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shoping_ui_sample/model/productmodel.dart';

class HomescreenController with ChangeNotifier {
  List<Productmodel> productlist = [];
  List cataorylist = [];
  bool isloading = false;
  bool isproductloading = false;
  List<Map> allcatagortylist = [];
  int selectedindex = 0;
  Future<void> getcatagories() async {
    isloading = true;
    notifyListeners();
    final catagoryUrl =
        Uri.parse("https://fakestoreapi.com/products/categories");
    try {
      var responce = await http.get(catagoryUrl);
      if (responce.statusCode == 200) {
        var convertedjson = jsonDecode(responce.body);
        cataorylist = convertedjson;
        cataorylist.insert(0, "All");
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();
    isloading = false;
  }

  int selectedcatagoryindex = 0;

  Future<void> getallProducts({String? catagoryindex}) async {
    isproductloading = true;
    notifyListeners();
    final GetallproductsUrl = Uri.parse("https://fakestoreapi.com/products");
    final catagorywiseurl =
        Uri.parse("https://fakestoreapi.com/products/category/$catagoryindex");

    try {
      var responce = await http.get(
          catagoryindex == null || catagoryindex == "All"
              ? GetallproductsUrl
              : catagorywiseurl);
      if (responce.statusCode == 200) {
        productlist = productlistresponsemodelFromJson(responce.body);
      }
    } catch (e) {
      print(e);
    }
    isproductloading = false;
    notifyListeners();
  }

  getproductBycatagory() {}
}
