import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shopping_cart_may/model/home_screen_model/allproduct_res_model.dart';
import 'package:shopping_cart_may/model/home_screen_model/categories_res_model.dart';
import 'package:shopping_cart_may/repository/api/home_screen_services.dart';

class HomeScreenController with ChangeNotifier {
  bool isLoadingcategories = false;
  bool isLoadingproducts = false;
  List<CategoriesResModel> categoryList = [];
  List<Product> Allproductlist = [];
  int currentindex = 0;
  Future<void> fetchCategories() async {
    isLoadingcategories = true;
    notifyListeners();
    try {
      final res = await HomeScreenServices().fetchcategories();
      if (res != null) {
        categoryList = res ?? [];
        categoryList.insert(
            0, CategoriesResModel(slug: "all", name: "All", url: null));
        isLoadingcategories = false;
        notifyListeners();
      }
    } catch (e) {}
    isLoadingcategories = false;
    notifyListeners();
  }

  Future<void> fetchAllpro() async {
    isLoadingproducts = true;
    notifyListeners();
    try {
      String categorySlug = categoryList[currentindex]
          .slug
          .toString(); // for taking the slug , slug used for change the category according to current index
      final allres =
          await HomeScreenServices().fetchAllProducts(category: categorySlug);
      if (allres != null) {
        Allproductlist = allres.products ?? [];
        isLoadingcategories = false;
        notifyListeners();
        // log(Allproductlist.toString());
      } else {
        log("error while fetching allproductResponse ");
      }
    } catch (e) {
      print(e.toString());
    }
    isLoadingproducts = false;
    notifyListeners();
  }

  changeIndex(int index) {
    currentindex = index;
    log(index.toString());
    fetchAllpro(); // for fetching product with spesific category
    notifyListeners();
  }
}
