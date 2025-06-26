import 'package:flutter/cupertino.dart';
import '../db_helper.dart';
import '../models/perms_model.dart';
import '../models/users_model.dart';
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
| Provider Settings "AppConfig"
|
|--------------------------------------------------------------------------
*/

class AppConfig with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  // ---------------------------------------------------------
  // Init Var
  // ---------------------------------------------------------
  List<Perms> settings = [];
  List<String> keys = [];
  //
  String typeId = '0';
  bool isLogin = false;
  bool isGuest = false; // هل المتصفح زائر؟
  //
  UserInfo userInfo = UserInfo();

  /*
  |--------------------------------------------------------------------------
  | Function .. Get List Settings & List Keys
  |--------------------------------------------------------------------------
  */
  Future<void> getAppConfig() async {
    dbHelper.getListSettings().then((val) {
      settings.clear();
      keys.clear();
      for (var i = 0; i < val.length; i++) {
        settings.add(val[i]);
        keys.add(val[i].key!);
        // .. Refresh Data
        notifyListeners();
      }
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Get  Settings Info By Key
  |--------------------------------------------------------------------------
  */
  String? settingInfo(String key) {
    String? result;
    var cc = settings.where((e) => e.key == key);
    for (var e in cc) {
      //debugPrint(e.id);
      result = e.value;
    }
    return result;
  }

  // ---------------------------------------------------------
  // Set User Is Login
  // ---------------------------------------------------------
  setIsLogin(bool setLogin) {
    isLogin = setLogin;
    // .. Refresh Data
    notifyListeners();
  }

  // ---------------------------------------------------------
  // Set User Is Guest
  // ---------------------------------------------------------
  setIsGuest(bool setIsGuest) {
    isGuest = setIsGuest;
    // .. Refresh Data
    notifyListeners();
  }

  // ---------------------------------------------------------
  // Set User Info
  // ---------------------------------------------------------
  setUserInfo(UserInfo data) {
    userInfo = data;
    // .. Refresh Data
    notifyListeners();
  }

  // ---------------------------------------------------------
  // Set Type Id
  // ---------------------------------------------------------
  setTypeId(String marketType) {
    typeId = marketType;
    // .. Refresh Data
    notifyListeners();
  }
}
