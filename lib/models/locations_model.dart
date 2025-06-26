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
class Locations {
  String? id;
  String? name;
  String? status;

  Locations({this.id, this.name, this.status});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'status': status};

  Locations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
  }
}
