import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/app_config.dart';
import 'login_control.dart';
import 'login_screen.dart';
import 'opt_maker.dart';
import 'register_screen.dart';

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
| OTP Screen
|
|--------------------------------------------------------------------------
*/

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key, required this.userData, required this.screen});

  final Map<String, dynamic> userData;
  final String screen;

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // ------------------------------------
  // Init Var
  // ------------------------------------
  Widget erroeMSG = Container();
  late String screen;
  late Map<String, dynamic> userData;

  // ------------------------------------
  // Run Class
  // ------------------------------------
  @override
  Widget build(BuildContext context) {
    // ------------------------------------
    // Init Widget Var
    // ------------------------------------
    screen = widget.screen;
    userData = widget.userData;

    //
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ------------------------------------
                // Title Screen
                // ------------------------------------
                const SizedBox(height: 80),
                const Text(
                  'أدخل الرمز المرسل إلى',
                  style: TextStyle(fontSize: 30),
                ),
                Text(
                  '0${userData['mobile']}',
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                // ------------------------------------
                // Title Screen
                // ------------------------------------
                erroeMSG,
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 50, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // ------------------------------------
                      // Pin Code Class
                      // ------------------------------------
                      PinCodeFields(
                        length: 4,
                        fieldHeight: 80,
                        fieldWidth: 100,
                        fieldBorderStyle: FieldBorderStyle.square,
                        borderRadius: BorderRadius.circular(10.0),
                        borderColor: Colors.black12,
                        borderWidth: 3,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        activeBorderColor: Colors.deepOrange,
                        autoHideKeyboard: false,
                        textStyle: const TextStyle(
                          fontSize: 50.0,
                          color: Colors.deepOrange,
                        ),
                        // ------------------------------------
                        // Run OnChange
                        // ------------------------------------
                        onChange: (value) {
                          setState(() => erroeMSG = Container());
                        },
                        // ------------------------------------
                        // Run OnComplate
                        // ------------------------------------
                        onComplete: (value) {
                          // .. Get OTP Code From SharedPrefs
                          getOTPCode().then((val) {
                            // .. If OTP In SharedPrefs == OTP Entred
                            if (val == value) {
                              // .. Check Screen After Confirm OTP Code
                              switch (screen) {
                                case 'login':
                                  // .. Start Login
                                  if (!context.mounted) return;
                                  J3LoginControl(
                                    context,
                                    appConfig,
                                  ).login(userData);
                                  break;
                                //
                                case 'register':
                                  // .. goto register screen
                                  if (!context.mounted) return;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RegisterScreen(userData['mobile']),
                                    ),
                                  );
                                  break;
                              }
                            } else {
                              // ------------------------------------
                              // Error MSG
                              // ------------------------------------
                              setState(() {
                                erroeMSG = const Text(
                                  'تحقق من إدخال الرمز الصحيح',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 20,
                                  ),
                                );
                              });
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // ------------------------------------
                // Timer reSend OTP
                // ------------------------------------
                if (userData['mobile'] != '550550550')
                  OTPTimer(userData['mobile']),
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
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LoginScreen(),
                    ),
                  );
                },
                // ------------------------------------
                // Button Icon
                // ------------------------------------
                child: const CloseButtonIcon(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Get OTP Code From SharedPrefs
  |--------------------------------------------------------------------------
  */
  Future<String?> getOTPCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var optCode = prefs.getString('OTP_code');
    return optCode;
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
| Error SMS Screen
|
|--------------------------------------------------------------------------
*/
class ErrorSMSScreen extends StatelessWidget {
  const ErrorSMSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Error SMS',
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('تحقق من توفر الإنترنت أو تواصل ع الدعم القني'),
            ),
          ],
        ),
      ),
    );
  }
}
