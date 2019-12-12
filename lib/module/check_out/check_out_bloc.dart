

import 'package:book_store/base/base_bloc.dart';
import 'package:book_store/base/base_event.dart';
import 'package:book_store/data/repo/order_repo.dart';
import 'package:book_store/event/check_out/confirm_order_event.dart';
import 'package:book_store/event/check_out/update_cart_event.dart';
import 'package:book_store/event/utils/pop_event.dart';
import 'package:book_store/shared/model/order.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class CheckoutBloc extends BaseBloc {

  final OrderRepo _orderRepo;
  final _orderSubject = BehaviorSubject<Order>();
  Stream<Order> get orderStream => _orderSubject.stream;
  Sink<Order> get orderSink => _orderSubject.sink;


  CheckoutBloc({
    @required OrderRepo orderRepo,
  }) : _orderRepo = orderRepo;



  @override
  void dispatchEvent(BaseEvent event) {
    // TODO: implement dispatchEvent
    switch(event.runtimeType) {
      case ConfirmOrderEvent:
        _handleConfirmOrder(event);
        break;
      case UpdateCartEvent:
        _handleUpdateCart(event);
        break;

    }
  }

  void getOderDetail() {
    Stream<Order>.fromFuture(_orderRepo.getOrderDetail(),).listen((order){
      orderSink.add(order);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _orderSubject.close();
  }

  void _handleConfirmOrder(BaseEvent event) {
    _orderRepo.confirmOrder().then((isSuccess){
      processEventSink.add(ShouldPopEvent());
    });
  }

  void _handleUpdateCart(BaseEvent event) {

    UpdateCartEvent e = event as UpdateCartEvent;
    Observable.fromFuture((_orderRepo.updateOrder(e.product)))
        .flatMap(( _ ) => Observable.fromFuture(_orderRepo.getOrderDetail()))
        .listen((order){
          orderSink.add(order);
    });

  }

}