import 'package:flutter/material.dart';
import '../models/orders_model.dart';
import '../widgets/colors.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen(this.orderInfo, {super.key});
  final Orders orderInfo;

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  @override
  Widget build(BuildContext context) {
    //
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (!didPop) {
          Navigator.pop(context);
          /* Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OrdersScreen()),
          ); */
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'تتبع الطلب',
            style: TextStyle(
              color: J3Colors('Orange').color,
              fontFamily: 'Jahezly',
            ),
          ),
          iconTheme: IconThemeData(color: J3Colors('Orange').color),
          backgroundColor: Colors.white,
          elevation: 0.3,
          centerTitle: true,
          /* leading: BackButton(
            onPressed: () => Navigator.pop(context, 'Hi Jafar'),
          ), */
        ),
        body: Column(
          children: [
            Text('order#: ${widget.orderInfo.id}'),
            Text('Price: ${widget.orderInfo.totalPrice}'),
            Text('Status: ${widget.orderInfo.status!}'),

            Container(
              width: 180,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(border: Border.all(width: 2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'رقم الطلب  ',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.orderInfo.counter}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
}
