import 'package:flutter/material.dart';
import 'package:jahezly_5/secreen/account_screen.dart';
import 'package:provider/provider.dart';
import 'secreen/basket_screen.dart';
import 'markets/markets_screen.dart';
import 'provider/app_config.dart';
import 'orders/orders_screen.dart';
import 'widgets/colors.dart';
import 'widgets/sheet_page.dart';

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
| Home Screen
|
|--------------------------------------------------------------------------
*/
class HomeScreen extends StatefulWidget {
  const HomeScreen(this.index, {super.key});

  final int index;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ------------------------------------
  // Init Var
  // ------------------------------------
  int indexSelected = 0;

  @override
  void initState() {
    super.initState();
    indexSelected = widget.index;
  }

  // ------------------------------------
  // Run Class
  // ------------------------------------
  @override
  Widget build(BuildContext context) {
    //
    // .. Get Info & Convert To Map
    // .. Pages
    final List<Widget> pages = <Widget>[
      MarketsScreen(),
      BasketScreen(),
      OrdersScreen(),
      AccountScreen(),
    ];

    //
    //
    return Scaffold(
      body: IndexedStack(
        // .. Index Selected
        index: indexSelected,
        children: pages,
      ),
      // ------------------------------------
      // Bottom Bar Icons
      // ------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexSelected,
        backgroundColor: Colors.grey.shade100,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: J3Colors('Orange').color,
        unselectedItemColor: Colors.blueGrey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        // ------------------------------------
        // Icons Pages
        // ------------------------------------
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.lunch_dining),
            label: 'المطاعم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'السلة',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_rounded),
            label: 'الطلبات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'حسابي',
          ),
        ],
        //
        onTap: (index) => _onItemTapped(index),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. View PageOn Tap
  |--------------------------------------------------------------------------
  */
  void _onItemTapped(int index) {
    //
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    // .. If User Selected Account Screen
    if (index == 3 && appConfig.isGuest && !appConfig.isLogin) {
      // .. If User Not Login && App Can "view_app_to_guest"
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) =>
            J3SheetPage(height: 300, child: Text('يجب عليك تسجيل الدخول')),
      );
    } else {
      setState(() {
        // .. Reset Index Page
        indexSelected = index;
      });
      // }
    }
  }
}
