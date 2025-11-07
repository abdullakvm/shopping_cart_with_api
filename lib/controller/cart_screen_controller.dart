import 'package:flutter/foundation.dart';
import 'package:shopping_cart_may/model/home_screen_model/allproduct_res_model.dart';
import 'package:shopping_cart_may/repository/sgflite_helper/sqflite_helper.dart';

class CartScreenController with ChangeNotifier {
  List<Map> cartItems = [];
  Future<void> addData(Product product) async {
    await SqfliteHelper().addNewData(
        title: product.title, price: product.price, productid: product.id ,productimage: product.thumbnail);
    getData(); // used here for ui updation uptodate
  }

  Future<void> getData() async {
    cartItems = await SqfliteHelper().getAllData();
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
}
