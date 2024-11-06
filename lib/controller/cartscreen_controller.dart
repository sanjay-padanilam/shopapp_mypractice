import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shoping_ui_sample/model/productmodel.dart';

import 'package:sqflite/sqflite.dart';

class CartScreenController with ChangeNotifier {
  static late Database database;
  List<Map<String, dynamic>> storedProducts = [];

  Future initDb() async {
    database = await openDatabase("cartdb.db", version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Cart (id INTEGER PRIMARY KEY, name TEXT, qty INTEGER, description TEXT, image TEXT,productId INTEGER)');
    });
  }

  Future getAllProducts() async {
    storedProducts = await database.rawQuery('SELECT * FROM Cart');
    log(storedProducts.toString());
    notifyListeners();
  }

  Future addProduct(Productmodel selectedProduct) async {
    // for (int i = 0; i < storedProducts.length; i++) {
    //   if (selectedProduct.id == storedProducts[i]["productId"]) {
    //     alreadyInCart = true;
    //   }
    // }

    bool alreadyInCart = storedProducts.any(
      (element) => selectedProduct.id == element["productId"],
    );

    if (alreadyInCart) {
      log("already in cart");
    } else {
      await database.rawInsert(
          'INSERT INTO Cart(name, qty, description,image,productId) VALUES(?, ?, ?,?,?)',
          [
            selectedProduct.title,
            1,
            selectedProduct.description,
            selectedProduct.image,
            selectedProduct.id
          ]);
    }
  }

  incrementQty() {}
  decrementQty() {}
  Future removeProduct(int productId) async {
    await database.rawDelete('DELETE FROM Cart WHERE id = ?', [productId]);
    getAllProducts();
  }
}