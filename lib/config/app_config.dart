class AppConfig {
  static const String devurl = "https://dummyjson.com";
  // static const String productionurl = "https://dummyjson.com/products";
  static const String baseurl = devurl;

  // sqflite utils

  static const String tableName = "Cart";
  static const String primaryKey = "id";
  static const String itemTitle = "title";
  static const String itemPrice = "price";
  static const String itemQty = "qty";
  static const String productId = "productId";
  static const String productImage = "productImage";
}
