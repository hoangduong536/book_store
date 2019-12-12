import 'package:badges/badges.dart';
import 'package:book_store/base/base_widget.dart';
import 'package:book_store/data/remote/order_service.dart';
import 'package:book_store/data/remote/product_service.dart';
import 'package:book_store/data/repo/order_repo.dart';
import 'package:book_store/data/repo/product_repo.dart';
import 'package:book_store/event/home/add_to_cart_event.dart';
import 'package:book_store/module/sign_in/sign_in_page.dart';
import 'package:book_store/shared/app_color.dart';
import 'package:book_store/shared/identifier.dart';
import 'package:book_store/shared/model/product.dart';
import 'package:book_store/shared/model/rest_error.dart';
import 'package:book_store/shared/model/shopping_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'card_widget.dart';
import 'home_bloc.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Home Page',
      di: [
        Provider.value(value: ProductService()),
        Provider.value(value: OrderService()),

        ProxyProvider<ProductService,ProductRepo>(
          builder: (context,productService,previous)
          => ProductRepo(productService: productService),
        ),

        ProxyProvider<OrderService,OrderRepo>(
          builder: (context,orderService,previous)
          => OrderRepo(orderService: orderService),
        ),
      ],
      bloc: [],
      actions: <Widget>[
        Logout(),
        ShoppingCartWidget(),
      ],

      child: ProductListWidget(),
    );
  }
}


class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => SignInPage()),
          ModalRoute.withName(Identifier.SIGN_IN_PAGE),
        );

        print("Log out Tap...");
      },
      child: Container(

        margin:EdgeInsets.only(right: 15),
        child: Icon(
          Icons.exit_to_app
        ),
      ),
    );
  }
}



class ShoppingCartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<HomeBloc>.value(
      value:  HomeBloc.getInstance(productRepo: Provider.of(context),
          orderRepo: Provider.of(context)),
      child: CartWidget(),
    );
  }
}

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

    print("HomePage - CartWidget - didChangeDependencies ====================");

    var bloc = Provider.of<HomeBloc>(context);
    bloc.getShoppingCartInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("HomePage - CartWidget - dispose ====================");
    var bloc = Provider.of<HomeBloc>(context);
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("HomePage - CartWidget - build ====================");
    return Consumer<HomeBloc>(
      builder: (context,bloc,child)
      => StreamProvider<dynamic>.value(
        value: bloc.shoppingCartStream,
        initialData: null,
        catchError: (context,err) {
          return err;
        },
        child: Consumer<dynamic>(

          builder: (context,data,child) {

          if(data == null || data is RestError) {
            return Container(
              margin: EdgeInsets.only(top: 15,right: 20),
              child: Icon(Icons.shopping_cart),
            );
          }
          var cart = data as ShoppingCart;
          return GestureDetector(
            onTap: (){
              if(data == null) {
                return;
              }
              Navigator.pushNamed(context, Identifier.CHECK_OUT_PAGE,
                    arguments: cart.orderId);
              print("Badge Tap...");
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
          );}
        ),
      ),
    );
  }
}






//class ProductListWidget extends StatefulWidget {
//  @override
//  _ProductListWidgetState createState() => _ProductListWidgetState();
//}

class ProductListWidget extends StatelessWidget {

  final images = [
    'https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/p/o/pokemon_cuoc-phieu-luu-cua-pippi_tap-4.jpg',
    'https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/n/a/naruto-tap-23.jpg',
    'https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/i/m/image_81032.jpg',
    'https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/m/i/mien-dat-hua-3_bia-1_black_2.jpg',
    'https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/8/9/8935251401165.jpg',
    'https://cdn0.fahasa.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/n/x/nxbtre_full_10352018_093557.jpg',
  ];


  @override
  Widget build(BuildContext context) {
    print("HomePage - ProductListWidget - build ====================");
    return Provider<HomeBloc>.value(
      value: HomeBloc.getInstance(productRepo: Provider.of(context),
          orderRepo: Provider.of(context)),
      child: Consumer<HomeBloc>(
        builder: (context,bloc,child)
        => Container(
          child: StreamProvider<dynamic>.value(
            value: bloc.getProductList(),
            initialData: null,

            catchError: (context,err) {
              return err;
            },

            child: Consumer<dynamic>(
              builder: (context,data,child) {
              if (data == null) {

                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: AppColor.yellow,
                  ),
                );

              }

              if(data is RestError) {
                return Center(
                  child: Container(
                    child: Text(
                      data.message,style: TextStyle(fontSize: 20),
                    ),
                  ),
                );
              }

              data = data as List<Product>;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context,index) => _buildRow(data[index],bloc)
                );
              }





            ),
          )
        ),
      ),
    );
  }

  Widget _buildRow(Product product,HomeBloc bloc) {
   // var size = MediaQuery.of(context).size;
    return Container(
      height: 180,

      child: Card(

        elevation: 3.0,
        child: Container(
          padding: EdgeInsets.only(left: 15),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.productImage,
                  height: 150,
                  width: 150,
                  fit: BoxFit.scaleDown,
                ),
              ),

              // ========= EXPANDED =========
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    // ======= TITLE ========
                    Container(
                      margin:EdgeInsets.only(top: 15,left: 15),
                      child: Text(

                        product.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 22,color: Colors.black),
                      ),
                    ),

                    // ======= COUNT ========
                    Container(
                      margin:EdgeInsets.only(top: 5,left: 15),
                      child: Text(
                        '${product.quantity}',
                        style: TextStyle(fontSize: 17,color: Colors.blue),
                      ),
                    ),

                    // ========= EXPANDED =========
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          // ======= PRICE ========
                          Container(

                            margin:EdgeInsets.only(top: 5,left: 15),
                            child: Text(
                                '${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                                  symbol: 'vnđ',
                                  fractionDigits: 0,
                                ), amount: product.price).output.symbolOnRight}',
                              style: TextStyle(fontSize: 17,color: Colors.red,fontWeight: FontWeight.bold),
                            ),
                          ),

                          // ======= COUNT ========
                          Container(
                            margin:EdgeInsets.only(right: 15),
                            child: FlatButton(
                              padding: EdgeInsets.all(10),
                              color: AppColor.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(4),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)

                                )
                              ),
                              onPressed: () {
                                bloc.event.add(AddToCartEvent(product));

                              },
                              child: Text(
                                'Mua ngay',
                                style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.bold),
                              ),

                            ),
                          ),


                        ],
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),

        ),
      ),
    );

  }
}


