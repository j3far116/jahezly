import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahezly_5/home.dart';
import 'package:jahezly_5/models/orders_model.dart';
import 'package:jahezly_5/orders/pay_screen.dart';
import 'package:jahezly_5/secreen/track_screen.dart';

import '../widgets/colors.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen(this.orderInfo, {super.key, required this.toBack});

  final Orders orderInfo;
  final bool toBack;

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  String? orderStatus;
  late Timer timer;
  late Timer timer2;
  late Orders orderInfo2;

  @override
  void initState() {
    super.initState();
    orderStream();
    aaStream();
    setState(() {
      orderInfo2 = widget.orderInfo;
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
    timer2.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.toBack,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen(2)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'التحقق من الدفع',
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
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(orderInfo2.status ?? ''),
              Text(orderInfo2.payType ?? ''),
              Text(orderInfo2.paid.toString()),
              Text(widget.orderInfo.id.toString()),
              SizedBox(height: 100),
              (orderInfo2.status == 'Request' || orderInfo2.status == 'Review')
                  ? aa()
                  : Container(),
              if (orderInfo2.status == 'WaitPay') bb(),
              if (orderInfo2.status == 'Received') ee(),
              (orderInfo2.status == 'Rejected') ? cc() : Container(),
              (orderInfo2.status == 'Canceled') ? kk() : Container(),
              SizedBox(height: 100),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomeScreen(2),
                    ),
                  );
                },
                child: Text('الطلبات'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget aa() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('تم إرسال الطلب للبائع'),
        Text('في إنتظار رد الباع وتأكيد الطلب'),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => PayScreen()),
            );
          },
          child: Text('إلغاء الطلب'),
        ),
      ],
    );
  }

  Widget bb() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('البائع استلم طلبك'),
        Text('...'),
        Text('باقي عليك تأكيد عملية الدفع'),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => orderPaid(),
              child: Text('إكمال الدفع'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => PayScreen(),
                  ),
                );
              },
              child: Text('إلغاء الطلب'),
            ),
          ],
        ),
      ],
    );
  }

  Widget ee() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('تم تأكيد الطلب من البائع'),
        Text('...'),
        Text('سيكون جاهز من ١٥ - ٤٥دقيقة'),
        SizedBox(height: 50),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () => orderPaid(),
              child: Text('إكمال الطلب'),
            ),
            ElevatedButton(
              onPressed: () => orderCanceled(),
              child: Text('إلغاء الطلب'),
            ),
          ],
        ),
      ],
    );
  }

  Widget cc() {
    return Column(
      children: [
        Text('تم رفض الطلب للأسباب التالية'),
        Text('...'),
        Text('???'),
      ],
    );
  }

  Widget kk() {
    return Column(children: [Text('تم إلغاء الطلب'), Text('...'), Text('???')]);
  }

  void tt() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => TrackScreen(orderInfo2),
      ),
    ).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen(2)),
      );
    });
    //timer.cancel();
  }

  Future<bool?> orderPaid() async {
    String url = "https://jahezly.net/app-5/orders/order-paid.php";
    var response = await http.post(
      Uri.parse(url),
      body: {
        'status': 'Received',
        'paid': '1',
        'paidInfo': 'onReceipt',
        'orderId': '${widget.orderInfo.id}',
      },
    );
    if (response.statusCode == 200) {
      final bool result = json.decode(response.body);
      debugPrint(result.toString());
      return result;
    }
    return null;
  }

  Future<bool?> orderCanceled() async {
    String url = "https://jahezly.net/app-5/orders/order-canceled.php";
    var response = await http.post(
      Uri.parse(url),
      body: {'status': 'Canceled', 'orderId': '${widget.orderInfo.id}'},
    );
    if (response.statusCode == 200) {
      final bool result = json.decode(response.body);
      debugPrint(result.toString());
      return result;
    }
    return null;
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. 
  |--------------------------------------------------------------------------
  */
  void orderStream() async {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      //
      //
      final response = await http.get(
        Uri.parse(
          'https://jahezly.net/app-5/orders/order-info.php?orderId=${widget.orderInfo.id}',
        ),
      );
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      //debugPrint(appConfig.userInfo.name);
      List<Orders> orderInfo = items.map<Orders>((json) {
        return Orders.fromJson(json);
      }).toList();
      if (mounted) {
        setState(() {
          if (orderInfo.isNotEmpty) {
            orderInfo2 = orderInfo.first;
            orderStatus = orderInfo.first.status;
          }
        });
      }
    });
  }

  aaStream() {
    timer2 = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (orderInfo2.paid!) {
        Future.delayed(Duration.zero, () async {
          timer2.cancel();
          tt();
        });
      }
    });
  }
}
