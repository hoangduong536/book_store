
import 'package:book_store/data/repo/user_repo.dart';
import 'package:book_store/base/base_bloc.dart';
import 'package:book_store/base/base_event.dart';
import 'package:book_store/event/sign_in/sign_in_event.dart';
import 'package:flutter/widgets.dart';

class SignInBloc extends BaseBloc {

  UserRepo _userRepo;

  SignInBloc({@required UserRepo userRepo}) {
    _userRepo = userRepo;
  }

  void dispatchEvent(BaseEvent event) {
    // TODO: implement dispatchEvent
    switch(event.runtimeType) {
      case SignInEvent:
        _handleSignIn(event);
        break;
    }
  }

  void _handleSignIn(BaseEvent event) {
    SignInEvent signInEvent = event as SignInEvent;
    print("Phone: ${signInEvent.phone}  ====  Pass: ${signInEvent.pass}");
    _userRepo.signIn(signInEvent.phone, signInEvent.pass).then(
        (userData) {
          print("_handleSignIn: " + userData.displayName);
          //sign in success
        },
        onError: (error){
          print("_handleSignIn error: " + error.toString());
          ////sign in fail
        }
    );

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}