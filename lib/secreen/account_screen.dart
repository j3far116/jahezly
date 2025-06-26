import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../db_helper.dart';
import '../global.dart';
import '../login/login_control.dart';
import '../provider/app_config.dart';
import '../sql_viewer.dart';
import '../widgets/colors.dart';
import '../widgets/sheet_page.dart';

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
| Account Screen
|
|--------------------------------------------------------------------------
*/

/* class AccountScreen extends StatelessWidget {
  AccountScreen({super.key});
  //
  final DBHelper dbHelper = DBHelper();
  //
  @override
  Widget build(BuildContext context) {
    //
    //
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    //
    var userIsLogin = appConfig.keys.contains('user_info');
    var userInfo = appConfig.settingInfo('user_info');
    //
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SqlViewer()));
              },
              child: Text('View Sql'),
            ),
          ),
          SizedBox(height: 50),
          (appConfig.isLogin)
              ? ElevatedButton(
                onPressed: () {
                  if (userIsLogin && userInfo!.isNotEmpty) {
                    J3LoginControl(context, appConfig).logOut();
                    /* appConfig.setIsLogin(false);
                    // .. After Remove user_info From AppConfig

                    dbHelper.removeSettingInSql('user_info').then((_) {
                      if (!context.mounted) return;
                      appConfig.userInfo = UserInfo();
                      context.read<AppConfig>().getAppConfig().then((value) {
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MyApp(),
                          ),
                        );
                      });
                    }); */

                    //
                    //
                  }
                },
                child: Text('Log'),
              )
              : Container(),
        ],
      ),
    );
  }
} */

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // ------------------------------------
  // Init Var
  // ------------------------------------
  final DBHelper dbHelper = DBHelper();
  //Map<String, dynamic>? currUser;
  //Map<String, dynamic>? settings;
  List<dynamic> listSharedPrefs = ['listSharedPrefs'];

  @override
  void initState() {
    super.initState();
    getAllSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    // ------------------------------------
    // Init Provider
    // ------------------------------------
    //
    //
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    //
    /* var userIsLogin = appConfig.keys.contains('user_info');
    var userInfo = appConfig.settingInfo('user_info'); */

    // ------------------------------------
    // Run Class
    // ------------------------------------
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: J3Colors('Orange').color,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'حســـابي',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 45),
            // ------------------------------------
            // Header Page
            // ------------------------------------
            Center(
              child: Text(
                "مرحباً بك ${appConfig.userInfo.name ?? '...'}",
                style: const TextStyle(fontSize: 24),
              ),
            ),

            // ------------------------------------
            // Lite Settings Option
            // ------------------------------------
            /* const ListTile(
              title: Text('تغيير الجوال'),
              horizontalTitleGap: 1,
            ),
            const Divider(),
            const ListTile(
              title: Text('تغيير الإيميل'),
            ),*/

            //
            //
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listSharedPrefs.length,
                    itemBuilder: (context, index) {
                      return Text(
                        listSharedPrefs[index].toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: (index == 0)
                              ? J3Colors('Orange').color
                              : Colors.black,
                        ),
                      );
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const SqlViewer(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15, left: 15),
                    child: Text('Sql Viewer'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 150),
            // ------------------------------------
            // LogOut Option
            // ------------------------------------
            (appConfig.isLogin)
                ? SizedBox(
                    width: 300,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1),
                      ),
                      onPressed: () async {
                        //if (userIsLogin && userInfo!.isNotEmpty) {
                        if (appConfig.isLogin) {
                          J3LoginControl(context, appConfig).logOut();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text(
                          'خــــــروج',
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ),
                  )
                : Container(),
            //
            //
            //
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              child: _privacy(),
            ),
            Spacer(),
            //
            InkWell(
              onTap: () {
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
                          Center(
                            child: const Text(
                              'أنت على وشك حذف حسابك..!',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          SizedBox(height: 70),
                          const Text(
                            '* لا يمكن الرجوع بعد  هذه الخطوة بعد تأكيدها',
                          ),

                          const Text(
                            '* بعد الحذف لا يمكن استخدام رقم الجوال هذا للسجيل مره أخرى',
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                removeAccount().then((val) {
                                  if (val!) {
                                    if (!context.mounted) return;
                                    J3LoginControl(context, appConfig).logOut();
                                  }
                                });
                              },
                              child: Text('تأكيدالحذف'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'حذف الحساب',
                  style: TextStyle(
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red,
                  ),
                ),
              ),
            ),
            //
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 20),
              child: Text(
                'v_1.6.0',
                style: TextStyle(color: Colors.blueGrey.shade300),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void>? getAllSharedPrefs() {
    SharedPreferences.getInstance().then((data) {
      data.getKeys().forEach((key) {
        listSharedPrefs.add("$key=${data.get(key)}");
      });
      setState(() => ());
    });
    return null;
  }

  _privacy() {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: 'إتفاقية الاستخدام',
                style: const TextStyle(color: Colors.blueGrey),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      launchUrlString(J3Config.linkApi('terms_page')),
              ),
              const TextSpan(
                text: '   -   ',
                style: TextStyle(color: Colors.black87),
              ),
              TextSpan(
                text: 'سياسة الخصوصية',
                style: const TextStyle(color: Colors.blueGrey),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      launchUrlString(J3Config.linkApi('privacy_page')),
              ),
            ],
            style: const TextStyle(fontSize: 14, fontFamily: 'JahezlyBold'),
          ),
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(
                text: '\n',
                style: TextStyle(color: Colors.black87),
              ),
              TextSpan(
                text: 'سياسة الاسترجاع والاستبدال',
                style: const TextStyle(color: Colors.blueGrey),
                recognizer: TapGestureRecognizer()
                  ..onTap = () =>
                      launchUrlString(J3Config.linkApi('return_page')),
              ),
            ],
            style: const TextStyle(
              fontSize: 14,
              height: 1.2,
              fontFamily: 'JahezlyBold',
            ),
          ),
        ),
      ],
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Feach User By Mobile
  |--------------------------------------------------------------------------
  */
  Future<bool?> removeAccount() async {
    AppConfig appConfig = Provider.of<AppConfig>(context, listen: false);
    String? id = appConfig.userInfo.id;
    String? mobile = appConfig.userInfo.mobile;
    //
    String linkUrl = J3Config.linkApi('remove_account');
    final response = await http.get(
      Uri.parse('$linkUrl?id=$id&mobile=$mobile'),
    );
    final bool result = json.decode(response.body);
    return result;
  }
}
