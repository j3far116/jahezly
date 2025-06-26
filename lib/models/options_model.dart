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
| OptGroup
|
|--------------------------------------------------------------------------
*/
class OptGroup {
  String? id;
  String? marketId;
  String? productId;
  String? name;
  String? options;
  String? max;
  String? require;
  String? status;
  dynamic opt;

  OptGroup({
    this.id,
    this.marketId,
    this.productId,
    this.name,
    this.options,
    this.max,
    this.require,
    this.status,
    this.opt,
  });

  OptGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    marketId = json['marketId'];
    productId = json['productId'];
    name = json['name'];
    options = json['options'];
    max = json['max'];
    require = json['required'];
    status = json['status'];
    opt = json['opt'];
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
| Options
|
|--------------------------------------------------------------------------
*/
class Opt {
  String? id;
  String? marketId;
  String? name;
  double? price;
  String? date;
  //String? opt;

  Opt({
    this.id,
    this.marketId,
    this.name,
    this.price,
    this.date,
    //this.opt,
  });

  Opt.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    marketId = json['marketId'];
    name = json['name'];
    price = json['price'];
    date = json['date'];
    //opt = json['opt'];
  }

  /* Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marketId': marketId,
      'name': name,
      'price': double.parse(price!.toStringAsFixed(2)),
      //'quantity': quantity,
    };
  } */
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
| Options
|
|--------------------------------------------------------------------------
*/
class OptInSql {
  int? id;
  String? productId;
  String? name;
  double? price;
  //String? opt;

  OptInSql({this.id, this.productId, this.name, this.price});

  OptInSql.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'productId': productId, 'name': name, 'price': price};
  }

  OptInSql.fromMap(Map<String, dynamic> data)
    : id = data['id'],
      productId = data['productId'],
      name = data['name'],
      price = data['price'];
}
