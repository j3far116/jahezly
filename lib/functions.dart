import 'db_helper.dart';
import 'models/perms_model.dart';
import 'provider/app_config.dart';

/*
|--------------------------------------------------------------------------
///     Function .. add_new_setting -> "addNewSetting"
|--------------------------------------------------------------------------
*/
final DBHelper dbHelper = DBHelper();

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
| Function .. Add New Setting "Perm" To Sql
|
|--------------------------------------------------------------------------
*/
Future<void> addNewSetting(AppConfig appConfig, Perms perm) async {
  // .. Check If Perm Inserted In sql
  if (appConfig.keys.isNotEmpty) {
    var isSetlocation = appConfig.keys.contains(perm.key);
    // .. Add To Sql If Not Inserted
    if (!isSetlocation) {
      dbHelper.addSettingInSql(perm);
    }
  }
}
