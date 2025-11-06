import 'package:shopping_cart_may/model/home_screen_model/allproduct_res_model.dart';
import 'package:shopping_cart_may/repository/Apihelper/api_helper.dart';

class ProductDetailsScreenServices {
  Future<Product?> fetchProductDetails({ required id}) async {
    final prodetailsres = await ApiHelper.getDAta(endpoint: "/products/$id");

    if (prodetailsres != null) {
      Product resmodel = productFromJson(prodetailsres);
      return resmodel;
    } else {
      return null;
    }
  }
}
