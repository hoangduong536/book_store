import 'dart:async';
import 'package:book_store/shared/model/order.dart';
import 'package:book_store/shared/model/rest_error.dart';
import 'package:dio/dio.dart';
import 'package:book_store/data/remote/order_service.dart';
import 'package:book_store/shared/model/product.dart';
import 'package:book_store/shared/model/shopping_cart.dart';
import 'package:flutter/widgets.dart';

class OrderRepo {
  OrderService _orderService;
  String _orderId;

  OrderRepo({@required OrderService orderService, @required String orderId})
      : _orderService = orderService,
        _orderId = orderId;

  Future<ShoppingCart> addToCart(Product product) async {
    var c = Completer<ShoppingCart>();
    try {
      var response = await _orderService.addToCart(product);
      var shoppingCart = ShoppingCart.fromJson(response.data['data']);
      c.complete(shoppingCart);
    } on DioError catch (e){
      print("OrderRepo addToCart - Dio Err: " + e.toString());
      c.completeError(RestError.fromJson(e.response.data));
    }
    return c.future;
  }

  Future<ShoppingCart> getShoppingCartInfo() async {
    var c = Completer<ShoppingCart>();
    try {
      var response = await _orderService.countShoppingCart();
      var shoppingCart = ShoppingCart.fromJson(response.data['data']);
      c.complete(shoppingCart);
    } on DioError catch (e){
      print("OrderRepo getShoppingCartInfo - Dio Err: " + e.toString());
      c.completeError(RestError.fromJson(e.response.data));
    }
    return c.future;
  }

  Future<Order> getOrderDetail() async {
    var c = Completer<Order>();
    try {
      var response = await _orderService.orderDetail(_orderId);
      if (response.data['data']['items'] != null) {
        var order = Order.fromJson(response.data['data']);
        c.complete(order);
      } else {
        print("OrderRepo getOrderDetail - 1 =================");
        c.completeError(RestError.fromData('Không lấy được đơn hàng'));
      }
    } on DioError {
      print("OrderRepo getOrderDetail - 2 =================");
      c.completeError(RestError.fromData('Không lấy được đơn hàng'));
    } catch (e) {
      print("OrderRepo getOrderDetail - 3  =================" + e.toString());
      c.completeError(RestError.fromData(e.toString()));
    }
    return c.future;
  }

  Future<bool> updateOrder(Product product) async {
    var c = Completer<bool>();
    try {
      await _orderService.updateOrder(product);
      c.complete(true);
    } on DioError {
      c.completeError(RestError.fromData('Lỗi update đơn hàng'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<bool> confirmOrder() async {
    var c = Completer<bool>();
    try {
      await _orderService.confirm(_orderId);
      c.complete(true);
    } on DioError {
      c.completeError(RestError.fromData('Lỗi confirm đơn hàng'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }
}
