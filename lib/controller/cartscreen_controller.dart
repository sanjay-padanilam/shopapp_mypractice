import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shoping_ui_sample/model/productmodel.dart';

import 'package:sqflite/sqflite.dart';

class CartScreenController with ChangeNotifier {
  num totalcartvalue = 0.00;
  static late Database database;
  List<Map<String, dynamic>> storedProducts = [];

  Future initDb() async {
    database = await openDatabase("cartdb.db", version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE Cart (id INTEGER PRIMARY KEY, name TEXT, qty INTEGER, description TEXT, image TEXT,productId INTEGER,amount REAL)');
    });
  }

  Future getAllProducts() async {
    storedProducts = await database.rawQuery('SELECT * FROM Cart');
    log(storedProducts.toString());
    calculateTotalAmnt();
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
          'INSERT INTO Cart(name, qty, description,image,productId,amount) VALUES(?, ?, ?,?,?,?)',
          [
            selectedProduct.title,
            1,
            selectedProduct.description,
            selectedProduct.image,
            selectedProduct.id,
            selectedProduct.price
          ]);
    }
  }

  incrementQty({required int currentqty, required int id}) {
    database
        .rawUpdate('UPDATE Cart SET qty = ? WHERE id = ?', [++currentqty, id]);
    getAllProducts();
  }

  decrementQty({required int currentqty, required int id}) {
    if (currentqty > 1) {
      database.rawUpdate(
          'UPDATE Cart SET qty = ? WHERE id = ?', [--currentqty, id]);
      getAllProducts();
    }
  }

  Future removeProduct(int productId) async {
    await database.rawDelete('DELETE FROM Cart WHERE id = ?', [productId]);
    getAllProducts();
  }

  void calculateTotalAmnt() {
    totalcartvalue = 0.00;

    for (int i = 0; i < storedProducts.length; i++) {
      totalcartvalue = totalcartvalue +
          storedProducts[i]["qty"] * storedProducts[i]["amount"];
    }
    log(totalcartvalue.toString());
  }
}
