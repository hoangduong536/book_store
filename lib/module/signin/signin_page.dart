import 'package:book_store/shared/app_color.dart';
import 'package:book_store/shared/identifier.dart';
import 'package:book_store/shared/style/txt_style.dart';
import 'package:book_store/shared/widget/normal_button.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _SignInFormWidget(),
    );
  }
}

class _SignInFormWidget extends StatefulWidget {

  @override
  __SignInFormWidgetState createState() => __SignInFormWidgetState();
}

class __SignInFormWidgetState extends State<_SignInFormWidget> {

  final TextEditingController txtPhoneController = TextEditingController();
  final TextEditingController _txtPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              _buildPhoneField(context),
              _buildPasseField(context),
              _buildSignInButton(context),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildPhoneField(BuildContext context) {
  return Container(

    margin: EdgeInsets.only(bottom: 15),
    child: TextField(
      cursorColor: Colors.black,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        icon: Icon(
          Icons.phone,
          color: AppColor.blue,
        ),
        hintText: '(+84) 973 901 789',
        labelText: 'Phone',
        labelStyle: TextStyle(color: AppColor.blue),
      ),
    ),

  );
}

Widget _buildPasseField(BuildContext context) {
  return Container(

    margin: EdgeInsets.only(bottom: 25),
    child: TextField(
      cursorColor: Colors.black,
      obscureText: true,
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          color: AppColor.blue,
        ),
        hintText: 'Password',
        labelText: 'Password',
        labelStyle: TextStyle(color: AppColor.blue),
      ),
    ),

  );
}

Widget _buildSignInButton(BuildContext context) {
  return Container(
    child: NormalButton(
      title: "Sign In",
      onPressed: () {

      },
    ),

  );
}

Widget _buildFooter(BuildContext context) {
  return Container(
    margin:EdgeInsets.only(top: 19) ,
    padding: EdgeInsets.all(10),
    child: FlatButton(
      onPressed: () {
        Navigator.pushNamed(context, Identifier.SIGN_UP_PAGE);
      },
      child: Text(
          'Đăng ký tài khoản',
        style: TxtStyle.normal_font_size_19(),
      ),

    ),

  );
}
