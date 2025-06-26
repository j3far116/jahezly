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
| Permissions => App Config
|
|--------------------------------------------------------------------------
*/
class Perms {
  String? id;
  String? key;
  String? value;

  Perms({this.id, this.key, this.value});

  Perms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    value = json['value'];
  }

  Perms.fromMap(Map<String, dynamic> data)
    : id = data['id'].toString(),
      key = data['key'],
      value = data['value'];

  Map<String, dynamic> toMap() {
    return {'key': key, 'value': value};
  }
}
