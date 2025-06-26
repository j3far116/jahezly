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
import 'dart:convert';

class Markets {
  String? id;
  String? location;
  String? date;
  String? name;
  String? disc;
  String? type;
  String? address;
  String? cover;
  String? logo;
  String? openStatus;
  double? minOrder;

  Markets({
    this.id,
    this.location,
    this.date,
    this.name,
    this.disc,
    this.type,
    this.address,
    this.cover,
    this.logo,
    this.openStatus,
    this.minOrder,
  });

  Markets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    location = json['location'];
    date = json['date'];
    name = json['name'];
    disc = json['disc'];
    type = json['type'];
    address = json['address'];
    cover = json['cover'];
    logo = json['logo'];
    openStatus = json['openStatus'];
    minOrder = double.parse(json['minOrder']);
  }

  String toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['location'] = location;
    data['date'] = date;
    data['name'] = name;
    data['disc'] = disc;
    data['type'] = type;
    data['address'] = address;
    data['cover'] = cover;
    data['logo'] = logo;
    data['openStatus'] = openStatus;
    data['minOrder'] = minOrder;
    return json.encode(data);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'location': location,
      'date': date,
      'name': name,
      'disc': disc,
      'type': type,
      'address': address,
      'cover': cover,
      'logo': logo,
      'openStatus': openStatus,
      'minOrder': minOrder,
    };
  }

  Markets.fromMap(Map<String, dynamic> data)
    : id = data['id'],
      location = data['location'],
      date = data['date'],
      name = data['name'],
      disc = data['disc'],
      type = data['type'],
      address = data['address'],
      cover = data['cover'],
      logo = data['logo'],
      openStatus = data['openStatus'],
      minOrder = data['minOrder'];
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
| Markets Type
|
|--------------------------------------------------------------------------
*/
class MarketsType {
  String? id;
  String? name;
  String? img;

  MarketsType({this.id, this.name, this.img});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'img': img};

  MarketsType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    img = json['img'];
  }
}
