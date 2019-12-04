import 'dart:async';

import 'package:book_store/data/remote/product_service.dart';
import 'package:book_store/shared/model/product.dart';
import 'package:book_store/shared/model/rest_error.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
class ProductRepo {
  ProductService _productService;

  ProductRepo({@required ProductService productService})
      : _productService = productService;

  Future<List<Product>> getProductList() async {
    var c = Completer<List<Product>>();
    try {
      var response = await _productService.getProductList();
      var productList = Product.parseProductList(response.data);
      c.complete(productList);
    } on DioError catch (e)  {
      print("ProductRepo getProductList - Dio Err: " + e.toString());
      c.completeError(RestError.fromJson(e.response.data));
    }
    return c.future;
  }
}