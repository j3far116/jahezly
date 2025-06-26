import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jahezly_5/widgets/price.dart';
import 'package:provider/provider.dart';
import '../models/markets_model.dart';
import '../models/options_model.dart';
import 'review_edit_order.dart';
import '../db_helper.dart';
import '../models/orders_model.dart';
import '../models/products_model.dart';
import '../provider/orders.dart';
import '../widgets/colors.dart';
import '../widgets/icons.dart';
import '../widgets/sheet_page.dart';
import '../secreen/basket_screen.dart';
import 'confirm_screen.dart';

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
| Checkout Screen
|
|--------------------------------------------------------------------------
*/

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({
    required this.marketInfo,
    required this.orderInfo,
    super.key,
  });

  final Markets marketInfo;
  final OrderInSql orderInfo;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  //
  final DBHelper dbHelper = DBHelper();
  OrderInSql? orderInfo;
  List<ProductInSql> listProduct = [];
  List<String> jsonProduct = [];

  //
  //
  //
  @override
  Widget build(BuildContext context) {
    // ------------------------------------
    // Build AppConfig Provider
    // ------------------------------------
    //AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    //

    //debugPrint('_____username: ${appConfig.userInfo.name}');
    //
    return Consumer<OrderConfig>(
      builder: (context, provider, child) {
        // .. Get Index Of Order From List Orders In Provider
        int indexOrder = provider.order.indexWhere(
          (e) => e.marketId == widget.marketInfo.id,
        );

        // .. If Order Exsisting Get Order Info
        if (indexOrder != -1) {
          listProduct.clear();
          jsonProduct.clear();
          // .. Set Order Info
          orderInfo = provider.order[indexOrder];
          // .. Get List Products Ids
          final listProductsIds = provider.order[indexOrder].productsKey!.split(
            ',',
          );
          //
          for (var i in listProductsIds) {
            // .. Get Index Of Product From List Products In Provider
            final indexProduct = provider.product.indexWhere(
              (e) => e.id.toString() == i,
            );
            // .. If Product Exsisting Get Procudt Info
            if (indexProduct != -1) {
              // .. Add Product To "ListProduct"
              listProduct.add(provider.product[indexProduct]);
              jsonProduct.add(
                json.encode(provider.product[indexProduct].toMap()),
              );
              //listKeys.add(provider.product[i ndex3].key);
            }
          }
        }

        // ---------------------------------------------------------
        // Run Class
        // ---------------------------------------------------------
        return Scaffold(
          // ---------------------------------------------------------
          // AppBar
          // ---------------------------------------------------------
          appBar: AppBar(
            title: Text(
              'مراجعة الطلب',
              style: TextStyle(
                color: J3Colors('Orange').color,
                fontFamily: 'Jahezly',
              ),
            ),
            iconTheme: IconThemeData(color: J3Colors('Orange').color),
            backgroundColor: Colors.white,
            foregroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0.1,
            shadowColor: Colors.blueGrey.withValues(alpha: 0.1),
            centerTitle: true,
            actions: [
              // ---------------------------------------------------------
              // Remove Order
              // ---------------------------------------------------------
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return J3SheetPage(
                          height: 180,
                          child: ConfirmRemoveOrder(provider, widget.orderInfo),
                        );
                      },
                    ).then((_) {
                      // .. If Order Removed
                      // .. 1. Update Provider Data
                      // .. 2. Check If Order In List
                      // .. 3. If Not Found .. Back Navigator
                      provider.updateProviderData().then((_) {
                        // .. Wiat Some Secounds After Update
                        Future.delayed(Duration(milliseconds: 100), () async {
                          // .. Check If Order In List
                          int checkIndexOrder = provider.order.indexWhere(
                            (e) => e.marketId == widget.marketInfo.id,
                          );
                          if (checkIndexOrder == -1) {
                            // .. Back Navigator
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          }
                        });
                      });
                    });
                  },
                  icon: Icon(
                    Icons.delete_sweep,
                    color: J3Colors('Orange').color,
                  ),
                ),
              ),
            ],
          ),

          // ---------------------------------------------------------
          // Bottom Navigation
          // ---------------------------------------------------------
          bottomNavigationBar: _productDetailBottom(
            orderInfo: orderInfo!,
            onPress: () {
              if (orderInfo!.price! >= widget.marketInfo.minOrder!) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ConfirmScreen(
                      marketInfo: widget.marketInfo,
                      orderInfo: orderInfo!,
                      listProduct: listProduct,
                    ),
                  ),
                );
                /* newOrder(appConfig.userInfo.id!, orderInfo!, jsonProduct.join(';')).then((value) {
                  if (value == true) {
                    // .. 1. Remove Products From Sql
                    // .. 2. Remove Order From Sql
                    // .. 3. Colse Confirm
                    dbHelper.removeOrder('${orderInfo!.id}', orderInfo!.productsKey!.split(',')).then((_) {
                      Future.delayed(Duration(milliseconds: 200), () async {
                        provider.updateProviderData().then((_) {
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        });
                      });
                    });
                  }
                }); */
              } else {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return J3SheetPage(
                      height: 180,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('مجموع الطلبات أقل من '),
                          J3Price(
                            widget.marketInfo.minOrder!,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }

              //
            },
          ),

          // ---------------------------------------------------------
          // Body
          // ---------------------------------------------------------
          body: CustomScrollView(
            slivers: <Widget>[
              // ---------------------------------------------------------
              // View List Products
              // ---------------------------------------------------------
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    // .. Init Product Info
                    ProductInSql product = listProduct[index];

                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),

                      child: InkWell(
                        onTap: () => {
                          // ---------------------------------------------------------
                          // Edit Order
                          // ---------------------------------------------------------
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return J3SheetPage(
                                height: 300,
                                child: EditOrderInReview(
                                  provider: provider,
                                  product: product,
                                  orderQuantity: orderInfo!.quantity,
                                ),
                              );
                            },
                          ).then((_) {
                            provider.updateProviderData();
                          }),
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              // ---------------------------------------------------------
                              // View Product Name  && Price
                              // ---------------------------------------------------------
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${listProduct[index].name}',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Spacer(),
                                  J3Price(
                                    listProduct[index].price!,
                                    iconSize: 12,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            (listProduct[index].optIds != null)
                                ? ListOpt(
                                    opt: listProduct[index].optIds!.split(','),
                                    productId: listProduct[index].id.toString(),
                                  )
                                : Container(),
                            SizedBox(height: 10),
                            // ---------------------------------------------------------
                            // View Quantity && Edit && Total
                            // ---------------------------------------------------------
                            Row(
                              children: [
                                // ---------------------------------------------------------
                                // Quantity
                                // ---------------------------------------------------------
                                Container(
                                  width: 90,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                  ),
                                  //color: Colors.yellow[600],
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text('+'),
                                      Text('${product.quantity}'),
                                      const Text('-'),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                // ---------------------------------------------------------
                                // Edit
                                // ---------------------------------------------------------
                                Icon(
                                  J3Icons.edit,
                                  size: 14,
                                  color: Colors.blueGrey.shade300,
                                ),
                                Text(
                                  ' تعـديل',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blueGrey.shade300,
                                  ),
                                ),
                                Spacer(),
                                // ---------------------------------------------------------
                                // View Total
                                // ---------------------------------------------------------
                                Text('الإجمالي: '),
                                J3Price(
                                  product.total!,
                                  iconSize: 14,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            const Divider(thickness: 0.3),
                          ],
                        ),
                      ),
                    );
                  },
                  // .. Length Of Products
                  childCount: listProduct.length, // Number of list items
                ),
              ),
              // ---------------------------------------------------------
              // Go To List Products Of Markets
              // ---------------------------------------------------------
              /* SliverToBoxAdapter(
                child: Center(child: ElevatedButton(onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ProductsScreen(marketInfo)));
                }, child: Text('إضافة المزيد؟'))),
              ), */
            ],
          ),
        );
      },
    );
  }

  /* Future<bool?> newOrder(String userId, OrderInSql orderInfo, String? products) async {
    debugPrint(products);
    String linkUrl = J3Config.linkApi('new_order');
    var response = await http.post(
      Uri.parse(linkUrl),
      body: {
        'userId': userId,
        'marketId': orderInfo.marketId,
        'totalPrice': orderInfo.price.toString(),
        'status': 'Request',
        'products': products,
      },
    );
    if (response.statusCode == 200) {
      final bool result = json.decode(response.body);
      return result;
    }
    return false;
  } */
}

