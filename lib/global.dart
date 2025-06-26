import 'package:flutter/material.dart';

/*
|--------------------------------------------------------------------------
| ..
|--------------------------------------------------------------------------
*/
class J3Widget {
  J3Widget(String s);

  /*
  |--------------------------------------------------------------------------
  | .. Build Widget
  |--------------------------------------------------------------------------
  */
  static Widget widget(String lable) {
    //
    late Widget result;
    //
    switch (lable) {
      // ------------------------------------
      // Progress Btn Icon
      // ------------------------------------
      case 'progress_btn_icon':
        result = SizedBox(
          width: 25,
          height: 25,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
        );
        break;
      // ------------------------------------
      // Bigen Code
      // ------------------------------------

      default:
    }
    return result;
  }
}

/*
|--------------------------------------------------------------------------
| ..
|--------------------------------------------------------------------------
*/
class J3Config {
  /*
  |--------------------------------------------------------------------------
  | .. 
  |--------------------------------------------------------------------------
  */

  static String linkApi(String lable) {
    late String link = 'https://www.jahezly.net';
    late String folder = 'app-5';
    switch (lable) {
      // ------------------------------------
      // Return Links Api In Jahezly
      // ------------------------------------
      case 'check_user':
        link = '$link/$folder/login/check-user.php';
        break;
      //
      case 'check_email':
        link = '$link/$folder/login/check-email.php';
        break;
      //
      case 'register':
        link = '$link/$folder/login/register.php';
        break;
      //
      case 'remove_account':
        link = '$link/$folder/login/remove-account.php';
        break;
      //
      case 'sms_otp':
        link = '$link/$folder/login/sms-otp.php';
        break;
      //
      case 'markets':
        link = '$link/$folder/markets.php';
        break;
      //
      case 'products':
        link = '$link/$folder/products.php';
        break;
      //
      case 'product_info':
        link = '$link/$folder/products.php';
        break;
      //
      case 'options':
        link = '$link/$folder/options.php';
        break;
      //
      //
      case 'new_order':
        link = '$link/$folder/orders/new-order.php';
        break;
      //
      //
      case 'locations':
        link = '$link/$folder/locations.php';
        break;
      //
      case 'app_config':
        link = '$link/$folder/app-config.php';
        break;
      //
      case 'terms_page':
        link = '$link/terms.html';
        break;
      //
      case 'privacy_page':
        link = '$link/privacy.html';
        break;
      //
      case 'return_page':
        link = '$link/return.html';
        break;

      default:
    }
    return link;
  }
}
