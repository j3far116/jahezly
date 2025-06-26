import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jahezly_5/login/login_control.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../global.dart';
import '../provider/app_config.dart';
import '../widgets/colors.dart';
import 'login_screen.dart';

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
| Register Screen
|
|--------------------------------------------------------------------------
*/
class RegisterScreen extends StatefulWidget {
  const RegisterScreen(this.mobile, {super.key});

  final String mobile;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ------------------------------------
  // Init Var
  // ------------------------------------
  final name = TextEditingController();
  final email = TextEditingController();
  dynamic resultMSG = Container();
  bool _validateName = false;
  bool _validateEmail = false;
  Widget registerProgress = const Text('تسجيل', style: TextStyle(fontSize: 18));

  // ------------------------------------
  // dispose
  // ------------------------------------
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    super.dispose();
  }

  // ------------------------------------
  // Run Class
  // ------------------------------------
  @override
  Widget build(BuildContext context) {
    //
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    //
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Center(
                  child: SizedBox(
                    width: 350,
                    child: Column(
                      children: [
                        // ------------------------------------
                        // Title Screen
                        // ------------------------------------
                        Text(
                          'إنشاء حساب جديد',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: J3Colors('Orange').color, fontSize: 35),
                        ),
                        const SizedBox(height: 10),
                        // ------------------------------------
                        // Descrption Screen
                        // ------------------------------------
                        const Text(
                          'لإنشاء حساب جديد أكمل التالي',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: 'JahezlyBold', fontSize: 18),
                        ),
                        const SizedBox(height: 30),
                        // ------------------------------------
                        // name Text Input
                        // ------------------------------------
                        textInput(
                          TextField(
                            controller: name,
                            autofocus: true,
                            cursorColor: Colors.deepOrange,
                            decoration: decoration('الاسم الكامل'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                            enableSuggestions: false,
                            autocorrect: false,
                            // ------------------------------------
                            // Validate Mobile Entred
                            // ------------------------------------
                            onChanged: (value) => validateName(value),
                          ),
                        ),

                        const SizedBox(height: 10),
                        // ------------------------------------
                        // Email Text Input
                        // ------------------------------------
                        textInput(
                          TextField(
                            controller: email,
                            cursorColor: Colors.deepOrange,
                            decoration: decoration('البريد الإلكتروني'),
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 18),
                            enableSuggestions: false,
                            autocorrect: false,
                            // ------------------------------------
                            // Validate Email Entred
                            // ------------------------------------
                            onChanged: (value) => validateEmail(value),
                          ),
                        ),
                        // ------------------------------------
                        // Result MSG
                        // ------------------------------------
                        resultMSG,

                        const SizedBox(height: 20),

                        // ------------------------------------
                        // Privacy && Terms To Continue Register
                        // ------------------------------------
                        _privacy(),

                        const SizedBox(height: 10),

                        // ------------------------------------
                        // Register Button
                        // ------------------------------------
                        SizedBox(
                          width: 250,
                          height: 45,
                          child: ElevatedButton(
                            // .. Validate If Entred Is Mobile & Email
                            onPressed:
                                (_validateName && _validateEmail)
                                    ? () {
                                      // .. Change Button Text To Laoding...
                                      setState(() {
                                        registerProgress = J3Widget.widget('progress_btn_icon');
                                      });
                                      // .. Check Register Code
                                      ckeckRegister(appConfig);
                                    }
                                    : null,
                            // ------------------------------------
                            // Style Regiter Button
                            // ------------------------------------
                            style: ElevatedButton.styleFrom(
                              backgroundColor: J3Colors('Orange').color,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                            ),
                            // ------------------------------------
                            // Title Regiter Button
                            // ------------------------------------
                            child: registerProgress,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // ------------------------------------
            // Button Back
            // ------------------------------------
            Positioned(
              top: 30,
              left: 30,
              child: InkWell(
                onTap: () {
                  // .. Goto Login Screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
                  );
                },
                child: const Directionality(
                  textDirection: TextDirection.ltr,
                  // ------------------------------------
                  // Button Icon
                  // ------------------------------------
                  child: CloseButtonIcon(),
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
  | Function .. Validate name Entred
  |--------------------------------------------------------------------------
  */
  void validateName(String name) {
    setState(() {
      (name.length >= 3 && name.isNotEmpty) ? _validateName = true : _validateName = false;
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Validate Email Entred
  |--------------------------------------------------------------------------
  */
  void validateEmail(String email) {
    RegExp regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      (regExp.hasMatch(email) == true) ? _validateEmail = true : _validateEmail = false;
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Check Email In Database
  |--------------------------------------------------------------------------
  */
  Future<bool> checkEmail(email) async {
    String linkUrl = J3Config.linkApi('check_email');
    final response = await http.get(Uri.parse("$linkUrl?email=$email"));
    final bool result = json.decode(response.body);
    return result;
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Decoration Text Input
  |--------------------------------------------------------------------------
  */
  decoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(fontFamily: 'JahezlyBold', color: Colors.grey.shade500),
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
      decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(50)),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.blueGrey.shade200, width: 0.5),
        ),
        child: textInput,
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Start Register
  |--------------------------------------------------------------------------
  */
  void ckeckRegister(AppConfig appConfig) {
    setState(() {
      // .. Show MSG
      resultMSG = Container();
    });
    // .. Check Email In Database
    checkEmail(email.text).then((value) {
      if (value == true) {
        // .. If Email Is Used
        setState(() {
          // .. Show MSG
          resultMSG = const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'غير متاح \n استخدم بريد إلكتروني آخر',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
          );
          // .. ReSet Button Title
          registerProgress = const Text('تسجيل', style: TextStyle(fontSize: 18));
        });
      } else {
        // .. If Email Not Used
        // .. Validate name & Email
        if (name.text.isNotEmpty && email.text.isNotEmpty) {
          // .. Begin Register
          register(name: name.text, mobile: widget.mobile, email: email.text).then((userData) {
            // .. Start Lgin
            if (!mounted) return;
            J3LoginControl(context, appConfig).login(userData!);
          });
        }
      }
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Register New User In Datebase
  |--------------------------------------------------------------------------
  */
  Future<Map<String, dynamic>?> register({String? name, String? mobile, String? email}) async {
    String url = J3Config.linkApi('register');
    var response = await http.post(Uri.parse(url), body: {'name': name, 'mobile': mobile, 'email': email});
    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);
      return result;
    }
    return null;
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Privacy && Terms To Continue Register
  |--------------------------------------------------------------------------
  */
  _privacy() {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          const TextSpan(text: 'إختيارك للمتابعة يعني موافقتك على ', style: TextStyle(color: Colors.black87)),
          TextSpan(
            text: 'إتفاقية الاستخدام \n',
            style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()..onTap = () => launchUrlString(J3Config.linkApi('terms_page')),
          ),
          const TextSpan(text: 'و ', style: TextStyle(color: Colors.black87)),
          TextSpan(
            text: 'سياسة الخصوصية',
            style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            recognizer:
                TapGestureRecognizer()..onTap = () => launchUrlString(J3Config.linkApi('privacy_page')),
          ),
          const TextSpan(text: ' والإطلاع عليها.', style: TextStyle(color: Colors.black87)),
        ],
        style: const TextStyle(fontSize: 14, fontFamily: 'JahezlyBold'),
      ),
    );
  }
}
