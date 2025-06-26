import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahezly_5/provider/orders.dart';
import 'package:provider/provider.dart';

import '../db_helper.dart';
import '../global.dart';
import '../models/markets_model.dart';
import '../models/orders_model.dart';
import '../models/products_model.dart';
import '../provider/app_config.dart';
import '../widgets/colors.dart';
import 'checkout_screen.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen({
    super.key,
    required this.marketInfo,
    required this.orderInfo,
    required this.listProduct,
  });

  final Markets marketInfo;
  final OrderInSql orderInfo;
  final List<ProductInSql> listProduct;

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  final DBHelper dbHelper = DBHelper();
  String selectedValue = 'onPaid'; //
  Widget nextBtn = Text('إتمام الطلب');

  @override
  Widget build(BuildContext context) {
    // ------------------------------------
    // Build AppConfig Provider
    // ------------------------------------
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    OrderConfig provider = Provider.of<OrderConfig>(context, listen: false);
    //
    //
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تأكيد الطلب',
          style: TextStyle(
            color: J3Colors('Orange').color,
            fontFamily: 'Jahezly',
          ),
        ),
        iconTheme: IconThemeData(color: J3Colors('Orange').color),
        //backgroundColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: true,
      ),
      //
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    /* Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ProductsScreen(widget.marketInfo),
                      ),
                    ); */
                  },
                  child: ProductCard3(marketInfo: widget.marketInfo.toMap()),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.blueGrey.shade100,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        ///////////////////
                        InkWell(
                          onTap: () =>
                              bb(context, widget.listProduct, widget.orderInfo),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 35,
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      //color: J3Colors('Orange').color,
                                      color: Colors.yellow.shade600,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      /* border: Border.all(
                                        color: Colors.redAccent, width: 1.5), */
                                    ),
                                    child: Text(
                                      '${widget.orderInfo.productsKey!.split(',').length}',
                                      style: const TextStyle(
                                        height: 1.6,
                                        color: Colors.black,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'منتجات',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 10,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '${widget.orderInfo.price}',
                                      style: const TextStyle(fontSize: 22),
                                    ),
                                    const Text(
                                      ' ريال',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.blueGrey.shade100,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        RadioListTile(
                          title: const Text('الدفع عند الاستلام'),
                          value: 'onReceipt',
                          groupValue: selectedValue,

                          onChanged: (value) {
                            debugPrint(value.toString());
                            setState(() {
                              selectedValue = value!;
                            });
                          },
                        ),
                        RadioListTile(
                          title: const Text('الدفع ببطاقة مدى'),
                          value: 'onPaid',
                          groupValue: selectedValue,
                          onChanged: (value) {
                            debugPrint(value.toString());
                            setState(() {
                              selectedValue = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.blueGrey.shade100,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Text('طريقة التوصيل / الاستلام من المطعم'),
                  ),
                ),
                /* Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.blueGrey.shade100),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Text('لا توجد ملاحظات'),
                  ),
                ), */
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    bottom: 15,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow[600],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          nextBtn = J3Widget.widget('progress_btn_icon');
                        });
                        newOrder(
                          appConfig.userInfo.id!,
                          widget.orderInfo,
                          widget.listProduct.join(';'),
                          selectedValue,
                        ).then((value) {
                          //debugPrint(value.toString());
                          if (value.isNotEmpty) {
                            // .. 1. Remove Products From Sql
                            // .. 2. Remove Order From Sql
                            // .. 3. Colse Confirm
                            dbHelper
                                .removeOrder(
                                  '${widget.orderInfo.id}',
                                  widget.orderInfo.productsKey!.split(','),
                                )
                                .then((_) {
                                  Future.delayed(
                                    Duration(milliseconds: 200),
                                    () async {
                                      provider.updateProviderData().then((_) {
                                        if (!context.mounted) return;
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                CheckOutScreen(
                                                  value.first,
                                                  toBack: false,
                                                ),
                                          ),
                                        );
                                      });
                                    },
                                  );
                                });
                          }
                        });
                      },
                      child: Container(
                        height: 50,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Center(child: nextBtn),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Orders>> newOrder(
    String userId,
    OrderInSql orderInfo,
    String products,
    String payType,
  ) async {
    String linkUrl = J3Config.linkApi('new_order');
    var response = await http.post(
      Uri.parse(linkUrl),
      body: {
        'userId': userId,
        'marketId': orderInfo.marketId,
        'totalPrice': orderInfo.price.toString(),
        'status': 'Request',
        'products': products,
        'payType': payType,
      },
    );
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    if (response.statusCode == 200) {
      List<Orders> result = items.map<Orders>((json) {
        return Orders.fromJson(json);
      }).toList();
      //final List<Orders> result = json.decode(response.body);
      return result;
    }
    return [];
  }

  /*   Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UserId');
  } */
  void bb(
    BuildContext context,
    List<ProductInSql> listProduct,
    OrderInSql orderInfo,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        //
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: BottomSheet3(listProduct, orderInfo),
        );
      },
    );
  }
}

