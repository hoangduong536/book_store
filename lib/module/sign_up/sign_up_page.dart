import 'package:book_store/shared/app_color.dart';
import 'package:book_store/shared/style/txt_style.dart';
import 'package:book_store/shared/widget/normal_button.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _SignUpFormWidget(),
    );
  }
}

class _SignUpFormWidget extends StatefulWidget {

  @override
  __SignUpFormWidgetState createState() => __SignUpFormWidgetState();
}

class __SignUpFormWidgetState extends State<_SignUpFormWidget> {

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
              _buildDisplayNameField(),
              _buildPhoneField(context),
              _buildPasseField(context),
              _buildSignInButton(context),

            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDisplayNameField() {

  return Container(
    margin: EdgeInsets.only(bottom: 25),
    child: TextField(
      cursorColor: Colors.black,
      decoration: InputDecoration(
        icon: Icon(
            Icons.account_box,
            color: AppColor.blue,
        ),
        hintText: 'Display name',
        labelText: 'Display name lable',
        labelStyle: TextStyle(color: AppColor.blue),
      ),
    ),


  );
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
      title: "Sign Up",
      onPressed: () {

      },
    ),

  );
}

