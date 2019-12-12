
import 'package:book_store/base/base_event.dart';
import 'package:book_store/base/base_widget.dart';
import 'package:book_store/data/remote/order_service.dart';
import 'package:book_store/data/repo/order_repo.dart';
import 'package:book_store/event/check_out/confirm_order_event.dart';
import 'package:book_store/event/check_out/update_cart_event.dart';
import 'package:book_store/event/utils/pop_event.dart';
import 'package:book_store/shared/app_color.dart';
import 'package:book_store/shared/model/order.dart';
import 'package:book_store/shared/model/product.dart';
import 'package:book_store/shared/model/rest_error.dart';
import 'package:book_store/shared/widget/bloc_listener.dart';
import 'package:book_store/shared/widget/btn_cart_action.dart';
import 'package:book_store/shared/widget/normal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:provider/provider.dart';

import 'check_out_bloc.dart';


class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final String orderId = ModalRoute.of(context).settings.arguments;
    
    return PageContainer(
      
      
      title: "Check out",
      di: [
        Provider.value(value: orderId),
        Provider.value(value: OrderService()),

        ProxyProvider2<OrderService,String,OrderRepo>(
          builder: (context,orderServce,orderId,previous)=> OrderRepo(
              orderService: orderServce, orderId: orderId),
        )

      ],
      bloc: [],
      child: ShoppingCartContainer(),
    );
  }
}

class ShoppingCartContainer extends StatefulWidget {
  @override
  _ShoppingCartContainerState createState() => _ShoppingCartContainerState();
}

class _ShoppingCartContainerState extends State<ShoppingCartContainer> {

  void _handleEvent(BaseEvent event) {
    print("CheckoutPage - ShoppingCartContainer -StatefulWidget - _handleEvent ======================");
    if(event is ShouldPopEvent) {
      print("CheckoutPage - ShoppingCartContainer -StatefulWidget - ShouldPopEvent ======================");
      Navigator.pop(context);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("CheckoutPage - ShoppingCartContainer -StatefulWidget - InitState ======================");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("CheckoutPage - ShoppingCartContainer -StatefulWidget - DidChangeDependencies ======================");

  }

  @override
  void didUpdateWidget(ShoppingCartContainer oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("CheckoutPage -  ShoppingCartContainer -StatefulWidget - DidUpdateWidget ======================");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    var bloc = Provider.of<SignInBloc>(context);
//    bloc.dispose();
    print("CheckoutPage - ShoppingCartContainer -StatefulWidget - Dispose ======================");
  }


  @override
  Widget build(BuildContext context) {
    return Provider<CheckoutBloc>.value(
      value: CheckoutBloc(
        orderRepo: Provider.of(context)
      ),
      child: Consumer<CheckoutBloc>(
        builder: (context,bloc,child) {
          return BlocListener<CheckoutBloc>(
              listener: _handleEvent,
              child: ShoppingCart(bloc),
          );
        }

      ),
    );
  }
}

class ShoppingCart extends StatefulWidget {

  final CheckoutBloc bloc;

  ShoppingCart(this.bloc);


  @override
  _ShoppingCartState createState() => _ShoppingCartState();




}



class _ShoppingCartState extends State<ShoppingCart> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("CheckoutPage - _ShoppingCartState  -ShoppingCart - initState ====================");
    widget.bloc.getOderDetail();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("CheckoutPage - _ShoppingCartState -ShoppingCart - didChangeDependencies ====================");

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("CheckoutPage - _ShoppingCartState -ShoppingCart - dispose ====================");
  }

  @override
  Widget build(BuildContext context) {
    print("CheckoutPage - _ShoppingCartState -ShoppingCart - build ====================");
    return StreamProvider<dynamic>.value(
      value: widget.bloc.orderStream,
      initialData: null,

      catchError: (context,err) {
        return err;
      },

      child: Consumer<dynamic>(
      builder:(context,data,child) {

        if(data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if(data is RestError){
          return Center(
            child: Container(
              child: Text(data.message),
            ),
          );
        }


        var order = data ;
        if(order is Order) {
          return Column(
            children: <Widget>[

              Expanded(child: ProductListWidget(order.items)),
              ConfirmInfoWidget(order.total),

            ],
          );
        }
        return Container();

      }

      ),
    );
  }
}


class ConfirmInfoWidget extends StatelessWidget {

  final double total;
  ConfirmInfoWidget (this.total);
  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutBloc>(
      builder: (context,bloc,child)
      => Container(
        height: 150,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Container(
              child: Text(
                'Tổng: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                  symbol: 'vnđ',
                  fractionDigits: 0,
                ), amount: total).output.symbolOnRight}',
                maxLines: 2,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              ),
            ),

            SizedBox(
              height: 20.0,
            ),
            NormalButton(
              title: 'Confirm',
              onPressed: () {
                bloc.event.add(ConfirmOrderEvent());
              },
            ),
          ],
        ),
      ),
    );
  }
}


class ProductListWidget extends StatelessWidget {

  final List<Product> productList;
  ProductListWidget(this.productList);

  final images = [
    'https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/p/o/pokemon_cuoc-phieu-luu-cua-pippi_tap-4.jpg',
    'https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/n/a/naruto-tap-23.jpg',
    'https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/i/m/image_81032.jpg',
    'https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/p/o/pokemon_cuoc-phieu-luu-cua-pippi_tap-4.jpg',
    'https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/n/a/naruto-tap-23.jpg',
    'https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/i/m/image_81032.jpg',

  ];


  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CheckoutBloc>(context);
    productList.sort((p1,p2) => p1.price.compareTo(p2.price));
    return ListView.builder(
        itemBuilder: (context,index) => _buildRow(productList[index],bloc) ,
      itemCount: productList.length,
    );
  }

  Widget _buildRow(Product product,CheckoutBloc bloc) {
    return Container(

      child: Card(
        elevation: 3.0,
        child: Padding(
          padding:  EdgeInsets.all(12.0),
          child: Container(
            child: Row(

              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    product.productImage,
                    width: 150,
                    height: 150,
                    fit: BoxFit.scaleDown,
                  ),
                ),



                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(

                        child: Text(
                          product.productName,
                          maxLines: 2,

                          style: TextStyle(
                            fontSize: 15.0,
                            height: 1.2,
                            fontWeight: FontWeight.w600,
                            color: Colors.black
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        child: Text(
                          'Giá: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                            symbol: 'vnđ',
                            fractionDigits: 0,
                          ), amount: product.price).output.symbolOnRight}',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 15,
                      ),

                      _buildCartAction(product,bloc),
                    ],
                  ),
                )



              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartAction(Product product, CheckoutBloc bloc) {
    return Row(
      children: <Widget>[
        BtnCartAction(
          title: "-",
          onPressed: (){
            print("_buildCartAction [-] ==========");
            if(product.quantity == 1) {
              return;
            }
            product.quantity = product.quantity - 1;
            bloc.event.add(UpdateCartEvent(product));
          },
        ),
        SizedBox(
          width: 15,
        ),

        Container(
          child: Text('${product.quantity}',
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
        ),

        SizedBox(
          width: 15,
        ),
        BtnCartAction(
            onPressed: (){
              print("_buildCartAction [+] ==========");
              product.quantity = product.quantity + 1;
              bloc.event.add(UpdateCartEvent(product));
            },
            title: "+")
      ],
    );
  }
}


