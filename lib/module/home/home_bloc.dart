

import 'package:rxdart/rxdart.dart';
import 'package:book_store/base/base_bloc.dart';
import 'package:book_store/base/base_event.dart';
import 'package:book_store/data/repo/order_repo.dart';
import 'package:book_store/data/repo/product_repo.dart';
import 'package:book_store/event/home/add_to_cart_event.dart';
import 'package:book_store/shared/model/product.dart';
import 'package:book_store/shared/model/shopping_cart.dart';
import 'package:flutter/widgets.dart';

class HomeBloc extends BaseBloc {

  final ProductRepo _productRepo;
  final OrderRepo _orderRepo;

  var _shoppingCart = ShoppingCart();
  static HomeBloc _instance;


  final _shoppingCardSubject = BehaviorSubject<ShoppingCart>();

  Stream<ShoppingCart> get shoppingCartStream => _shoppingCardSubject.stream;
  Sink<ShoppingCart> get shoppingCartSink => _shoppingCardSubject.sink;


  static HomeBloc getInstance({
    @required ProductRepo productRepo,
    @required OrderRepo orderRepo,
  }){
    if(_instance == null){
      _instance = HomeBloc._internal(productRepo:productRepo , orderRepo: orderRepo);
    }
    return _instance;
  }

  HomeBloc._internal({
    @required ProductRepo productRepo,
    @required OrderRepo orderRepo,
  })  : _productRepo = productRepo,
        _orderRepo = orderRepo;
  
  @override
  void dispatchEvent(BaseEvent event) {
    // TODO: implement dispatchEvent
    switch(event.runtimeType){
      case AddToCartEvent :
        _handleAddToCart(event);
        break;
    }
  }

  _handleAddToCart(event){
    print("HomeBloc  - _handleAddToCart ====================");
    AddToCartEvent addToCartEvent = event as AddToCartEvent;
    _orderRepo.addToCart(addToCartEvent.product).then((shoppingCart){
      print("HomeBloc  - _handleAddToCart - Success ====================");
      _shoppingCart.orderId = shoppingCart.orderId;
      shoppingCartSink.add(shoppingCart);
    });
  }

  getShoppingCartInfo() {
    print("HomeBloc  - getShoppingCartInfo ====================");
    Stream<ShoppingCart>.fromFuture(_orderRepo.getShoppingCartInfo()).listen(
            (shoppingCart) {
              print("HomeBloc  - getShoppingCartInfo - Success ====================");
          _shoppingCart = shoppingCart;
          shoppingCartSink.add(shoppingCart);
        }, onError: (err) {
      print("HomeBloc  - getShoppingCartInfo - Fail ====================");
      _shoppingCardSubject.addError(err);
    });
  }


  Stream<List<Product>> getProductList() {
    return Stream<List<Product>>.fromFuture(_productRepo.getProductList());
  }

}