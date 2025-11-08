import 'package:flutter/material.dart';
import 'package:shopping_cart_may/config/app_config.dart';
import 'package:shopping_cart_may/model/home_screen_model/allproduct_res_model.dart';
import 'package:shopping_cart_may/repository/sgflite_helper/sqflite_helper.dart';

class CartScreenController with ChangeNotifier {
  List<Map> cartItems = [];
  double totalAmount = 0;
  Future<void> addData(Product product, BuildContext context) async {
    bool alreadyincart = cartItems.any(
      (element) => element[AppConfig.productId] == product.id,
    );
    if (alreadyincart == false) {
      await SqfliteHelper().addNewData(
          title: product.title,
          price: product.price,
          productid: product.id,
          productimage: product.thumbnail);
      getData(); // used here for ui updation uptodate
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Already in Cart"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> getData() async {
    cartItems = await SqfliteHelper().getAllData();
    fetchTotalAmount();
    notifyListeners();
  }

  void updateData({required int quantity, required int id}) {
    SqfliteHelper().updateData(qty: quantity, id: id);
    getData();
  }

  void deleteData({required int id}) {
    SqfliteHelper().deleteData(id: id);
    getData();
  }

  void fetchTotalAmount() {
    totalAmount =
        0; //set 0 at start and then calculate when each time function called
    for (var item in cartItems) {
      // item select every item in List
      double currentPrice = item[AppConfig.itemQty] * item[AppConfig.itemPrice];
      totalAmount = totalAmount + currentPrice;
    }
  }
}
