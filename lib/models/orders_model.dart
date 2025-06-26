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
class Orders {
  int? id;
  String? counter;
  double? totalPrice;
  String? status;
  String? payType;
  bool? paid;
  String? date;
  String? marketId;
  String? marketName;
  String? marketLogo;
  String? countItems;

  Orders({
    this.id,
    this.totalPrice,
    this.counter,
    this.status,
    this.payType,
    this.paid,
    this.date,
    this.marketId,
    this.marketName,
    this.marketLogo,
    this.countItems,
  });

  Orders.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    counter = json['counter'];
    totalPrice = double.parse('${json['totalPrice']}');
    status = json['status'];
    payType = json['pay_type'];
    paid = (json['paid'] == '0') ? false : true;
    date = json['date'];
    marketId = json['marketId'];
    marketName = json['marketName'];
    marketLogo = json['marketLogo'];
    countItems = json['countItems'].toString();
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
| Order In Sql
|
|--------------------------------------------------------------------------
*/
class OrderInSql {
  final int? id;
  final String? marketId;
  final String? marketInfo;
  final String? productsKey;
  final double? price;

  OrderInSql({
    this.id,
    this.marketId,
    this.marketInfo,
    this.productsKey,
    this.price,
  });

  OrderInSql.fromMap(Map<dynamic, dynamic> data)
    : id = data['id'],
      marketId = data['marketId'],
      marketInfo = data['marketInfo'],
      productsKey = data['productsKey'],
      price = data['price'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marketId': marketId,
      'marketInfo': marketInfo,
      'productsKey': productsKey,
      'price': price,
      //'quantity': quantity,
    };
  }

  int get quantity {
    if (productsKey == null) {
      return 1;
    } else {
      return productsKey!.split(',').length;
    }
  }
}
