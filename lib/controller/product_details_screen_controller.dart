

import 'package:flutter/material.dart';
import 'package:shopping_cart_may/model/home_screen_model/allproduct_res_model.dart';
import 'package:shopping_cart_may/repository/api/product_details_screen_services.dart';

class ProductDetailsScreenController with ChangeNotifier {
  bool isloading = false;
  Product? response;
  Future<void> fetchproductdetails({required String proid}) async {
    isloading = true;
    notifyListeners();
    try {
      final prodres =
          await ProductDetailsScreenServices().fetchProductDetails(id: proid);
      if (prodres != null) {
        response = prodres;
        isloading = false;
        notifyListeners();
      } else {
        isloading = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    isloading = false;
    notifyListeners();
  }
}
