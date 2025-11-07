import 'package:flutter/foundation.dart';
import 'package:shopping_cart_may/config/app_config.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class SqfliteHelper {
  static late Database database;
  static Future initDb() async {
    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
    }
    // database = await openDatabase("cart.db", version: 1,
    //     onCreate: (Database db, int version) async {
    //   // When creating the db, create the table
    //   await db.execute(
    //       'CREATE TABLE ${AppConfig.tableName} (${AppConfig.primaryKey}  INTEGER PRIMARY KEY, ${AppConfig.itemTitle}  TEXT, ${AppConfig.productId}  INTEGER, ${AppConfig.itemPrice}  REAL, ${AppConfig.itemQty}  INTEGER , ${AppConfig.productImage} TEXT)');
    // });

    // same code here accurate for web
    database = await databaseFactory.openDatabase(
      "cart.db",
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE ${AppConfig.tableName} ('
            '${AppConfig.primaryKey} INTEGER PRIMARY KEY, '
            '${AppConfig.itemTitle} TEXT, '
            '${AppConfig.productId} INTEGER, '
            '${AppConfig.itemPrice} REAL, '
            '${AppConfig.itemQty} INTEGER, '
            '${AppConfig.productImage} TEXT)',
          );
        },
      ),
    );
  }

  Future<List<Map>> getAllData() async {
    // Get the records
    List<Map> products = await database.rawQuery('SELECT * FROM ${AppConfig.tableName}');
    return products;
  }

  Future<void> addNewData(
      {required String? title,
      required double? price,
      required int? productid,
      required String? productimage,
      int qty = 1}) async {
    await database.rawInsert(
        'INSERT INTO ${AppConfig.tableName} (${AppConfig.itemTitle} , ${AppConfig.itemPrice} , ${AppConfig.productId} , ${AppConfig.itemQty} , ${AppConfig.productImage} ) VALUES(?, ?, ?, ?, ?)',
        [title, price, productid, qty, productimage]);
  }

  Future<void> updateData({required int qty, required int id}) async {
    await database.rawUpdate('UPDATE ${AppConfig.tableName} SET ${AppConfig.itemQty}  = ? WHERE ${AppConfig.primaryKey}  = ?', [qty, id]);
  }

  Future<void> deleteData({required int id}) async {
    await database.rawDelete('DELETE FROM ${AppConfig.tableName} WHERE ${AppConfig.primaryKey} = ?', [id]);
  }
}
