import 'dart:developer';

import 'package:shopping_cart_may/model/home_screen_model/allproduct_res_model.dart';
import 'package:shopping_cart_may/model/home_screen_model/categories_res_model.dart';
import 'package:shopping_cart_may/repository/Apihelper/api_helper.dart';

class HomeScreenServices {
  Future<List<CategoriesResModel>?> fetchcategories() async {
    final resbody = await ApiHelper.getDAta(endpoint: "/products/categories");
    if (resbody != null) {
      final convertedres = categoriesResModelFromJson(resbody);
      return convertedres;
    } else {
      log("res body is null");
    }
    return null;
  }

  Future<AllproductsResModel?> fetchAllProducts() async {
    final allresbody = await ApiHelper.getDAta(endpoint: "/products");
    if (allresbody != null) {
      final convertedAllres = allproductsResModelFromJson(allresbody);
      return convertedAllres;
    } else {
      log("res body is null");
    }
    return null;
  }
}
