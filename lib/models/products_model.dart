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
| Products
|
|--------------------------------------------------------------------------
*/

class Products {
  String? id;
  String? marketId;
  String? status;
  String? name;
  String? disc;
  double? price;
  String? cover;

  Products({this.id, this.marketId, this.status, this.name, this.disc, this.price, this.cover});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    marketId = json['marketId'];
    status = json['status'];
    name = json['name'];
    disc = json['disc'];
    price = double.parse('${json['price']}');
    cover = json['cover'];
  }

  Products.fromMap(Map<String, dynamic> data)
    : id = data['id'],
      marketId = data['marketId'],
      status = data['status'],
      name = data['name'],
      disc = data['disc'],
      price = double.parse('${data['price']}'),
      cover = data['cover'];
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
| Product In Sql Class
|
|--------------------------------------------------------------------------
*/
class ProductInSql {
  int? id;
  String? marketId;
  String? key; // .. => Product Id In Server
  String? optIds;
  double? optTotal;
  String? name;
  double? price;
  int? quantity;
  double? total;

  ProductInSql({
    this.id,
    this.marketId,
    this.key,
    this.optIds,
    this.optTotal,
    this.name,
    this.price,
    this.quantity,
    this.total,
  });

  ProductInSql.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['marketId']);
    marketId = json['marketId'];
    key = json['key'];
    optIds = json['optIds'];
    optTotal = json['optTotal'];
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    total = json['total'];
  }

  ProductInSql.fromMap(Map<String, dynamic> data)
    : id = data['id'],
      marketId = data['marketId'],
      key = data['key'],
      optIds = data['optIds'],
      optTotal = data['optTotal'],
      name = data['name'],
      price = data['price'],
      quantity = data['quantity'],
      total = data['total'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marketId': marketId,
      'key': key,
      'optIds': optIds,
      'optTotal': optTotal,
      'name': name,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }
  /* 
  String toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['marketId'] = marketId;
    data['key'] = key;
    data['name'] = name;
    data['price'] = price;
    data['quantity'] = quantity;
    data['totalPrice'] = totalPrice;
    return json.encode(data);
  } */

  /*   double get totalPrice {
    double pp = price! * quantity!;
    return pp;
  } */
}
