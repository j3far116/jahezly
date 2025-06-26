import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahezly_5/models/orders_model.dart';
import 'package:jahezly_5/provider/orders.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../global.dart';
import '../models/markets_model.dart';
import '../orders/review_screen.dart';
import 'products_appbar.dart';
import 'products_card.dart';
import 'products_tabs.dart';

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
|
|
|
|
|
|
|
|
|
| Product Screen
|
|--------------------------------------------------------------------------
*/

class ProductsScreen extends StatefulWidget {
  const ProductsScreen(this.marketInfo, {super.key});

  final Markets marketInfo;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with TickerProviderStateMixin {
  // ---------------------------------------------------------
  // Init Var
  // ---------------------------------------------------------
  late TabController tabController = TabController(length: 0, vsync: this);
  List<dynamic> listTabs = [];
  List<dynamic> listProducts = [];
  OrderInSql? orderInfo;
  String? openStatus;

  // ---------------------------------------------------------
  // Init State
  // ---------------------------------------------------------
  @override
  void initState() {
    super.initState();
    // .. Get Products From Api
    _initTabList();
    marketStream();
    //context.read<OrderConfig>().updateProviderData();
  }

  // ---------------------------------------------------------
  // deactivate
  // ---------------------------------------------------------
  @override
  void deactivate() {
    super.deactivate();
    // Clear all pending timer before dispose()
    VisibilityDetectorController.instance.notifyNow();
  }

  // ---------------------------------------------------------
  // Run Class
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderConfig>(
      builder: (context, provider, child) {
        // .. Get Index Of Order From List Orders In Provider
        int indexOrder = provider.order.indexWhere(
          (e) => e.marketId == widget.marketInfo.id,
        );

        // .. If Order Exsisting Get Order Info
        if (indexOrder != -1) {
          orderInfo = provider.order[indexOrder];
        }

        // ---------------------------------------------------------
        // Start Class
        // ---------------------------------------------------------
        return Scaffold(
          bottomNavigationBar: ((indexOrder < 0))
              ? null
              : bottomBar(orderInfo!),
          //
          body: Stack(
            children: [
              // ---------------------------------------------------------
              // Set background Image For Market
              // ---------------------------------------------------------
              SizedBox(
                height: 200,
                child: CachedNetworkImage(
                  //height: ((210 - shrinkOffset) < 100) ? 100 : 210 - shrinkOffset,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl:
                      'https://jahezly.net/admincp/upload/${widget.marketInfo.cover ?? 'noImage.jpg'}',
                ),
              ),

              CustomScrollView(
                slivers: [
                  // ---------------------------------------------------------
                  // View AppBar
                  // ---------------------------------------------------------
                  ProdectsAppBar(widget.marketInfo),
                  // ---------------------------------------------------------
                  // View NavBar
                  // ---------------------------------------------------------
                  //ProdectsNavBar(),
                  (openStatus == 'closed')
                      ? SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 70),
                            child: Container(
                              color: Colors.amber[100],
                              height: 100,
                              width: double.infinity,
                              child: const Center(
                                child: Text('إستقبال الطلبات .. غير متاح'),
                              ),
                            ),
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 70),
                            child: Container(),
                          ),
                        ),

                  // ..
                  /* SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => SqlViewer()),
                          );
                        },
                        child: Text('View Sql'),
                      ),
                    ),
                  ), */
                  // ---------------------------------------------------------
                  // View Tabs
                  // ---------------------------------------------------------
                  (listTabs.length > 1)
                      ? SliverPersistentHeader(
                          delegate: ProductsTabs(
                            controller: tabController,
                            data: listTabs,
                          ),
                          pinned: true,
                        )
                      : SliverToBoxAdapter(child: Container()),
                  // ---------------------------------------------------------
                  // View List Products
                  // ---------------------------------------------------------
                  viewListProducts(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Get List Product & Tabs
  |--------------------------------------------------------------------------
  */
  void _initTabList() {
    fetchProducts('${widget.marketInfo.id}').then((value) {
      for (int i = 0; i < value.length; i++) {
        // .. Add Keys To List Tabs
        listTabs.add({'key': GlobalKey(), 'label': value.keys.elementAt(i)});
        // .. Add Values To List Products
        listProducts.add({
          'tab': listTabs[i]['label'],
          'items': value.values.elementAt(i),
        });
      }
      tabController = TabController(length: listTabs.length, vsync: this);
      // .. Refresh Screen
      setState(() {});
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Featch List Products From Database
  |--------------------------------------------------------------------------
  */
  Future<Map<String, dynamic>> fetchProducts(String marketId) async {
    String linkUrl = J3Config.linkApi('products');
    final response = await http.post(Uri.parse('$linkUrl?marketId=$marketId'));
    return json.decode(response.body);
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. 
  |--------------------------------------------------------------------------
  */
  void marketStream() async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final response = await http.get(
        Uri.parse(
          'https://jahezly.net/app-5/markets.php?id=${widget.marketInfo.id}',
        ),
      );
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      //debugPrint(appConfig.userInfo.name);
      List<Markets> marketInfo = items.map<Markets>((json) {
        return Markets.fromJson(json);
      }).toList();
      if (!mounted) return;
      setState(() {
        openStatus = marketInfo.first.openStatus;
      });
      debugPrint(marketInfo.first.openStatus);
      //readStream.sink.add(readings);
    });
    //});
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Build & View List Products
  |--------------------------------------------------------------------------
  */
  viewListProducts() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: List.generate(listProducts.length, (index) {
              // .. Get Tabd & Products
              var tabs = listTabs[index];
              var products = listProducts[index];
              // ..
              return VisibilityDetector(
                key: tabs['key'],
                onVisibilityChanged: (VisibilityInfo info) {
                  double screenHeight = MediaQuery.of(context).size.height;
                  double visibleAreaOnScreen =
                      info.visibleBounds.bottom - info.visibleBounds.top;
                  //
                  if (info.visibleFraction > 0.9 ||
                      visibleAreaOnScreen > screenHeight) {
                    tabController.animateTo(index);
                  }
                },
                // ---------------------------------------------------------
                // View Product Card
                // ---------------------------------------------------------
                child: ProductCard(
                  marketInfo: widget.marketInfo,
                  catName: tabs['label'],
                  listProduct: products['items'],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Build & View List Products
  |--------------------------------------------------------------------------
  */
  bottomBar(OrderInSql orderInfo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.yellow[600],
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => ReviewScreen(
                    marketInfo: widget.marketInfo,
                    orderInfo: orderInfo,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 25.0,
                  height: 25.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${orderInfo.quantity}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 7),
                  child: Text('عرض السلة'),
                ),
                const Spacer(),
                Text(
                  '${orderInfo.price}',
                  style: const TextStyle(fontSize: 20),
                  textDirection: TextDirection.ltr,
                ),
                const Text('  ريال', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
