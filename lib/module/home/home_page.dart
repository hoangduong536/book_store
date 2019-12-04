import 'package:book_store/base/base_widget.dart';
import 'package:flutter/material.dart';

import 'card_widget.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: '',
      di: [],
      actions: <Widget>[
        CartWidget(),
      ],
      child:ProductListWidget() ,
      
    );
  }
}

class ProductListWidget extends StatefulWidget {
  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


