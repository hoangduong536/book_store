import 'package:book_store/base/base_widget.dart';
import 'package:book_store/data/remote/user_service.dart';
import 'package:book_store/data/repo/user_repo.dart';
import 'package:book_store/event/sign_in/sign_in_event.dart';
import 'package:book_store/module/sign_in/sign_in_bloc.dart';
import 'package:book_store/shared/app_color.dart';
import 'package:book_store/shared/identifier.dart';
import 'package:book_store/shared/style/txt_style.dart';
import 'package:book_store/shared/widget/normal_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Sign In',
      di: [
        Provider.value(value: UserService()),
        ProxyProvider<UserService,UserRepo>(
          builder: (context,userService,previous)=> UserRepo(userService: userService),
        ),
      ],
      bloc: [],
      child: _SignInFormWidget(),
    );
  }
}

class _SignInFormWidget extends StatefulWidget {

  @override
  __SignInFormWidgetState createState() => __SignInFormWidgetState();
}

class __SignInFormWidgetState extends State<_SignInFormWidget> {

  final TextEditingController _txtPhoneController = TextEditingController();
  final TextEditingController _txtPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Provider<SignInBloc>.value(
      value: SignInBloc(userRepo: Provider.of(context)),
      child: Consumer<SignInBloc>(
        builder: (context,bloc,child) =>
        Container(

            padding: EdgeInsets.all(25),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  _buildPhoneField(),
                  _buildPassField(),
                  _buildSignInButton(bloc),
                  _buildFooter(context),
                ],
              ),
            ),

        ),
      )
    );
  }


  Widget _buildPhoneField() {
    return Container(

      margin: EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: _txtPhoneController,
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

  Widget _buildPassField() {
    return Container(

      margin: EdgeInsets.only(bottom: 25),
      child: TextField(
        controller: _txtPassController,
        cursorColor: Colors.black,

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

  Widget _buildSignInButton(SignInBloc bloc) {
    return Container(
      child: NormalButton(
        title: "Sign In",
        onPressed: () {
          bloc.event.add( SignInEvent(phone: _txtPhoneController.text,pass: _txtPassController.text));

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
}

