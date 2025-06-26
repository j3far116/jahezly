import 'package:flutter/cupertino.dart';
import '../db_helper.dart';
import '../models/options_model.dart';
import '../models/orders_model.dart';
import '../models/products_model.dart';

class OrderConfig with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  //
  double initTotalOpt = 0.0;
  double get totalOpt => initTotalOpt;
  //
  int initQuantity = 1;
  int get quantity => initQuantity;
  //
  double initTotalProduct = 0.0;
  double get totalProduct => initTotalProduct;
  //
  List<OrderInSql> order = [];
  List<ProductInSql> product = [];
  List<OptInSql> opt = [];
  //
  // .. To Show Error Msg
  List<String> optIgnored = []; // الاضافات التي لم يتم اخيارها وهي مطلوبه
  List<String> optRequired = [];
  Map<String, List<String>> optSelected = {};

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  void setOptSelected(String? optGroup, List<String> optList) {
    optSelected['$optGroup'] = optList;
    notifyListeners();
    //return optSelected;
  }

  void setTotalOpt(double productPrice, double optPrice) {
    initTotalOpt += optPrice;
    initTotalOpt = double.parse(initTotalOpt.toStringAsFixed(2));
    //
    setTotalProduct(productPrice);
    notifyListeners();
  }

  void removeTotalOpt(double productPrice, double optPrice) {
    initTotalOpt -= optPrice;
    initTotalOpt = double.parse(initTotalOpt.toStringAsFixed(2));
    //
    setTotalProduct(productPrice);
    notifyListeners();
  }

  void setOptRequired(String groupId) {
    if (!optRequired.contains(groupId)) {
      optRequired.add(groupId);
      notifyListeners();
    }
  }

  void checkOptIgnored(String groupId) {
    optIgnored.add(groupId);
    //debugPrint(optIgnored.toString());
    notifyListeners();
  }

  void removeOptIgnored(String groupId) {
    optIgnored.remove(groupId);
    //debugPrint(optIgnored.toString());
    notifyListeners();
  }
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void reset() {
    optIgnored = [];
    optRequired = [];
    optSelected = {};
    initQuantity = 1;
    initTotalOpt = 0.0;
    initTotalProduct = 0.0;
    notifyListeners();
  }

  /*
  |--------------------------------------------------------------------------
  | Get Orders & Products Data In List
  |--------------------------------------------------------------------------
  */
  Future<void> updateProviderData() async {
    order = await dbHelper.getOrders();
    product = await dbHelper.getProducts();
    opt = await dbHelper.getAllOptions();
    notifyListeners();
  }

  int productQuantity(int index, int quantity) {
    //final index = product.indexWhere((e) => e.key == productKey);
    final quantity0 = product[index].quantity! + quantity;
    notifyListeners();
    return quantity0;
  }

  Future<List> getMarketsIdInOrder() async {
    order = await dbHelper.getOrders();
    List ordersId = [];
    for (var i = 0; i < order.length; i++) {
      ordersId.add(order[i].marketId);
    }
    return ordersId;
  }

  Future<List> getProductsKeys(String? marketId) async {
    product = await dbHelper.getProducts(marketId: marketId);
    List productIndex = [];
    for (var i = 0; i < product.length; i++) {
      productIndex.add(product[i].key);
    }
    return productIndex;
  }

  void setTotalProduct(double price) {
    dynamic total = (price + initTotalOpt) * quantity;
    initTotalProduct = total;
    notifyListeners();
  }

  void addQuantity() {
    initQuantity++;
    notifyListeners();
  }

  void removeQuantity() {
    initQuantity--;
    notifyListeners();
  }
}
