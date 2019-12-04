

class Order {
  String orderId;
  User user;
  List<Product> products;

  Order({this.orderId,this.user,this.products});
  factory Order.fromJson(Map<String,dynamic> json) {
    return Order(
      orderId:json["orderId"],
      user: User.fromJson(json['user']),
      products: Product.parseProductList(json),
    );
  }

}


class User {
  String fullName ,email;
  User({this.fullName,this.email});

  factory User.fromJson(Map<String,dynamic> json) {
    return User(
      fullName:json["fullName"],
      email:json["email"],
    );
  }
}


class Product {
  String productId;
  String productName;
  int  quantity;
  double price;

  Product({this.productId,this.productName,this.quantity,this.price});


  static List<Product> parseProductList(Map<String,dynamic> json)	 {
    var list = json['products'] as List;
    return list.map((product) => Product.fromJson(product)).toList();
  }

  factory Product.fromJson(Map<String,dynamic> json) {
    return Product (
        productId : json['productId'],
        productName : json['productName'],
        quantity : int.parse(json["quantity"].toString()),
    price : double.tryParse(json['price'].toString()) ?? 0,

    );
  }

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "quantity": quantity,
    "price": price,
  };
}