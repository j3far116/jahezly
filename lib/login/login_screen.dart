import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:jahezly_5/home.dart';
import 'package:jahezly_5/login/opt_maker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../db_helper.dart';
import '../global.dart';
import '../provider/app_config.dart';
import '../widgets/colors.dart';
import '../widgets/sheet_page.dart';
import 'otp_screen.dart';

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
| Login Screen
|
|--------------------------------------------------------------------------
*/

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ------------------------------------
  // Init Var
  // ------------------------------------
  final userMobile = TextEditingController();
  final DBHelper dbHelper = DBHelper();
  bool _validateMobile = false;
  // .. Text Button Laoding...
  Widget loginProgress = const Text('متـابعه', style: TextStyle(fontSize: 18));

  // ------------------------------------
  // dispose
  // ------------------------------------
  @override
  void dispose() {
    userMobile.dispose();
    super.dispose();
  }

  // ------------------------------------
  // Run Class
  // ------------------------------------
  @override
  Widget build(BuildContext context) {
    //
    //
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    //
    //

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                const SizedBox(height: 100),
                Center(
                  child: Column(
                    children: [
                      // ------------------------------------
                      // Show Sql Viewer
                      // ------------------------------------
                      /*  TextButton(
                        onPressed: () {
                          dbHelper.init();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => const SqlViewer()),
                          );
                        },
                        child: const Text('SqlViewer'),
                      ),
                      TextButton(
                        onPressed: () {
                          dbHelper.init();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const RegisterScreen('595419922'),
                            ),
                          );
                        },
                        child: const Text('Register'),
                      ), */
                      //
                      //
                      SizedBox(
                        width: 350,
                        height: 100,
                        child: Column(
                          children: [
                            // ------------------------------------
                            // Title Screen
                            // ------------------------------------
                            Text(
                              'أدخل رقم جوالك',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'JahezlyBold',
                                color: J3Colors('Orange').color,
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // ------------------------------------
                            // Descrption Screen
                            // ------------------------------------
                            const Text(
                              'لتسجيل الدخول أو إنشاء حساب جديد',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'JahezlyBold',
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ------------------------------------
                      // Mobile Text Input
                      // ------------------------------------
                      textInput(
                        Padding(
                          padding: const EdgeInsets.only(left: 48),
                          child: TextField(
                            controller: userMobile,
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            maxLength: 9,
                            cursorColor: Colors.deepOrange,
                            decoration: decoration('5x xxx xxxx'),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontSize: 18),
                            // ------------------------------------
                            // Validate Mobile Entred
                            // ------------------------------------
                            onChanged: (value) => validateMobile(value),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ------------------------------------
                      // Login Button
                      // ------------------------------------
                      SizedBox(
                        width: 250,
                        height: 45,
                        child: ElevatedButton(
                          // .. Validate If Entred Mobile Number
                          onPressed: _validateMobile
                              ? () {
                                  // .. Change Button Text To Laoding...
                                  setState(() {
                                    loginProgress = J3Widget.widget(
                                      'progress_btn_icon',
                                    );
                                  });

                                  // ------------------------------------
                                  // Check If User Registred
                                  // ------------------------------------
                                  fetchUserInfo(userMobile.text).then((value) {
                                    // .. If Not Found Data In Server "Not Registred"
                                    if (value == null) {
                                      _register({'mobile': userMobile.text});
                                    } else {
                                      if (value['status'] == 'active') {
                                        // .. If User Active .. Login
                                        _login(value);
                                      } else if (value['status'] == 'removed') {
                                        // .. If User Removed "Deleted Acount"
                                        if (!context.mounted) return;
                                        userRemoves(context);
                                        setState(() {
                                          loginProgress = const Text(
                                            'متـابعه',
                                            style: TextStyle(fontSize: 18),
                                          );
                                        });
                                        //_register({'mobile': userMobile.text});
                                      } else {
                                        // .. User Is Blocked
                                        if (!context.mounted) return;
                                        userIsBlocked(context, userMobile.text);
                                        setState(() {
                                          loginProgress = const Text(
                                            'متـابعه',
                                            style: TextStyle(fontSize: 18),
                                          );
                                        });
                                      }
                                    }
                                  });
                                }
                              : null,

                          // ------------------------------------
                          // Style Login Button
                          // ------------------------------------
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: J3Colors('Orange').color,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          // ------------------------------------
                          // Title Login Button
                          // ------------------------------------
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 8, 40, 10),
                            child: loginProgress,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ------------------------------------
            // Button ignore
            // ------------------------------------
            _ignore(appConfig),
          ],
        ),
      ),
    );
  }

  userRemoves(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return J3SheetPage(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('لا يمكن التسجيل بحساب محذوف مسبقاً'),
              GifView.asset(
                'assets/images/error.gif',
                height: 100,
                width: 100,
                frameRate: 30,
                loop: false,
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'يرجى الإطلاع ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextSpan(
                      text: 'إتفاقية الاستخدام',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            launchUrlString(J3Config.linkApi('terms_page')),
                    ),
                    const TextSpan(
                      text: ' و ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextSpan(
                      text: 'سياسة الخصوصية',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            launchUrlString(J3Config.linkApi('privacy_page')),
                    ),
                    const TextSpan(
                      text: '.',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'JahezlyBold',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _ignore(AppConfig appConfig) {
    // ..  Check If App Can view_app_to_guest
    var viewAppToGuestExisting = appConfig.keys.contains('view_app_to_guest');
    var viewAppToGuestInfo = appConfig.settingInfo('view_app_to_guest');
    bool isViewAppToGuest =
        (viewAppToGuestExisting && viewAppToGuestInfo == 'active')
        ? true
        : false;
    //
    //
    return (isViewAppToGuest)
        ? Positioned(
            top: 30,
            left: 30,
            child: InkWell(
              onTap: () {
                // .. Goto Login Screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const HomeScreen(0),
                  ),
                );
              },
              // ------------------------------------
              // Button Icon
              // ------------------------------------
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Text(
                  'تخـطي',
                  style: TextStyle(fontFamily: 'JahezlyBold', fontSize: 16),
                ),
              ),
            ),
          )
        : Container();
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. To Login
  |--------------------------------------------------------------------------
  */
  Future<void> _login(Map<String, dynamic> userData) async {
    // User IS Test App On AppStore & GoogleConsole
    if (userData['mobile'] == '550550550') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('OTP_code', '1234').then((_) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                OTPScreen(userData: userData, screen: 'login'),
          ),
        );
      });
      //
    } else {
      // ..Make OTP Code && Send To Mobile
      OTPMaker(userMobile.text).sendSMS().then((result) {
        // .. Is Send "Success" Go To "OPTScreen"
        if (result == 'Success') {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  OTPScreen(userData: userData, screen: 'login'),
            ),
          );
        }
      });
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. To Register
  |--------------------------------------------------------------------------
  */
  void _register(Map<String, dynamic> userData) {
    // ..Make OTP Code && Send To Mobile
    OTPMaker(userMobile.text).sendSMS().then((result) {
      // .. Is Send "Success" Go To "OPTScreen"
      if (result == 'Success') {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) =>
                OTPScreen(userData: userData, screen: 'register'),
          ),
        );
      }
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Validate Mobile Entred
  |--------------------------------------------------------------------------
  */
  void validateMobile(String value) {
    RegExp regExp = RegExp(r'^[0-9]{9}$');
    if (regExp.hasMatch(value)) {
      setState(() => _validateMobile = true);
    } else {
      setState(() => _validateMobile = false);
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Feach User By Mobile
  |--------------------------------------------------------------------------
  */
  Future<Map<String, dynamic>?> fetchUserInfo(mobile) async {
    String linkUrl = J3Config.linkApi('check_user');
    final response = await http.get(Uri.parse('$linkUrl?mobile=$mobile'));
    final Map<String, dynamic>? result = json.decode(response.body);
    return result;
  }

  //
  //
  //
  //
  //
  //
  //
  //
  //
  //

  userIsBlocked(BuildContext context, String mobile) {
    //
    setState(() {
      _validateMobile = false;
      userMobile.clear();
      loginProgress = const Text('متـابعه', style: TextStyle(fontSize: 18));
    });
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return J3SheetPage(
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: Text(
                  '0${mobile.replaceRange(2, 6, '****')}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const Text('الحساب موقوف عن إستخدام التطبيق'),
              GifView.asset(
                'assets/images/error.gif',
                height: 100,
                width: 100,
                frameRate: 30,
                loop: false,
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    const TextSpan(
                      text: 'يرجى الإطلاع ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextSpan(
                      text: 'إتفاقية الاستخدام',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            launchUrlString(J3Config.linkApi('terms_page')),
                    ),
                    const TextSpan(
                      text: ' و ',
                      style: TextStyle(color: Colors.black87),
                    ),
                    TextSpan(
                      text: 'سياسة الخصوصية',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () =>
                            launchUrlString(J3Config.linkApi('privacy_page')),
                    ),
                    const TextSpan(
                      text: '.',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ],
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'JahezlyBold',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Decoration Text Input
  |--------------------------------------------------------------------------
  */
  decoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontFamily: 'JahezlyBold',
        color: Colors.grey.shade500,
      ),
      fillColor: Colors.transparent,
      filled: true,
      border: InputBorder.none,
      counterText: "",
      contentPadding: const EdgeInsets.only(left: 8, bottom: 11, right: 8),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Style Text Input
  |--------------------------------------------------------------------------
  */
  textInput(Widget textInput) {
    return Container(
      width: 300,
      height: 55,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.blueGrey.shade200, width: 0.5),
        ),
        child: Stack(
          children: [
            textInput,
            const Positioned(
              left: 0,
              top: 6,
              child: Text(
                '  +966',
                textAlign: TextAlign.right,
                textDirection: TextDirection.ltr,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
