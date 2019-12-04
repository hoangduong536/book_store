
import 'package:badges/badges.dart';
import 'package:book_store/shared/identifier.dart';
import 'package:book_store/shared/model/rest_error.dart';
import 'package:book_store/shared/model/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

//    var bloc = Provider.of<HomeBloc>(context);
//    bloc.getShoppingCartInfo();
  }

  @override
//  Widget build(BuildContext context) {
//    return Consumer<HomeBloc>(
//      builder: (context, bloc, child) => StreamProvider<dynamic>.value(
//        value: bloc.shoppingCartStream,
//        initialData: null,
//        catchError: (context, error) {
//          return error;
//        },
//        child: Consumer<dynamic>(
//          builder: (context, data, child) {
//            if (data == null || data is RestError) {
//              return Container(
//                margin: EdgeInsets.only(top: 15, right: 20),
//                child: Icon(Icons.shopping_cart),
//              );
//            }
//
//            var cart = data as ShoppingCart;
//            return GestureDetector(
//              onTap: () {
//                if (data == null) {
//                  return;
//                }
//                Navigator.pushNamed(context, Identifier.CHECK_OUT_PAGE,
//                    arguments: cart.orderId);
//              },
//              child: Container(
//                margin: EdgeInsets.only(top: 15, right: 20),
//                child: Badge(
//                  badgeContent: Text(
//                    '${cart.total}',
//                    style: TextStyle(
//                      color: Colors.white,
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
//                  child: Icon(Icons.shopping_cart),
//                ),
//              ),
//            );
//          },
//        ),
//      ),
//    );
//  }


  Widget build(BuildContext context) {
    return Consumer<HomeBloc>(
      builder: (context, bloc, child) => StreamProvider<dynamic>.value(
        value: bloc.shoppingCartStream,
        initialData: null,
        catchError: (context, error) {
          return error;
        },
        child: Consumer<dynamic>(
          builder: (context, data, child) {
            if (data == null || data is RestError) {
              return Container(
                margin: EdgeInsets.only(top: 15, right: 20),
                child: Icon(Icons.shopping_cart),
              );
            }

            var cart = data as ShoppingCart;
            return GestureDetector(
              onTap: () {
                if (data == null) {
                  return;
                }
                Navigator.pushNamed(context, Identifier.CHECK_OUT_PAGE,
                    arguments: cart.orderId);
              },
              child: Container(
                margin: EdgeInsets.only(top: 15, right: 20),
                child: Badge(
                  badgeContent: Text(
                    '${cart.total}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Icon(Icons.shopping_cart),
                ),
              ),
            );
          },
        ),
      ),
    );//end  Consumer HomeBloc
  }
}