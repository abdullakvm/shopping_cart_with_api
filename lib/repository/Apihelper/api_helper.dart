import 'dart:developer';
import 'package:http/http.dart';
import 'package:shopping_cart_may/config/app_config.dart';

class ApiHelper {
static  Future<String?> getDAta({required String endpoint}) async {
    final url = Uri.parse(AppConfig.baseurl + endpoint);
    try {
      final response = await get(url);
      if (response.statusCode == 200) {
        log("response data arrived");
        return response.body;
      } else {
        log("response didnt get");
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
