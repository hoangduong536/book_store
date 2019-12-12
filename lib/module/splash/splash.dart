import 'package:book_store/data/spref/spref.dart';
import 'package:book_store/shared/constant.dart';
import 'package:book_store/shared/identifier.dart';
import 'package:book_store/shared/image_asset.dart';
import 'package:flutter/material.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _startApp();
  }

  _startApp() {
    Future.delayed(
        Duration(seconds: 3),
        () async {
          var token = await SPref.instance.get(SPrefCache.KEY_TOKEN);
          print("SplashPage - _startApp toeken:");
          if(token != null) {
            // Go to home page
            print("SplashPage - _startApp toeken2: " + token);
            Navigator.pushReplacementNamed(context, Identifier.HOME_PAGE);
            return;
          }
          Navigator.pushReplacementNamed(context, Identifier.SIGN_IN_PAGE);
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              ImageAsset.logo_book,
              height: 200,
              width: 200,
            ),

            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                'Book Store',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.brown[600],
                ),
              ),

            )

          ],
        ),
      ),

    );
  }
}

