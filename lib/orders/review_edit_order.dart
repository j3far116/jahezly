import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jahezly_5/provider/orders.dart';
import '../db_helper.dart';
import '../models/products_model.dart';
import '../widgets/colors.dart';
import '../widgets/sheet_page.dart';

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
| Edit Order In Checkout
|
|--------------------------------------------------------------------------
*/

class EditOrderInReview extends StatefulWidget {
  const EditOrderInReview({
    super.key,
    required this.provider,
    required this.product,
    required this.orderQuantity,
  });

  final OrderConfig provider;
  final ProductInSql product;
  final int orderQuantity;

  @override
  State<EditOrderInReview> createState() => _EditOrderInReviewState();
}

class _EditOrderInReviewState extends State<EditOrderInReview> {
  // ---------------------------------------------------------
  // Init Var
  // ---------------------------------------------------------
  final DBHelper dbHelper = DBHelper();
  int quantity0 = 0;
  double total0 = 0;
  //double totalOpt = 0;

  // ---------------------------------------------------------
  // Init State
  // ---------------------------------------------------------
  @override
  void initState() {
    super.initState();
    quantity0 = widget.product.quantity!;
    total0 = widget.product.total!;
    //totalOpt = widget.product.totalPrice!;
    //dbHelper.getTotalOpt(widget.product.optIds!);
  }

  // ---------------------------------------------------------
  // Run Class
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // ---------------------------------------------------------
    // Start Class
    // ---------------------------------------------------------
    return SizedBox(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // ---------------------------------------------------------
          // View Product Info
          // ---------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Column(
              children: [
                //Text('productID: ${widget.product.id}'),
                Row(
                  children: [
                    Text(
                      '${widget.product.name}',
                      style: const TextStyle(fontSize: 22),
                    ),
                    const Spacer(),
                    const Text('الإجمالي'),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${widget.product.price} sr    x$quantity0',
                      textDirection: TextDirection.ltr,
                    ),
                    const Spacer(),
                    Text(
                      '$total0 sr',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textDirection: TextDirection.ltr,
                    ),
                  ],
                ),
                const Divider(thickness: 0.3),
              ],
            ),
          ),

          // ---------------------------------------------------------
          // Edit Quantity
          // ---------------------------------------------------------
          Container(
            width: 150,
            //height: 50,
            decoration: const BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              //shape: BoxShape.circle,
            ),
            //color: Colors.yellow[600],
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    /* if (widget.provider.quantity > 1) {
                      widget.provider.removeQuantity();
                      widget.provider.setTotalProduct(widget.product.price!);
                    } */
                    setState(() {
                      quantity0 += 1;
                      total0 =
                          (widget.product.price! + widget.product.optTotal!) *
                          quantity0;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('+', style: TextStyle(fontSize: 18)),
                  ),
                ),
                Text('$quantity0', style: const TextStyle(fontSize: 18)),
                InkWell(
                  onTap: () {
                    /* widget.provider.addQuantity();
                    widget.provider.setTotalProduct(widget.product.price!); */
                    setState(() {
                      if (quantity0 > 1) {
                        quantity0 -= 1;
                        total0 =
                            (widget.product.price! + widget.product.optTotal!) *
                            quantity0;
                      }
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('-', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // ---------------------------------------------------------
              // Update Quantity Button
              // ---------------------------------------------------------
              ElevatedButton(
                onPressed: () {
                  dbHelper.updateProductQuantity(
                    quantity0,
                    '${widget.product.id}',
                  );
                  dbHelper.updateTotalPriceProduct(
                    total0,
                    '${widget.product.id}',
                  );
                  dbHelper.updateOrderPrice(widget.product.marketId).then((_) {
                    Timer(
                      const Duration(milliseconds: 100),
                      () => Navigator.pop(context),
                    );
                  });
                },
                child: const Text('تحديث'),
              ),
              // ---------------------------------------------------------
              // Remove Order Button
              // ---------------------------------------------------------
              (widget.orderQuantity > 1)
                  ? ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return J3SheetPage(
                              height: 200,
                              child: Column(
                                children: [
                                  // ---------------------------------------------------------
                                  // Title Confirm
                                  // ---------------------------------------------------------
                                  const SizedBox(height: 5),
                                  const Text(
                                    'هل تريد إزالة المنتج من السلة؟',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(height: 25),
                                  SizedBox(
                                    width: 250,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        dbHelper.removeProduct([
                                          widget.product.id,
                                        ]);
                                        updateProductId(
                                          widget.product.marketId,
                                        ).then((value) {
                                          dbHelper.updateTotalPriceProduct(
                                            total0,
                                            widget.product.key,
                                          );
                                          dbHelper.updateOrderPrice(
                                            widget.product.marketId,
                                          );
                                        });
                                        Timer(
                                          const Duration(milliseconds: 100),
                                          () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: J3Colors(
                                          'Orange',
                                        ).color,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            100,
                                          ),
                                        ),
                                      ),
                                      child: const Text('تأكيد'),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: J3Colors('Orange').color,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Text('إزالــــه المنتج'),
                    )
                  : Container(),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Update Products IDs After Removed Product
  |--------------------------------------------------------------------------
  */
  Future<void> updateProductId(String? marketId) async {
    dbHelper.getProducts(marketId: marketId).then((value) {
      final listProductsId = value.map((e) => e.id.toString()).toList();
      dbHelper.updateProductsKey(listProductsId.join(','), marketId);
    });
  }
}
