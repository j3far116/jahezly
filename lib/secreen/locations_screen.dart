import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jahezly_5/models/markets_model.dart';
import 'package:provider/provider.dart';

import '../db_helper.dart';
import '../functions.dart';
import '../global.dart';
import '../main.dart';
import '../models/locations_model.dart';
import '../models/perms_model.dart';
import '../provider/app_config.dart';
import 'package:http/http.dart' as http;

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
| Locations Class
|
|--------------------------------------------------------------------------
*/

class LocationsScreen extends StatelessWidget {
  LocationsScreen({super.key});
  // ---------------------------------------------------------
  // Init Var
  // ---------------------------------------------------------
  final DBHelper dbHelper = DBHelper();

  // ---------------------------------------------------------
  // Run Class
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // ------------------------------------
    // Build AppConfig Provider
    // ------------------------------------
    return Consumer<AppConfig>(
      builder: (context, appConfig, child) {
        // ------------------------------------
        // Build Screen
        // ------------------------------------
        return Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                const SizedBox(height: 90),
                Text(
                  'إختر المدينة لعرض المتاجر المتاحة',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, color: J3Colors('Orange').color),
                ),
                const SizedBox(height: 10),

                // ------------------------------------
                // View Locations Grids
                // ------------------------------------
                FutureBuilder(
                  future: _fetchLocations(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                // ------------------------------------
                                // Srart Grids Builder
                                // ------------------------------------
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  // ------------------------------------
                                  // Settings Grids
                                  // ------------------------------------
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 0.75,
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  // ------------------------------------
                                  // Build Grids
                                  // ------------------------------------
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    // .. Get Locations Info
                                    Locations locationInfo = snapshot.data![index];
                                    // ------------------------------------
                                    // OnTap Location
                                    // ------------------------------------
                                    return InkWell(
                                      // .. If Location Is Alquze
                                      onTap:
                                          (locationInfo.id == '1')
                                              ? () => _onTab(context, appConfig, locationInfo)
                                              : null,

                                      // ------------------------------------
                                      // View Location Content
                                      // ------------------------------------
                                      child: LocationGrid(locationInfo),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Set Location
  |--------------------------------------------------------------------------
  */
  void _onTab(BuildContext context, AppConfig appConfig, Locations locationInfo) {
    // .. Reset Type Id In Provider
    appConfig.setTypeId('0');
    // .. Convert Location Info To JSON String
    String locationsInfoJSON = jsonEncode(locationInfo);
    // .. Add Location Data To Sql
    addNewSetting(appConfig, Perms(key: 'loacation_Info', value: locationsInfoJSON)).then((_) {
      // .. After Finish Add -> Update Settings Provider data
      if (!context.mounted) return;
      context.read<AppConfig>().getAppConfig();
      // .. && Go to Home Screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => MyApp()));
    });
  }

  /*
  |--------------------------------------------------------------------------
  | Function .. Fetch Locations Api
  |--------------------------------------------------------------------------
  */
  Future<List<Locations>> _fetchLocations() async {
    String linkUrl = J3Config.linkApi('locations');
    final response = await http.get(Uri.parse(linkUrl));

    final List result = json.decode(response.body);
    return result.map((e) => Locations.fromJson(e)).toList();
  }
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
| ***********************************************************************
|
|
|
|
|
|
|
|
|  Locations Content Button
|
|--------------------------------------------------------------------------
*/
class LocationGrid extends StatelessWidget {
  const LocationGrid(this.locationInfo, {super.key});

  final Locations locationInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      // ------------------------------------
      // Style Location Content
      // ------------------------------------
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey.shade100, style: BorderStyle.solid), //Border.all
        borderRadius: const BorderRadius.all(Radius.circular(10)), //BorderRadius.all
      ),

      child: Column(
        children: [
          // ------------------------------------
          // Icon Location
          // ------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 38, 28, 10),
            child:
                (locationInfo.id == '1')
                    ? Image.asset('assets/images/location.png')
                    : Image.asset('assets/images/location2.png'),
          ),

          // ------------------------------------
          // Title Location
          // ------------------------------------
          (locationInfo.id == '1')
              ? Text('القـــوز', style: TextStyle(color: J3Colors('Orange').color, fontSize: 20))
              : Text('${locationInfo.name} (SOON)', style: TextStyle(color: J3Colors('Dark').color)),
        ],
      ), //BoxDecoration
    );
  }
}
