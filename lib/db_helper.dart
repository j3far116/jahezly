import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/options_model.dart';
import 'models/orders_model.dart';
import 'models/perms_model.dart';
import 'models/products_model.dart';

class DBHelper {
  static Database? _database;
  List<String> keys = [];
  /*
  |--------------------------------------------------------------------------
  | Init Database
  | Chack Database If Found Or Not
  |--------------------------------------------------------------------------
  */
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await init();
    return _database;
  }

  /*
  |--------------------------------------------------------------------------
  | .. Create Database
  |--------------------------------------------------------------------------
  */
  init() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'jahezly.db');
    var db = await openDatabase(path, version: 1, onCreate: onCreate);
    return db;
  }

  /*
  |--------------------------------------------------------------------------
  | .. Create Table
  |--------------------------------------------------------------------------
  */
  Future<void> onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE 'app_config'(
                            `id` INTEGER PRIMARY KEY AUTOINCREMENT,
                            `key` VARCHAR(50),
                            `value` VARCHAR(256)
                          )''');
    await db.execute('''CREATE TABLE 'orders'(
                            `id` INTEGER PRIMARY KEY AUTOINCREMENT,
                            `marketId` VARCHAR(20),
                            `marketInfo` VARCHAR(255),
                            `productsKey` VARCHAR(200),
                            `price` FLOAT
                          )''');
    await db.execute('''CREATE TABLE 'products'(
                            `id` INTEGER PRIMARY KEY AUTOINCREMENT,
                            `marketId` VARCHAR(20),
                            `key` VARCHAR(20),
                            `optIds` VARCHAR(200),
                            `optTotal` FLOAT,
                            `name` VARCHAR(200),
                            `price` FLOAT,
                            `quantity` INTEGER,
                            `total` FLOAT
                          )''');
    await db.execute('''CREATE TABLE 'options'(
                            `id` INTEGER PRIMARY KEY AUTOINCREMENT,
                            `productId` VARCHAR(20),
                            `name` VARCHAR(200),
                            `price` FLOAT
                          )''');
  }

  Future<int?> addOpt(OptInSql opt) async {
    final dbClient = await database;
    final cc = await dbClient?.insert('options', opt.toMap());
    return cc;
  }

  Future<int> removeOpt(optId) async {
    final dbClient = await database;
    final result = await dbClient!.delete('options', where: '`id` = $optId');
    return result;
  }

  Future<List<OptInSql>> getOptions(productId) async {
    final dbClient = await database;
    final List<Map<String, Object?>>? queryResult = await dbClient?.rawQuery(
      'SELECT * FROM `options` WHERE `productId` = $productId',
    );
    return queryResult!.map((result) => OptInSql.fromMap(result)).toList();
  }

  Future<List<OptInSql>> getAllOptions() async {
    final dbClient = await database;
    //String where = (productId == null) ? '' : 'WHERE `productId` = $productId';
    final List<Map<String, Object?>>? queryResult = await dbClient?.rawQuery(
      'SELECT * FROM `options`',
    );
    return queryResult!.map((result) => OptInSql.fromMap(result)).toList();
  }

  Future<int> updateProductOpt(String optIds, String? productId) async {
    return await _database!.rawUpdate(
      'UPDATE `products` SET `optIds` = ? WHERE `id` = ?',
      [optIds, productId],
    );
  }

  Future<int> updateTotalOptInProduct(
    String optTotal,
    String? productId,
  ) async {
    return await _database!.rawUpdate(
      'UPDATE `products` SET `optTotal` = ? WHERE `id` = ?',
      [optTotal, productId],
    );
  }

  /*
  |--------------------------------------------------------------------------
  | ***********************************************************************
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  | Orders Table
  |
  |--------------------------------------------------------------------------
  */

  Future<int?> addOrder(OrderInSql order) async {
    final dbClient = await database;
    final cc = await dbClient?.insert('orders', order.toMap());
    return cc;
  }

  Future<List<OrderInSql>> getOrders({int? marketId}) async {
    final dbClient = await database;
    String where = (marketId == null) ? '' : 'WHERE `marketId` = $marketId';
    final List<Map<String, Object?>>? queryResult = await dbClient?.rawQuery(
      'SELECT * FROM `orders` $where',
    );
    return queryResult!.map((result) => OrderInSql.fromMap(result)).toList();
  }

  Future<int> updateOrderPrice(String? marketId) async {
    var product = await getProducts(marketId: marketId);
    double price = 0.0;
    for (var i = 0; i < product.length; i++) {
      price += product[i].total!;
    }
    return await _database!.rawUpdate(
      ' UPDATE `orders` SET `price` = ? WHERE `marketId` = ?',
      [price, marketId],
    );
  }

  Future<void> removeOrder(orderId, List productIds) async {
    removeProduct(productIds).then((_) async {
      final dbClient = await database;
      await dbClient!.delete('orders', where: '`id` = $orderId');
    });
  }

  /*
  |--------------------------------------------------------------------------
  | ***********************************************************************
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  | Products Tale
  |
  |--------------------------------------------------------------------------
  */

  Future<int?> addProduct(ProductInSql products) async {
    final dbClient = await database;
    final cc = await dbClient?.insert('products', products.toMap());
    return cc;
  }

  Future<List<ProductInSql>> getProducts({String? marketId}) async {
    final dbClient = await database;
    String where = (marketId == null) ? '' : 'WHERE `marketId` = $marketId';
    final List<Map<String, Object?>>? queryResult = await dbClient?.rawQuery(
      'SELECT * FROM `products` $where',
    );
    return queryResult!.map((result) => ProductInSql.fromMap(result)).toList();
  }

  Future<void> removeProduct(List products) async {
    if (products.isNotEmpty) {
      for (var i = 0; i < products.length; i++) {
        final dbClient = await database;
        await dbClient!.delete('products', where: '`id` = ${products[i]}');
      }
    }
  }

  Future<int> updateTotalPriceProduct(double total, String? productId) async {
    return await _database!.rawUpdate(
      ' UPDATE `products` SET `total` = ? WHERE `id` = ?',
      [total, productId],
    );
  }

  Future<int> updateProductQuantity(int quantity, String? productId) async {
    return await _database!.rawUpdate(
      ' UPDATE `products` SET `quantity` = ? WHERE `id` = ?',
      [quantity, productId],
    );
  }

  Future<int> updateProductsKey(String? productsKey, String? marketId) async {
    return await _database!.rawUpdate(
      ' UPDATE `orders` SET `productsKey` = ? WHERE `marketId` = ?',
      [productsKey, marketId],
    );
  }

  /*
  |--------------------------------------------------------------------------
  | ***********************************************************************
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  |
  | AppConfig Tale
  |
  |--------------------------------------------------------------------------
  */

  Future<List<Perms>> getListSettings() async {
    final dbClient = await database;
    final List<Map<String, Object?>>? queryResult = await dbClient?.rawQuery(
      'SELECT * FROM `app_config`',
    );
    return queryResult!.map((result) => Perms.fromMap(result)).toList();
  }

  //
  //
  Future<int?> addSettingInSql(Perms perm) async {
    //
    final dbClient = await database;
    final cc = await dbClient?.insert('app_config', perm.toMap());
    return cc;
  }

  Future<int?> removeSettingInSql(String key) async {
    final dbClient = await database;
    final result = await dbClient!.delete(
      'app_config',
      where: "`key` = '$key'",
    );
    return result;
  }

  //
  //
  void editSettingInSql(Perms perm) async {
    final dbClient = await database;
    await dbClient!.rawQuery(
      "UPDATE `app_config` SET `value` = ? WHERE `key` = ?",
      [perm.value, perm.key],
    );
  }

  //
  //
  Future<void> checkSetting() async {
    getListSettings().then((result) {
      keys.clear();
      for (var i = 0; i < result.length; i++) {
        keys.add(result[i].key!);
      }
    });
  }

  //
  //
  Future<void> newSetting(Perms perm2) async {
    if (keys.isNotEmpty) {
      if (!keys.contains(perm2.key)) {
        addSettingInSql(perm2);
      }
    }
  }

  //
  //
  Future<int> emptyTable(String table) async {
    final dbClient = await database;
    final result = await dbClient!.delete(table);
    return result;
  }
}
