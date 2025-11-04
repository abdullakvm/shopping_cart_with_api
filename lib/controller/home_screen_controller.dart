import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shopping_cart_may/model/home_screen_model/allproduct_res_model.dart';
import 'package:shopping_cart_may/model/home_screen_model/categories_res_model.dart';
import 'package:shopping_cart_may/repository/api/home_screen_services.dart';

class HomeScreenController with ChangeNotifier {
  bool isLoadingcategories = false;
  List<CategoriesResModel> categoryList = [];
  List<Product> Allproductlist = [];
  Future<void> fetchCategories() async {
    isLoadingcategories = true;
    notifyListeners();
    try {
      final res = await HomeScreenServices().fetchcategories();
      if (res != null) {
        categoryList = res ?? [];
        isLoadingcategories = false;
        notifyListeners();
      }
    } catch (e) {}
    isLoadingcategories = false;
    notifyListeners();
  }

  Future<void> fetchAllpro() async {
    isLoadingcategories = true;
    notifyListeners();
    try {
      final allres = await HomeScreenServices().fetchAllProducts();
      if (allres != null) {
        Allproductlist = allres.products ?? [];
        isLoadingcategories = false;
        notifyListeners();
        log(Allproductlist.toString());
      } else {
        log("error while fetching allproductResponse ");
      }
    } catch (e) {
      print(e.toString());
    }
    isLoadingcategories = false;
    notifyListeners();
  }
}
