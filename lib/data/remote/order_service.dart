

import 'package:book_store/network/book_client.dart';
import 'package:book_store/shared/api_method_name.dart';
import 'package:book_store/shared/model/product.dart';
import 'package:dio/dio.dart';
class OrderService {
  Future<Response> countShoppingCart() {
    return BookClient.instance.dio.get(
      APIMethodName.ORDER_COUNT,
    );
  }

  Future<Response> addToCart(Product product) {
    return BookClient.instance.dio.post(
      APIMethodName.ORDER_ADD,
      data: product.toJson(),
    );
  }

  Future<Response> orderDetail(String orderId) {
    return BookClient.instance.dio.get(
      APIMethodName.ORDER_DETAIL,
      queryParameters: {
        'order_id': orderId,
      },
    );
  }

  Future<Response> updateOrder(Product product) {
    return BookClient.instance.dio.post(
      APIMethodName.ORDER_UPDATE,
      data: {
        'orderId': product.orderId,
        'quantity': product.quantity,
        'productId': product.productId,
      },
    );
  }

  Future<Response> confirm(String orderId) {
    return BookClient.instance.dio.post(
      APIMethodName.ORDER_CONFIRM,
      data: {
        'orderId': orderId,
        'status': 'CONFIRM',
      },
    );
  }
}
