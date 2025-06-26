import 'dart:convert';

import 'package:jahezly_5/functions.dart';
import 'package:jahezly_5/models/markets_model.dart';

import '../models/options_model.dart';
import '../models/orders_model.dart';
import '../models/products_model.dart';
import '../provider/orders.dart';
import 'product_detail.dart';

Future<void> addOrder(OrderConfig provider, Markets marketInfo, Products productInfo) async {
  // .. init data
  String marketId = marketInfo.id!;
  ProductInSql product = ProductInSql(
    marketId: marketInfo.id,
    key: productInfo.id,
    name: productInfo.name,
    price: productInfo.price,
    quantity: provider.quantity,
    total: provider.totalProduct,
  );
  Map<String, dynamic> marketData = {
    'id': marketInfo.id,
    'name': marketInfo.name,
    'cover': marketInfo.cover,
    'logo': marketInfo.logo,
  };
  Map<String, List<String>> options = provider.optSelected;

  String productKey = productInfo.id!;
  //
  //
  provider.getMarketsIdInOrder().then((value) {
    bool isMarketInList = value.contains(marketId);
    // ------------------------------------
    // Check If Order Inserted
    // ------------------------------------
    if (isMarketInList) {
      provider.getProductsKeys(marketId).then((keys) {
        //
        List<String> listOpt = [];
        options.forEach((key, value) {
          for (var e in value) {
            listOpt.add(e);
          }
        });
        //
        bool isProductInList = keys.contains(productKey);
        // ------------------------------------
        // Check If Product Inserted
        // ------------------------------------
        //
        if (isProductInList) {
          // ------------------------------------
          // Update Product Quantity
          // ------------------------------------

          if (options.isNotEmpty) {
            // .. Get Index Product
            var index = provider.product.indexWhere((e) {
              return optEquals(listOpt, e.optIds?.split(',') ?? []);
            });

            //debugPrint(index.toString());

            // .. If Product Opt Is Empty
            if (index == -1) {
              // ------------------------------------
              // If Options Not Equale Any optIds In Product Sql Win New Options
              // Then .. Add New Product
              // And .. Update List Prodects Key Id In Orders Table & TotalPrice
              // ------------------------------------
              addProduct(provider, marketId, product, options);
              //
            } else {
              // .. Update Quantity & TotalPrice
              updateProduct(provider, index, product);
            }
            //
            //
          } else {
            // .. Get Index Product
            var index2 = provider.product.indexWhere((e) => e.key == productKey);
            // .. Update Quantity & TotalPrice
            updateProduct(provider, index2, product);
          }
          //
          //
        } else {
          // ------------------------------------
          // Add New Product .. If Product Not Inserted
          // Then .. Update List Prodects Key Id In Orders Table & TotalPrice
          // ------------------------------------
          addProduct(provider, marketId, product, options);
        }
      });
    } else {
      // ------------------------------------
      // Add New Order .. If Order Not Inserted
      // ------------------------------------
      dbHelper
          .addOrder(
            OrderInSql(marketId: marketId, marketInfo: json.encode(marketData), productsKey: null, price: 0),
          )
          .then((value) {
            // ------------------------------------
            // Add New Product
            // Then .. Update List Prodects Key In Orders Table & TotalPrice
            // ------------------------------------
            addProduct(provider, marketId, product, options);
          });
    }
  });
}

/*
  |--------------------------------------------------------------------------
  | Function .. 
  |--------------------------------------------------------------------------
  */
void addProduct(
  OrderConfig provider,
  String? marketId,
  ProductInSql product,
  Map<String, List<String>> options,
) {
  // ------------------------------------
  // Add New Product
  // ------------------------------------
  dbHelper.addProduct(product).then((val) {
    // val = Product Id In Provider
    var listOpt = addOptInSql(options, '$val');
    dbHelper.updateProductOpt(listOpt.join(','), '$val');
    dbHelper.updateTotalOptInProduct('${provider.totalOpt}', '$val');
    // ------------------------------------
    // Update List Prodects Key In Orders Table & TotalPrice
    // ------------------------------------
    dbHelper.getProducts(marketId: marketId).then((value) {
      final listProductsId = value.map((e) => e.id.toString()).toList();
      dbHelper.updateProductsKey(listProductsId.join(','), marketId);
    });
    dbHelper.updateOrderPrice(marketId);
  });
}

/*
  |--------------------------------------------------------------------------
  | Function .. 
  |--------------------------------------------------------------------------
  */
bool optEquals(List<dynamic> listOptSelectd, List<dynamic> listOptInSql) {
  List<bool> resultEquals = [];
  if (listOptSelectd.length == listOptInSql.length) {
    for (var i = 0; i < listOptSelectd.length; i++) {
      var result = listOptInSql.contains(listOptSelectd[i]);
      resultEquals.add(result);
    }
    if (resultEquals.contains(false)) {
      return false;
    } else {
      return true;
    }
  } else {
    return false;
  }
}

/*
  |--------------------------------------------------------------------------
  | Function .. 
  |--------------------------------------------------------------------------
  */
void updateProduct(OrderConfig provider, int index, ProductInSql product) {
  final quantity = provider.productQuantity(index, product.quantity!);
  final totalPrice = quantity * product.price!;
  //
  var productId = provider.product[index].id.toString();
  dbHelper.updateProductQuantity(quantity, productId);
  dbHelper.updateTotalPriceProduct(totalPrice, productId);
  dbHelper.updateOrderPrice(product.marketId);
}

/*
  |--------------------------------------------------------------------------
  | Function .. 
  |--------------------------------------------------------------------------
  */
List<String> addOptInSql(Map<String, List<String>> options, String productId) {
  //
  List<String> listOpt = [];
  //
  if (options.isNotEmpty) {
    options.forEach((key, val) {
      //optGroupInfo(key);
      for (var v = 0; v < val.length; v++) {
        Map<String, dynamic> info = optInfo(key, val[v]);
        //debugPrint(info.toString());
        listOpt.add(val[v]);
        dbHelper.addOpt(
          OptInSql(productId: productId, name: info['name'], price: double.parse(info['price'])),
        );
      }
    });
  }
  return listOpt;
}

/*
  |--------------------------------------------------------------------------
  | Function .. 
  |--------------------------------------------------------------------------
  */
Map<String, dynamic> optInfo(String groupId, String optId) {
  Map<String, dynamic> info = {};
  for (var i = 0; i < listOptGroup.length; i++) {
    if (listOptGroup[i].id == groupId) {
      List listOpt = listOptGroup[i].opt.toList();
      for (var v = 0; v < listOpt.length; v++) {
        if (listOpt[v]['id'] == optId) {
          info = listOpt[v];
        }
      }
    }
  }
  return info;
}
