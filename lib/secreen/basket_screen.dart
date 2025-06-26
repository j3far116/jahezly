import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahezly_5/provider/orders.dart';
import 'package:jahezly_5/widgets/price.dart';
import 'package:jahezly_5/widgets/sheet_page.dart';
import 'package:provider/provider.dart';

import '../db_helper.dart';
import '../global.dart';
import '../models/markets_model.dart';
import '../models/orders_model.dart';
import '../widgets/colors.dart';
import '../orders/review_screen.dart';

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
| Bascket Class
|
|--------------------------------------------------------------------------
*/

class BasketScreen extends StatefulWidget {
  const BasketScreen({super.key});

  @override
  State<BasketScreen> createState() => _BasketScreenState();
}

class _BasketScreenState extends State<BasketScreen> {
  // ---------------------------------------------------------
  // Init Var
  // ---------------------------------------------------------
  final DBHelper dbHelper = DBHelper();
  // ---------------------------------------------------------
  // Run Class
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // ---------------------------------------------------------
    // Build AppConfig Provider
    // ---------------------------------------------------------
    return PopScope(
      canPop: false,
      child: Consumer<OrderConfig>(
        builder: (context, provider, child) {
          // ---------------------------------------------------------
          // Build Screen
          // ---------------------------------------------------------
          return Scaffold(
            // ---------------------------------------------------------
            // AppBar
            // ---------------------------------------------------------
            appBar: AppBar(
              title: Text(
                'السلة',
                style: TextStyle(
                  color: J3Colors('Orange').color,
                  fontWeight: FontWeight.normal,
                ),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.white,
              elevation: 0.1,
              shadowColor: Colors.blueGrey.withValues(alpha: 0.3),
              centerTitle: true,
            ),

            // ---------------------------------------------------------
            // Body
            // ---------------------------------------------------------
            body: (provider.order.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Expanded(
                          // ---------------------------------------------------------
                          // Build List Orders In Provider
                          // --------------------------------------------------------
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: provider.order.length,
                            itemBuilder: (context, index) {
                              // .. Init Order Info
                              OrderInSql orderInfo = provider.order[index];
                              // .. Convert MarketInfo Data To Map
                              final Map<String, dynamic> marketInfo = json
                                  .decode(orderInfo.marketInfo!);
                              // View Product
                              return BascketCard(
                                provider,
                                marketInfo: marketInfo,
                                orderInfo: orderInfo,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                :
                  // ---------------------------------------------------------
                  // View If Orders Empty
                  // ---------------------------------------------------------
                  const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        'لا توجد طلبات',
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'JahezlyLight',
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
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
| Bascket Card
|
|--------------------------------------------------------------------------
*/

class BascketCard extends StatefulWidget {
  const BascketCard(
    this.provider, {
    super.key,
    required this.marketInfo,
    required this.orderInfo,
  });

  final OrderConfig provider;
  final Map<String, dynamic> marketInfo;
  final OrderInSql orderInfo;

  @override
  State<BascketCard> createState() => _BascketCardState();
}

class _BascketCardState extends State<BascketCard> {
  //
  //
  Markets? mm;
  //
  //
  @override
  void initState() {
    super.initState();
    fetchMarkets(widget.marketInfo['id']);
  }

  //
  //
  // ---------------------------------------------------------
  // Run Class
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // ---------------------------------------------------------
    // Build Card
    // ---------------------------------------------------------
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
          // ---------------------------------------------------------
          // Style Card
          // ---------------------------------------------------------
          child: Container(
            // .. Style Data
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey.withValues(alpha: 0.3),
                  blurRadius: 20, // soften the shadow
                  spreadRadius: -8, //extend the shadow
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            // .. On Click View Order Checkout
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ReviewScreen(
                      marketInfo: mm!,
                      orderInfo: widget.orderInfo,
                    ),
                  ),
                );
              },
              // ---------------------------------------------------------
              // Start Card
              // ---------------------------------------------------------
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // ---------------------------------------------------------
                    // Market Logo
                    // ---------------------------------------------------------
                    (mm == null)
                        ? Text('data')
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                                imageUrl:
                                    'https://jahezly.net/admincp/upload/${widget.marketInfo['logo'] ?? 'noImage.jpg'}',
                              ),
                            ),
                          ),
                    // ..
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          // ---------------------------------------------------------
                          // Market Name
                          // ---------------------------------------------------------
                          Text(
                            '${widget.marketInfo['name']}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'jahezlyBold',
                            ),
                          ),
                          const SizedBox(height: 17),

                          // ---------------------------------------------------------
                          // Quantity Products
                          // ---------------------------------------------------------
                          Row(
                            children: [
                              Container(
                                height: 20,
                                padding: const EdgeInsets.only(
                                  left: 6,
                                  right: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: J3Colors('Orange').color,
                                  //color: Colors.yellow.shade600,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  '${widget.orderInfo.quantity}',
                                  style: const TextStyle(
                                    height: 1.4,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'منتجات',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // ..
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // ---------------------------------------------------------
                          // Remove Order
                          // ---------------------------------------------------------
                          InkWell(
                            // .. View Dialog Confirm Remove
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return J3SheetPage(
                                    height: 180,
                                    child: ConfirmRemoveOrder(
                                      widget.provider,
                                      widget.orderInfo,
                                    ),
                                  );
                                },
                              );
                            },
                            child: Opacity(
                              opacity: 0.8,
                              child: Container(
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  border: Border.all(
                                    color: Colors.redAccent,
                                    width: 0.5,
                                  ),
                                ),
                                child: const SizedBox(
                                  width: 25,
                                  height: 18,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 1),
                                    child: Text(
                                      'x',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 1.2,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // ---------------------------------------------------------
                          // View Price Order
                          // ---------------------------------------------------------
                          Row(
                            children: [
                              J3Price(
                                widget.orderInfo.price!,
                                iconSize: 13,
                                style: TextStyle(fontSize: 22),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Featch List Markets From Database
  |--------------------------------------------------------------------------
  */
  Future<List<Markets>?> fetchMarkets(String id) async {
    String linkUrl = J3Config.linkApi('markets');
    //
    final response = await http.post(Uri.parse('$linkUrl?id=$id'));
    final List body = json.decode(response.body);
    final result = body.map((e) => Markets.fromJson(e)).toList();
    //
    setState(() {
      mm = result.first;
    });
    return null;
  }
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
| Confirm Remove Order
|
|--------------------------------------------------------------------------
*/

class ConfirmRemoveOrder extends StatelessWidget {
  ConfirmRemoveOrder(this.provider, this.orderInfo, {super.key});

  final OrderConfig provider;
  final OrderInSql orderInfo;
  final DBHelper dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ---------------------------------------------------------
        // Title Confirm
        // ---------------------------------------------------------
        const SizedBox(height: 5),
        const Text(
          'هل تريد إزالة الطلب من السلة؟',
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 25),
        // ---------------------------------------------------------
        // Button Confirm
        // ---------------------------------------------------------
        SizedBox(
          width: 250,
          height: 45,
          child: ElevatedButton(
            onPressed: () {
              // .. 1. Remove Products From Sql
              // .. 2. Remove Order From Sql
              // .. 3. Colse Confirm
              dbHelper
                  .removeOrder(
                    '${orderInfo.id}',
                    orderInfo.productsKey!.split(','),
                  )
                  .then((_) {
                    provider.updateProviderData().then((_) {
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    });
                  });
            },
            // ---------------------------------------------------------
            // Style Button
            // ---------------------------------------------------------
            style: ElevatedButton.styleFrom(
              backgroundColor: J3Colors('Orange').color,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text(
              'تأكيد',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
