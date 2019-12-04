import 'package:book_store/base/base_event.dart';
import 'package:book_store/base/base_widget.dart';
import 'package:book_store/data/remote/user_service.dart';
import 'package:book_store/data/repo/user_repo.dart';
import 'package:book_store/event/sign_in/sign_in_event.dart';
import 'package:book_store/event/sign_in/sign_in_fail_event.dart';
import 'package:book_store/event/sign_in/sign_in_sucess_event.dart';
import 'package:book_store/event/sign_up/sign_up_fail_event.dart';
import 'package:book_store/event/sign_up/sign_up_sucess_event.dart';
import 'package:book_store/module/sign_in/sign_in_bloc.dart';
import 'package:book_store/shared/app_color.dart';
import 'package:book_store/shared/identifier.dart';
import 'package:book_store/shared/style/txt_style.dart';
import 'package:book_store/shared/widget/bloc_listener.dart';
import 'package:book_store/shared/widget/loading_task.dart';
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


  handleEvent(BaseEvent event)
  {
    if (event is SignInSuccessEvent) {
//      Navigator.pushAndRemoveUntil(
//        context,
//        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
//        ModalRoute.withName('/home'),
//      );
      print("SignInPage - handleEvent - SignUpSuccessEvent ================");
      Navigator.pushNamed(context, Identifier.SIGN_UP_PAGE);
      return;
    }

    if (event is SignInFailEvent) {
      print("SignInPage - handleEvent - SignUpFailEvent ================");
      final snackBar = SnackBar(
        content: Text(event.errMessage),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Provider<SignInBloc>.value(
      value: SignInBloc(userRepo: Provider.of(context)),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, child) {
          return BlocListener<SignInBloc>(
            listener: handleEvent,
            child: LoadingTask(
              bloc: bloc,
              child: Container(
                padding: EdgeInsets.all(25),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildPhoneField(bloc),
                        _buildPassField(bloc),
                        _buildSignInButton(bloc),
                        _buildFooter(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),//end LoadingTask

          );
        },
      ),
    );
  }


  Widget _buildPhoneField(SignInBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.phoneStream,
      child: Consumer<String>(
        builder: (context,msg,child) =>
        Container(

          margin: EdgeInsets.only(bottom: 15),
          child: TextField(
            controller: _txtPhoneController,
            onChanged: (text){
              print("_buildPhoneField: " + text + " ====================" + msg.toString()) ;
              bloc.phoneSink.add(text);

            } ,
            cursorColor: Colors.black,

            decoration: InputDecoration(
              icon: Icon(
                Icons.phone,
                color: AppColor.blue,
              ),
              hintText: '(+84) 973 901 789',
              errorText: msg,
              labelText: 'Phone',
              labelStyle: TextStyle(color: AppColor.blue),
            ),
          ),

        ),
      ),
    );
  }

  Widget _buildPassField(SignInBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.passStream,
      child: Consumer<String>(
        builder: (context,msg,child) =>
        Container(

          margin: EdgeInsets.only(bottom: 25),
          child: TextField(
            controller: _txtPassController,
            onChanged: (text){
              print("_buildPassField: " + text + " ====================" + msg.toString()) ;
              bloc.passSink.add(text);
            },
            cursorColor: Colors.black,

            decoration: InputDecoration(
              icon: Icon(
                Icons.lock,
                color: AppColor.blue,
              ),
              hintText: 'Password',
              errorText: msg,
              labelText: 'Password',
              labelStyle: TextStyle(color: AppColor.blue),
            ),
          ),

        ),
      ),
    );
  }

  Widget _buildSignInButton(SignInBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context,enable,child)=>
         Container(
          child: NormalButton(
            title: "Sign In",
            onPressed: enable ? () {
              print("_buildSignInButton onPressed: ==============="  );
              bloc.event.add( SignInEvent(phone: _txtPhoneController.text,pass: _txtPassController.text));

            }
            : null,
          ),

        ),
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

