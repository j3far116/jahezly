import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../global.dart';
import '../widgets/colors.dart';

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
| Make OTP
| To Generate & reSend OTP Code By SMS
|
|--------------------------------------------------------------------------
*/

class OTPMaker {
  final String mobile;

  OTPMaker(this.mobile);

  /*
  |--------------------------------------------------------------------------
  | Function .. Send OPT Code
  |--------------------------------------------------------------------------
  */

  Future<String?> sendSMS() async {
    // .. Generate 4 Random Numbers
    final int randomCode = randomInt(1000, 10000);
    // .. Start Sent SMS
    String url = J3Config.linkApi('sms_otp');
    final response = await http.post(
      Uri.parse(url),
      body: {
        'key':
            'e78880f3a261d211389d30dd9533e7047687c93df2b19707184073b59894977b',
        'user': 'j3far116',
        'sender': 'Jahezly',
        'mobile': mobile,
        'otpCode': '$randomCode',
      },
    );

    if (response.statusCode == 200) {
      final String result = json.decode(json.encode(response.body));
      // .. Set OTP Code In SharedPrefs
      saveOTP(randomCode.toString());
      return result;
    }
    return 'Success';
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Generate 4 Random Numbers
  |--------------------------------------------------------------------------
  */
  int randomInt(int min, int max) {
    int rando = min + Random().nextInt((max + 1) - min);
    return rando;
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Set OTP Code In SharedPrefs
  |--------------------------------------------------------------------------
  */
  void saveOTP(String code) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('OTP_code', code);
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
| Timer OTP
|
|--------------------------------------------------------------------------
*/
class OTPTimer extends StatefulWidget {
  const OTPTimer(this.mobile, {super.key});
  final String mobile;

  @override
  State<OTPTimer> createState() => _OTPTimerState();
}

class _OTPTimerState extends State<OTPTimer> {
  // ------------------------------------
  // Init Var
  // ------------------------------------
  Timer? otpTimer;
  int secoundsTimer = 120;
  late Duration duration;

  Widget resetProgress = const Text('إعادة الإرسال');
  String? mobile;
  // .. For Disable Button || Active
  bool activeReSendOTP = false;

  // ------------------------------------
  // Init State
  // ------------------------------------
  @override
  void initState() {
    super.initState();
    // .. First Start Timer
    duration = Duration(seconds: secoundsTimer);
    startTimer();
  }

  // ------------------------------------
  // dispose
  // ------------------------------------
  @override
  void dispose() {
    otpTimer?.cancel();
    super.dispose();
  }

  // ------------------------------------
  // Run Class
  // ------------------------------------
  @override
  Widget build(BuildContext context) {
    // ------------------------------------
    // Init Widget Var
    // ------------------------------------
    mobile = widget.mobile;
    // .. Convert To Secounds & Minutes
    final minutes = strDigits(duration.inMinutes.remainder(60));
    final seconds = strDigits(duration.inSeconds.remainder(60));

    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ------------------------------------
            // Timer Title
            // ------------------------------------
            const Text(
              'يمكنك إعادة الارسال بعد',
              style: TextStyle(color: Colors.blueGrey),
            ),
            // ------------------------------------
            // View Timer Counter
            // ------------------------------------
            Text(
              ' $minutes:$seconds  ',
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // ------------------------------------
        // ReSent Button
        // ------------------------------------
        ElevatedButton(
          // .. Check In Button Disable || Active
          onPressed: activeReSendOTP
              ? () {
                  resendOTP(mobile!);
                }
              : null,
          // ------------------------------------
          // Style Button
          // ------------------------------------
          style: ElevatedButton.styleFrom(
            backgroundColor: J3Colors('Orange').color,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          // ------------------------------------
          // Title Button
          // ------------------------------------
          child: resetProgress,
        ),
      ],
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Start Timer
  |--------------------------------------------------------------------------
  */
  void startTimer() {
    // Reset Secounds Timer
    duration = Duration(seconds: secoundsTimer);
    // Start Timer
    otpTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setCountDown(),
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Generate & ReSend OTP Code After Complate Timer
  |--------------------------------------------------------------------------
  */
  Future<void> resendOTP(String mobile) async {
    // .. Stop Timer
    //otpTimer?.cancel();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // .. Remove OTP Code Fro SharedPrefs
    prefs.remove('OTP');

    setState(() {
      // .. Change Button Text To Laoding...
      resetProgress = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    });
    // .. Generate OTP Code & Send SMS
    OTPMaker(mobile).sendSMS().then((value) {
      // .. If Sent SMS
      if (value == 'Success') {
        setState(() {
          // .. Disale ReSent Button
          activeReSendOTP = false;
          // .. Change Button Title
          resetProgress = const Text('إعادة الإرسال');
          // .. Again Start New Timer
          startTimer();
        });
      }
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Count Down Timer
  |--------------------------------------------------------------------------
  */
  void setCountDown() {
    // .. CountDown By 1 secound
    const reduceSecondsBy = 1;
    setState(() {
      // .. CountDown Secounds
      //debugPrint(duration.inSeconds.toString());
      final seconds = duration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        // .. Stop Timer
        otpTimer?.cancel();
        // .. ReActive Button
        activeReSendOTP = true;
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Convert String To Secound Format
  |--------------------------------------------------------------------------
  */
  String strDigits(int n) {
    return n.toString().padLeft(2, '0');
  }
}
