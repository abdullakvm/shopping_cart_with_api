import 'package:flutter/material.dart';
import 'package:shopping_cart_may/model/home_screen_model/categories_res_model.dart';
import 'package:shopping_cart_may/repository/api/home_screen_services.dart';

class HomeScreenController with ChangeNotifier {
  bool isLoadingcategories = false;
  List<CategoriesResModel> categoryList = [];
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
}
