import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jahezly_5/home.dart';
import 'package:provider/provider.dart';

import '../db_helper.dart';
import '../main.dart';
import '../models/perms_model.dart';
import '../models/users_model.dart';
import '../provider/app_config.dart';

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
| Login Control
|
|--------------------------------------------------------------------------
*/

class J3LoginControl {
  J3LoginControl(this.context, this.appConfig);

  final BuildContext context;
  final AppConfig appConfig;
  //
  final DBHelper dbHelper = DBHelper();

  /*
  |--------------------------------------------------------------------------
  | Function .. Login
  |--------------------------------------------------------------------------
  */
  login(Map<String, dynamic> userData) {
    // .. Convert User Data To JSON String
    var userInfoJSON = jsonEncode(userData);
    // .. Add user_info To Sql
    dbHelper.addSettingInSql(Perms(key: 'user_info', value: userInfoJSON)).then(
      (_) {
        //
        if (!context.mounted) return;
        AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);

        // .. Set AppConfig In Provider "true"
        Future.delayed(Duration.zero, () async {
          appConfig.setIsLogin(true);

          // .. Set UserInfo In Provider
          UserInfo userInfo = UserInfo.fromJson(jsonDecode(userInfoJSON));
          appConfig.setUserInfo(userInfo);

          // .. Goto MyApp Screen
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen(0)),
          );
        });
      },
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Logout
  |--------------------------------------------------------------------------
  */
  void logOut() {
    // .. set Provider is Login => false
    appConfig.setIsLogin(false);
    //
    dbHelper.emptyTable('options');
    dbHelper.emptyTable('orders');
    dbHelper.emptyTable('products');
    // .. Remove user_info From Sql
    dbHelper.removeSettingInSql('user_info').then((_) {
      if (!context.mounted) return;
      // .. Empty UserInfo In Provider
      appConfig.userInfo = UserInfo();
      // .. Update App Config Settings
      context.read<AppConfig>().getAppConfig().then((_) {
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => MyApp()),
        );
      });
    });
  }
}
