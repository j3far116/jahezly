import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahezly_5/products/products_card.dart';
import 'package:jahezly_5/provider/app_config.dart';
import 'package:provider/provider.dart';
import '../db_helper.dart';
import '../global.dart';
import '../models/markets_model.dart';
import '../models/options_model.dart';
import '../models/products_model.dart';
import '../options/opt_group.dart';
import '../provider/orders.dart';
import '../widgets/colors.dart';
import '../widgets/price.dart';
import '../widgets/sheet_page.dart';
import 'control_product.dart';

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
| Bigen Class
|
|--------------------------------------------------------------------------
*/
//
//
List<OptGroup> listOptGroup = [];

//
//
class ProductDetail extends StatefulWidget {
  const ProductDetail(this.scrollController, this.marketInfo, this.productInfo, {super.key});

  final Markets marketInfo;
  final Products productInfo;
  final ScrollController scrollController;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  //
  final DBHelper dbHelper = DBHelper();

  //
  @override
  void initState() {
    super.initState();
    fetchOptions('${widget.productInfo.id}');
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    OrderConfig provider = Provider.of<OrderConfig>(context, listen: false);
    //
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ListView(
            //controller: widget.scrollController,
            children: [
              CachedNetworkImage(
                //height: ((210 - shrinkOffset) < 100) ? 100 : 210 - shrinkOffset,
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl: 'https://jahezly.net/admincp/upload/${widget.productInfo.cover ?? 'noImage.jpg'}',
              ),
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(top: 10, right: 10),
                child: Row(
                  children: [
                    Text(
                      '${widget.productInfo.name}',
                      style: TextStyle(fontSize: 30, color: J3Colors('Orange').color),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: J3Price(widget.productInfo.price!, iconSize: 18, style: TextStyle(fontSize: 25)),
                    ),
                  ],
                ),
              ),
              OptGroups(
                provider: provider,
                productInfo: widget.productInfo,
                // provider: provider,
              ),
              SizedBox(height: 100),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Row(
              children: [
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: Colors.white),
                  child: ControlProductDetailInBottom(widget.productInfo, () {
                    if (appConfig.isGuest && !appConfig.isLogin) {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) => J3SheetPage(height: 300, child: Text('يجب عليك تسجيل الدخول')),
                      );
                    } else {
                      checkOtpRequired(provider).then((val) {
                        if (val) {
                          addOrder(provider, widget.marketInfo, widget.productInfo).then((_) {
                            Timer(const Duration(milliseconds: 200), () {
                              provider.updateProviderData();
                              Navigator.pop(context);
                            });
                          });
                        }
                      });
                    }

                    //
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //
  //
  //
  /*
  |--------------------------------------------------------------------------
  | ****
  |--------------------------------------------------------------------------
  */
  Future<void> fetchOptions(String productId) async {
    String linkUrl = J3Config.linkApi('options');
    final response = await http.get(Uri.parse('$linkUrl?productId=$productId'));
    if (json.decode(response.body) != null) {
      final data = json.decode(response.body) as List<dynamic>;
      setState(() {
        listOptGroup = data.map((json) => OptGroup.fromJson(json)).toList();
      });
    }
  }
  /*
  |--------------------------------------------------------------------------
  | Function .. 
  |--------------------------------------------------------------------------
  */
  /* void addOrder(OrderConfig provider) {
    checkOtpRequired(provider);
  } */

  /*
  |--------------------------------------------------------------------------
  | Function .. 
  |--------------------------------------------------------------------------
  */
  Future<bool> checkOtpRequired(OrderConfig provider) async {
    provider.optIgnored.clear();
    //
    for (var i = 0; i < provider.optRequired.length; i++) {
      if (provider.optSelected.containsKey(provider.optRequired[i])) {
        //
        if (provider.optSelected[provider.optRequired[i]]!.isEmpty) {
          provider.checkOptIgnored(provider.optRequired[i]);
        } else {
          provider.removeOptIgnored(provider.optRequired[i]);
        }
      } else {
        //
        provider.checkOptIgnored(provider.optRequired[i]);
      }
    }
    //
    setState(() {});
    //
    if (provider.optIgnored.isNotEmpty) {
      //debugPrint('Options Required');
      return false;
    } else {
      //debugPrint('Options Done!');
      return true;
    }
  }
}
