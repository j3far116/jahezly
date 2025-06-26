import 'dart:convert';

import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jahezly_5/db_helper.dart';
import 'package:jahezly_5/login/login_screen.dart';
import 'package:jahezly_5/provider/orders.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global.dart';
import 'home.dart';
import 'models/perms_model.dart';
import 'models/users_model.dart';
import 'provider/app_config.dart';
import 'package:http/http.dart' as http;

import 'secreen/locations_screen.dart';

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
| Main App
|
|--------------------------------------------------------------------------
*/

main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  //
  runApp(
    // ------------------------------------
    // Set Language
    // ------------------------------------
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      // ------------------------------------
      // Providers
      // ------------------------------------
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppConfig()),
          ChangeNotifierProvider(create: (_) => OrderConfig()),
        ],
        // ------------------------------------
        // Bigen App
        // ------------------------------------
        child: const MainApp(),
      ),
    ),
  );
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
| Start Main App && Splash Screen
|
|--------------------------------------------------------------------------
*/

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // ------------------------------------
  // Init Var
  // ------------------------------------
  DBHelper dbHelper = DBHelper();
  //
  @override
  void initState() {
    super.initState();
    // ------------------------------------
    // Init Perms To AppConfig Sql
    // ------------------------------------
    initPermsToSQL();
  }

  @override
  Widget build(BuildContext context) {
    // ------------------------------------
    // Init Data Base && Language
    // ------------------------------------
    dbHelper.init();
    context.setLocale(const Locale('ar', 'SA'));
    //
    // ------------------------------------
    // Run Class
    // ------------------------------------
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      theme: ThemeData(
        fontFamily: 'JahezlyBold',
        //useMaterial3: false,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.white,
        cardTheme: CardThemeData(color: Colors.white),
      ),
      // ------------------------------------
      // Splash Screen
      // ------------------------------------
      home: FlutterSplashScreen.scale(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFF7A537),
            Color(0xFFE53939),
            Color.fromARGB(255, 108, 1, 47),
          ],
        ),
        // ------------------------------------
        // Widget Splash
        // ------------------------------------
        childWidget: SizedBox(
          height: 80,
          child: Image.asset("assets/images/logo.png"),
        ),
        animationDuration: const Duration(milliseconds: 700),
        // ------------------------------------
        // Show Screen After Splash
        // ------------------------------------
        nextScreen: const MyApp(),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Get Perms From Api && Insert To AppConfig Sql
  |--------------------------------------------------------------------------
  */
  Future<void> initPermsToSQL() async {
    fetchPerms().then((perms) {
      for (var i = 0; i < perms.length; i++) {
        var perm = perms[i];
        //
        dbHelper.getListSettings().then((result) {
          if (result.isEmpty) {
            dbHelper.addSettingInSql(perm);
          } else {
            dbHelper.editSettingInSql(perm);
          }
        });
      }
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Featch List Perms From Api
  |--------------------------------------------------------------------------
  */
  Future<List<Perms>> fetchPerms() async {
    String linkUrl = J3Config.linkApi('app_config');
    final response = await http.post(Uri.parse(linkUrl));
    final List body = json.decode(response.body);
    return body.map((e) => Perms.fromJson(e)).toList();
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
|
|
|
|
|
|
|
|
|
| MyApp Class
| ... After Screen Splash
|
|--------------------------------------------------------------------------
*/

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ---------------------------------------------------------
  // Init Var
  // ---------------------------------------------------------
  Widget screen = LoadingScreen();
  DBHelper dbHelper = DBHelper();
  bool isLogin = false;
  bool isGuest = false;
  //
  //
  @override
  void initState() {
    super.initState();
    // ---------------------------------------------------------
    // Set Settings To Provider And Reloade Page
    // ---------------------------------------------------------
    context.read<OrderConfig>().updateProviderData();
    context.read<AppConfig>().getAppConfig().then((_) {
      setState(() {});
    });
  }

  // ---------------------------------------------------------
  // Run Class
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    //
    //
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    //
    // ---------------------------------------------------------
    // Check If User Is Login
    // ---------------------------------------------------------
    var userIsLogin = appConfig.keys.contains('user_info');
    var userInfo = appConfig.settingInfo('user_info');
    //
    if (userIsLogin && userInfo!.isNotEmpty) {
      isLogin = true;
      Future.delayed(Duration.zero, () async {
        appConfig.setUserInfo(UserInfo.fromJson(jsonDecode(userInfo)));
        appConfig.setIsLogin(true);
        //
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('UserId', '${appConfig.userInfo.id}');
        //
      });
    } else {
      isLogin = false;
    }

    debugPrint('_____isLogin: ${appConfig.isLogin}');

    // ---------------------------------------------------------
    // Check If App Can view_app_to_guest
    // ---------------------------------------------------------
    var viewAppToGuestExisting = appConfig.keys.contains('view_app_to_guest');
    var viewAppToGuestInfo = appConfig.settingInfo('view_app_to_guest');
    //
    if ((viewAppToGuestExisting && viewAppToGuestInfo == 'active')) {
      isGuest = true;
      Future.delayed(Duration.zero, () async {
        appConfig.setIsGuest(true);
      });
    } else {
      isGuest = false;
    }

    debugPrint('_____isGuest: ${appConfig.isGuest}');

    // ---------------------------------------------------------
    // Check If Location Is Sett
    // ---------------------------------------------------------
    var locationExisting = appConfig.keys.contains('loacation_Info');
    var locationInfo = appConfig.settingInfo('loacation_Info');
    bool isSetLocation = (locationExisting && locationInfo!.isNotEmpty)
        ? true
        : false;

    // ---------------------------------------------------------
    // Remove User Info From Sql .. If User Not Login && App Not view_app_to_guest
    // ---------------------------------------------------------
    if (isGuest && !isLogin) {
      // .. Remove From Sql
      dbHelper.removeSettingInSql('user_info');
      // .. Empty In Provider
      appConfig.userInfo = UserInfo();
    }

    // ---------------------------------------------------------
    // Build App Screen
    // 1. Check Location Is Set
    // 2. Check User Is Login
    // 3. Check App Can view_app_to_guest
    // ---------------------------------------------------------
    screen = (isSetLocation)
        ? (isLogin)
              ? HomeScreen(0)
              : LoginScreen()
        : LocationsScreen();
    //
    // ---------------------------------------------------------
    // Build App Screen
    // 1. Check Location Is Set
    // 2. Check User Is Login
    // 3. Check App Can view_app_to_guest
    // ---------------------------------------------------------
    /* screen =
        (isSetLocation)
            ? (isLogin)
                ? HomeScreen()
                : (isViewAppToGuest)
                ? HomeScreen()
                : LoginScreen()
            : LocationsScreen(); */
    //
    return screen;
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
|
|
|
|
|
|
|
|
|
|  Loading Screen 
|
|--------------------------------------------------------------------------
*/
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}

/* 
## Convert List To JSON Sting/
    ....
    Locations ff = Locations(id: '1', name: 'alqyz2');
    var json2 = jsonEncode(ff);
    debugPrint(json2); 

//
//
## Convert JSON Sting To List Model/
    ....
    Locations pp = Locations.fromJson(jsonDecode(json2));
    debugPrint(pp.name.toString());

//
//
## Add New Setting And Refresh Provider
    addNewSetting(appConfig, Perms(key: 'll', value: json2));
    context.read<AppConfig>().getAppConfig();

//
//
## To Split String
    String str = "date: '2019:04:01'";
    List<String> parts = str.split(':');
    //var prefix = parts[0].trim(); // prefix: "date"
    var date = parts.sublist(0).join(':').trim();
  
*/
