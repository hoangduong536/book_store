import 'package:book_store/shared/style/btn_style.dart';
import 'package:flutter/material.dart';

import '../app_color.dart';


class NormalButton extends StatelessWidget {

  final VoidCallback onPressed;
  final String title;

  NormalButton({@required this.onPressed,@required this.title});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,
      height: 45,
      child: RaisedButton(
          onPressed: onPressed,
          color: AppColor.yellow,
          disabledColor: Colors.yellow,
          shape: RoundedRectangleBorder(

            borderRadius: new BorderRadius.circular(4.0)
          ),
          child:Text(
            title,style: BtnStyle.normal(),
          ) ,
      ),
    );
  }
}