/*
  |--------------------------------------------------------------------------
  | **
  |--------------------------------------------------------------------------
  */
Widget _productDetailBottom({
  required OrderInSql orderInfo,
  required VoidCallback onPress,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 15, bottom: 15),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.yellow[600],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('الإجمالي'),
                  Text(' '),
                  J3Price(
                    orderInfo.price!,
                    iconSize: 13,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 5, bottom: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.yellow[600],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => onPress(),
                    child: Container(
                      width: 50,
                      height: 45,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Center(child: Text('متابعة')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class ListOpt extends StatelessWidget {
  const ListOpt({super.key, required this.opt, required this.productId});

  final List<dynamic> opt;
  final String productId;

  @override
  Widget build(BuildContext context) {
    OrderConfig provider = Provider.of<OrderConfig>(context);
    final List<OptInSql> cc = provider.opt;
    List<dynamic> bb = [];
    //
    cc.indexWhere((e) {
      if (e.productId == productId) {
        bb.add(e.id);
      }
      return false;
    });
    return ListView.builder(
      shrinkWrap: true,
      itemCount: bb.length,
      itemBuilder: (context, index) {
        var index2 = cc.indexWhere((e) => e.id == bb[index]);
        return Row(
          children: [
            Text(
              '         ..     ${cc[index2].name}',
              style: const TextStyle(fontFamily: 'JahezlyLight'),
            ),
            Text('   ${cc[index2].price}'),
          ],
        );
      },
    );
  }
}
