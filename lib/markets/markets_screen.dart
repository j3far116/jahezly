import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahezly_5/db_helper.dart';
import 'package:jahezly_5/secreen/locations_screen.dart';
import 'package:jahezly_5/login/login_screen.dart';
import 'package:provider/provider.dart';

import '../global.dart';
import '../models/markets_model.dart';
import '../products/products_screen.dart';
import '../provider/app_config.dart';
import '../widgets/colors.dart';
import 'markets_card.dart';
import 'markets_tabs.dart';

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
| Markets Screen
|
|--------------------------------------------------------------------------
*/
class MarketsScreen extends StatefulWidget {
  const MarketsScreen({super.key});

  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  DBHelper dbHelper = DBHelper();
  List<Markets> listMarkets = [];
  Widget userNotLogn = Container();
  //

  //
  @override
  void initState() {
    super.initState();
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    _initListMarkets('1', appConfig.typeId);
    //
    userNotLogin(appConfig);
  }

  void _initListMarkets(String location, String type) {
    fetchMarkets(location, type).then((value) {
      for (int i = 0; i < value.length; i++) {
        listMarkets.add(value[i]);
      }
      setState(() => {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //
    //
    //
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    debugPrint(appConfig.userInfo.name);
    //
    //
    return PopScope(
      canPop: false,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            pinned: true,
            // .. To Sett Bottom Shadow
            forceElevated: false,
            floating: false,
            shadowColor: Colors.grey.shade100,
            scrolledUnderElevation: 0.5,
            elevation: 0,
            //
            // .. To change Height AppBar
            bottom: PreferredSize(
              // Add this code
              preferredSize: Size.fromHeight(45), // Add this code
              child: marketsTypesIcons(appConfig.typeId), // Add this code
            ),
            expandedHeight: 60,
            //
            title: Text(
              'جهـزلي Jahezly',
              style: TextStyle(
                color: J3Colors('Orange').color,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [LocationInAppBar()],
          ),

          //
          //
          SliverToBoxAdapter(child: userNotLogn),
          (listMarkets.isNotEmpty)
              ? SliverList(
                  // .. Begginer Build
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // .. Init Market Info Var
                      Markets marketInfo = Markets.fromMap(
                        listMarkets[index].toMap(),
                      );
                      // .. Build Market Card
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProductsScreen(listMarkets[index]),
                            ),
                          );
                        },
                        child: MarketCard(marketInfo),
                      );
                    },
                    // .. Count Of Markets Type
                    childCount: listMarkets.length,
                  ),
                )
              : SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> userNotLogin(AppConfig appConfig) async {
    Future.delayed(Duration(seconds: 1), () async {
      setState(() {
        userNotLogn = (!appConfig.isLogin && appConfig.isGuest)
            ? Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.amber.shade100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('يجب عليك', style: TextStyle(fontSize: 20)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'تسجل الدخول',
                        style: TextStyle(
                          fontSize: 20,
                          color: J3Colors('Orange').color,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container();
      });
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Featch List Markets From Database
  |--------------------------------------------------------------------------
  */
  Future<List<Markets>> fetchMarkets(String location, String type) async {
    String linkUrl = J3Config.linkApi('markets');
    //
    final response = await http.post(
      Uri.parse('$linkUrl?location=$location&type=$type'),
    );
    final List body = json.decode(response.body);
    return body.map((e) => Markets.fromJson(e)).toList();
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Get Setting "market_type_info"
  |--------------------------------------------------------------------------
  */
  MarketsType? typeInfo(AppConfig appConfig) {
    if (appConfig.keys.contains('market_type_info')) {
      var settingData = appConfig.settingInfo('market_type_info');
      MarketsType typeInfo = MarketsType.fromJson(jsonDecode(settingData!));
      return typeInfo;
    }
    return null;
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Markets Types Icons
  |--------------------------------------------------------------------------
  */
  final List<MarketsType> _types = [
    MarketsType(id: '0', name: 'الكل'),
    MarketsType(id: '1', name: 'المطاعم', img: 'assets/images/001.jpg'),
    MarketsType(id: '2', name: 'كافيهات', img: 'assets/images/002.jpg'),
  ];

  /*
  |--------------------------------------------------------------------------
  | Widget .. Build Market Types Icons
  |--------------------------------------------------------------------------
  */
  Widget marketsTypesIcons(String typeActivetd) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: SizedBox(
        height: 45,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          // .. Count Types
          itemCount: _types.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      AppConfig appConfig = Provider.of<AppConfig>(
                        context,
                        listen: false,
                      );
                      if (!(appConfig.typeId == _types[index].id)) {
                        // .. View Progress Icon
                        appConfig.setTypeId('${_types[index].id}');
                        listMarkets.clear();
                        _initListMarkets('1', '${_types[index].id}');
                        context.read<AppConfig>().getAppConfig();
                        // .. Refreash List Markets
                        setState(() {});
                      }
                    },
                    // .. Button Style
                    child: TabsMarketsType(
                      typeInfo: _types[index],
                      typeActivetd: typeActivetd,
                      //activeMarket: '${settings!['marketTypeId']}',
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
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
|  Action In AppBar
|
|--------------------------------------------------------------------------
*/
class LocationInAppBar extends StatelessWidget {
  const LocationInAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 18, 13, 13),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          //color: J3Colors('Grey').color,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: InkWell(
          onTap: () {
            // .. Goto Set Location Screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => LocationsScreen(),
              ),
            );
          },
          //splashColor: Colors.transparent,
          //highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Row(
              children: [
                Icon(Icons.place, size: 20, color: J3Colors('Orange').color),
                Text(
                  //'مطاعم ??',
                  'مطاعم القوز',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 3.5),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
