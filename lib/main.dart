import 'package:book_store/module/sign_in/sign_in_page.dart';
import 'package:book_store/shared/app_color.dart';
import 'package:book_store/shared/identifier.dart';
import 'package:flutter/material.dart';



import 'module/sign_up/sign_up_page.dart';
import 'module/splash/splash.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Store',
      theme: ThemeData(
        primarySwatch: AppColor.yellow,
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => SplashPage(),
        Identifier.SIGN_IN_PAGE: (context) => SignInPage(),
        Identifier.SIGN_UP_PAGE: (context) => SignUpPage(),
      },
    );
  }
}


