import 'package:book_store/base/base_widget.dart';
import 'package:book_store/shared/app_color.dart';
import 'package:flutter/material.dart';

import 'card_widget.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Home Page',
      di: [],
      bloc: [],
      actions: <Widget>[
        CartWidget(),
      ],

      child: ProductListWidget(),
    );
  }
}

class ProductListWidget extends StatefulWidget {
  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {

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
    return Container(
      child: ListView.builder(
          itemCount: images.length,
          itemBuilder: (context,index) => _buildRow(images[index],index) ,
      )
    );
  }

  Widget _buildRow(String imageUrl,int index) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: 180,

      child: Card(

        elevation: 3.0,
        child: Container(
          padding: EdgeInsets.only(left: 15),

          child: Row(

            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
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
                        'Học tiếng anh cùng Pokemon',
                        style: TextStyle(fontSize: 22,color: Colors.black),
                      ),
                    ),

                    // ======= COUNT ========
                    Container(
                      margin:EdgeInsets.only(top: 5,left: 15),
                      child: Text(
                        '30 cuốn',
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
                              '100.000 vnd',
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
                                print("By now...." + index.toString());
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


