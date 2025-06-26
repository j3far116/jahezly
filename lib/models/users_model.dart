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
| Market
|
|--------------------------------------------------------------------------
*/
class UserInfo {
  String? id;
  String? name;
  String? mobile;
  String? email;

  UserInfo({this.id, this.name, this.mobile, this.email});

  UserInfo.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['fullname'];
    mobile = json['mobile'];
    email = json['email'];
  }

  /* Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    return data;
  } */

  /* UserInfo.fromMap(Map<dynamic, dynamic> data)
    : id = data['id'].toString(),
      name = data['name'],
      mobile = data['mobile'],
      email = data['email']; */

  /* Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'mobile': mobile, 'email': email};
  } */
}