class ProductCard3 extends StatelessWidget {
  const ProductCard3({super.key, required this.marketInfo});

  final Map<String, dynamic> marketInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Container(
        decoration: const BoxDecoration(
          /* boxShadow: [
            BoxShadow(
              color: Colors.blueGrey.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: -8,
              offset: const Offset(0, 0),
            )
          ], */
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        imageUrl:
                            'https://jahezly.net/admincp/upload/${marketInfo['logo'] ?? 'noImage.jpg'}',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 12, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '${marketInfo['name']}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontFamily: 'jahezlyBold',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  /* const Padding(
                    padding: EdgeInsets.only(top: 7),
                    child: IconButton.outlined(
                      onPressed: null,
                      icon: Icon(Icons.chevron_right_outlined),
                      iconSize: 33,
                    ),
                  ), */
                ],
              ),
              //const Divider()
            ],
          ),
        ),
      ),
    );
  }
}

class BottomSheet3 extends StatelessWidget {
  const BottomSheet3(this.listProduct, this.orderInfo, {super.key});

  final OrderInSql orderInfo;
  final List<ProductInSql> listProduct;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Text('تفاصيل المنتجات', style: TextStyle(fontSize: 22)),
          ),
          const Divider(thickness: 1),
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 3, 20, 2),
            child: Row(
              children: [
                SizedBox(width: 150, child: Text('الصنف')),
                Spacer(),
                Text('العدد'),
                Spacer(),
                Text('السعر'),
                Spacer(),
                Text('الاجمالي'),
                Spacer(),
              ],
            ),
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: listProduct.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 20, 2),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 150,
                              child: Text('${listProduct[index].name}'),
                            ),
                            (listProduct[index].optIds!.isNotEmpty)
                                ? Container()
                                : Expanded(
                                    child: Row(
                                      children: [
                                        const Spacer(),
                                        Text('${listProduct[index].quantity}'),
                                        const Spacer(),
                                        Text('${listProduct[index].price}'),
                                        const Spacer(),
                                        Text('${listProduct[index].price}'),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                        /* (listProduct[index].optIds != null)
                            ? Opt(
                              opt: listProduct[index].optIds!.split(','),
                              productId: listProduct[index].id.toString(),
                            )
                            : Container(), */
                        Row(
                          children: [
                            (listProduct[index].optIds!.isNotEmpty)
                                ? Expanded(
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 150,
                                          child: Text(''),
                                        ),
                                        const Spacer(),
                                        Text('${listProduct[index].quantity}'),
                                        const Spacer(),
                                        Text('${listProduct[index].price}'),
                                        const Spacer(),
                                        Text('${listProduct[index].price}'),
                                        const Spacer(),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              );
            },
          ),
          //const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 40, right: 20),
            child: Row(
              children: [
                const Text('الإجمالي', style: TextStyle(fontSize: 18)),
                const Spacer(),
                Text(
                  '${orderInfo.price} sar',
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
