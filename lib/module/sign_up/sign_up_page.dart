import 'package:book_store/base/base_event.dart';
import 'package:book_store/base/base_widget.dart';
import 'package:book_store/data/remote/user_service.dart';
import 'package:book_store/data/repo/user_repo.dart';
import 'package:book_store/event/sign_up/sign_up_event.dart';
import 'package:book_store/event/sign_up/sign_up_fail_event.dart';
import 'package:book_store/event/sign_up/sign_up_sucess_event.dart';
import 'package:book_store/module/home/home_page.dart';
import 'package:book_store/module/sign_up/sign_up_bloc.dart';
import 'package:book_store/shared/app_color.dart';
import 'package:book_store/shared/identifier.dart';
import 'package:book_store/shared/style/txt_style.dart';
import 'package:book_store/shared/widget/bloc_listener.dart';
import 'package:book_store/shared/widget/loading_task.dart';
import 'package:book_store/shared/widget/normal_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      title: 'Sign Up',
      di: [
        Provider.value(value: UserService()),
        ProxyProvider<UserService,UserRepo>(
          builder: (context,userService,previous)=> UserRepo(userService: userService),
        ),
      ],
      bloc: [],
      child: _SignUpFormWidget(),
    );
  }
}

class _SignUpFormWidget extends StatefulWidget {

  @override
  __SignUpFormWidgetState createState() => __SignUpFormWidgetState();
}

class __SignUpFormWidgetState extends State<_SignUpFormWidget> {

  final TextEditingController _txtDisplayNameController = TextEditingController();
  final TextEditingController _txtPhoneController = TextEditingController();
  final TextEditingController _txtPassController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("SignUpPage - StatefulWidget - InitState ======================");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("SignUpPage - StatefulWidget - DidChangeDependencies ======================");

  }

  @override
  void didUpdateWidget(_SignUpFormWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("SignUpPage - StatefulWidget - DidUpdateWidget ======================");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("SignUpPage - StatefulWidget - Dispose ======================");
  }


  handleEvent(BaseEvent event) {
    if (event is SignUpSuccessEvent) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomePage()),
        ModalRoute.withName(Identifier.HOME_PAGE),
      );
      return;
    }

    if (event is SignUpFailEvent) {
      final snackBar = SnackBar(
        content: Text(event.errMessage),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override


  @override
  Widget build(BuildContext context) {
    print("SignUpPage - StatefulWidget - build ======================");
    return Provider<SignUpBloc>.value(
      value: SignUpBloc(userRepo: Provider.of(context)),
      child: Consumer<SignUpBloc>(
        builder: (context, bloc, child) => BlocListener<SignUpBloc>(
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
                      _buildDisplayNameField(bloc),
                      _buildPhoneField(bloc),
                      _buildPassField(bloc),
                      _buildSignUpButton(bloc),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildDisplayNameField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.displayNameStream,
      child: Consumer<String>(
        builder: (context, msg, child) => Container(
          margin: EdgeInsets.only(bottom: 25),
          child: TextField(
            controller: _txtDisplayNameController,
            onChanged: (text) {
              bloc.displayNameSink.add(text);
            },
            cursorColor: Colors.black,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: Icon(
                Icons.account_box,
                color: AppColor.blue,
              ),
              hintText: 'Display name',
              errorText: msg,
              labelText: 'Display name',
              labelStyle: TextStyle(color: AppColor.blue),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField(SignUpBloc bloc) {
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

  Widget _buildPassField(SignUpBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.passStream,
      child: Consumer<String>(
        builder: (context, msg, child) => Container(
          margin: EdgeInsets.only(bottom: 25),
          child: TextField(
            controller: _txtPassController,
            onChanged: (text) {
              bloc.passSink.add(text);
            },
            obscureText: true,
            cursorColor: Colors.black,
            keyboardType: TextInputType.text,
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

  Widget _buildSignUpButton(SignUpBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: true,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context, enable, child) => NormalButton(
          title: 'Sign up',
          onPressed: enable
              ? () {
            bloc.event.add(
              SignUpEvent(
                displayName: _txtDisplayNameController.text,
                phone: _txtPhoneController.text,
                pass: _txtPassController.text,
              ),
            );
          }
              : null,
        ),
      ),
    );
  }


}

