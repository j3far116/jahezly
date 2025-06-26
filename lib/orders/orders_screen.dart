import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahezly_5/orders/checkout_screen.dart';
import 'package:jahezly_5/secreen/track_screen.dart';
import 'package:provider/provider.dart';
import '../models/orders_model.dart';
import '../provider/app_config.dart';
import '../widgets/colors.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final StreamController<List<Orders>> readStream =
      StreamController<List<Orders>>();

  @override
  void initState() {
    super.initState();
    orsersStream();
  }

  @override
  void dispose() {
    super.dispose();
    //readStream.close();
  }

  @override
  Widget build(BuildContext context) {
    //
    /* Future.delayed(Duration.zero, () {
      setState(() {});
    }); */
    /* AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    if (appConfig.settingInfo('user_info')!.isNotEmpty) {
      setState(() {});
    }
    debugPrint(appConfig.userInfo.name); */
    //
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'الطلبات',
            style: TextStyle(
              color: J3Colors('Orange').color,
              fontFamily: 'Jahezly',
            ),
          ),
          iconTheme: IconThemeData(color: J3Colors('Orange').color),
          backgroundColor: Colors.white,
          elevation: 0.3,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Text('عرض الطلبات السابقة'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: StreamBuilder<List<Orders>>(
                  stream: readStream.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => {
                              /* Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  OrderDetailScreen(
                                                    orderInfo: snapshot.data![index],
                                                  ))) */
                            },
                            child: ProductCard4(snapshot.data![index]),
                          );
                          /* return Card(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              OrderDetailScreen(
                                                orderInfo: snapshot.data![index],
                                              )));
                                },
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('${snapshot.data![index].marketName}'),
                                    Text(
                                        '${OrderStatus('${snapshot.data![index].status}')}'),
                                    const Text('المنتجات (6)')
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('id: ${snapshot.data![index].id}'),
                                    Text(
                                        'الإجمالي: ${snapshot.data![index].totalPrice} ر.س'),
                                  ],
                                ),
                              ),
                            ); */
                        },
                      );
                    } else {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 150),
                          Center(
                            child: Text(
                              'لا توجد طلبات جديدة',
                              style: TextStyle(
                                fontFamily: 'JahezlyBold',
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. 
  |--------------------------------------------------------------------------
  */

  /* Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UserId');
  } */

  /*
  |--------------------------------------------------------------------------
  | Function .. 
  |--------------------------------------------------------------------------
  */
  void orsersStream() async {
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    //
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (readStream.isClosed) return timer.cancel();
      final response = await http.get(
        Uri.parse(
          'https://jahezly.net/app-5/orders/orders.php?userId=${appConfig.userInfo.id}',
        ),
      );
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      //debugPrint(appConfig.userInfo.name);
      List<Orders> readings = items.map<Orders>((json) {
        return Orders.fromJson(json);
      }).toList();
      readStream.sink.add(readings);
    });
    //});
  }
}

/*
|--------------------------------------------------------------------------
|
|
|
|
|
|
|
||
|
|
|
|
|
|
||
|
|
|
|
|
|
|
|  Time Line
|
|--------------------------------------------------------------------------
*/

class ProductCard4 extends StatelessWidget {
  ProductCard4(this.orderInfo, {super.key});

  final Orders orderInfo;
  //final OrderInSql orderInfo;

  final fifteenAgo = DateTime.parse('2024-11-09 04:10:13');

  @override
  Widget build(BuildContext context) {
    //
    //var orderTime = DateTime.parse('${orderInfo.date}');
    //
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
          child: Container(
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
            child: InkWell(
              //onTap: () => {},
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      if (orderInfo.paid!) {
                        return TrackScreen(orderInfo);
                      }
                      return CheckOutScreen(orderInfo, toBack: true);
                    },
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          height: 70,
                          width: 70,
                          fit: BoxFit.cover,
                          imageUrl:
                              'https://jahezly.net/admincp/upload/${orderInfo.marketLogo ?? 'noImage.jpg'}',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '${orderInfo.marketName}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'jahezlyBold',
                            ),
                          ),
                          const SizedBox(height: 17),
                          Row(
                            children: [
                              Container(
                                height: 20,
                                padding: const EdgeInsets.only(
                                  left: 6,
                                  right: 6,
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
                                  '${orderInfo.countItems}',
                                  style: const TextStyle(
                                    height: 1.4,
                                    color: Colors.black,
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
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'timeago',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              height: 1.2,
                              color: Colors.blueGrey,
                              fontSize: 10,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                '${orderInfo.totalPrice}',
                                style: const TextStyle(fontSize: 22),
                              ),
                              const Text(
                                ' ريال',
                                style: TextStyle(fontSize: 12),
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
}
