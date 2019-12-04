
import 'dart:async';

import 'package:book_store/data/repo/user_repo.dart';
import 'package:book_store/base/base_bloc.dart';
import 'package:book_store/base/base_event.dart';
import 'package:book_store/event/sign_in/sign_in_event.dart';
import 'package:book_store/event/sign_in/sign_in_fail_event.dart';
import 'package:book_store/event/sign_in/sign_in_sucess_event.dart';
import 'package:book_store/shared/validation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc extends BaseBloc {

  UserRepo _userRepo;
  final _phoneSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  Stream<String> get phoneStream => _phoneSubject.stream.transform(phoneValidation);
  Stream<String> get passStream => _passSubject.stream.transform(passValidation);
  Stream<bool> get btnStream => _btnSubject.stream;

  // Push Event to Stream
  Sink<String> get phoneSink => _phoneSubject.sink;
  Sink<String> get passSink => _passSubject.sink;
  Sink<bool> get btnSink => _btnSubject.sink;

  SignInBloc({@required UserRepo userRepo}) {
    _userRepo = userRepo;
    validateForm();
  }

  //StreamTransformer:xử lý dữ liệu đầu vào
  //StreamTransformer<1//input,2//output>:nhận vào input transform return output
  //
  var phoneValidation = StreamTransformer<String,String>.fromHandlers(handleData: (phone,sink){

    print("SignInBloc - phoneValidation: =========================" );
    //sau khi transform 'phone' xong => thì dùng 'sink' đẩy ra ngoài
    if(Validation.isPhoneValid(phone)) {
      print("SignInBloc - phoneValidation null: =========================" );
      sink.add(null);
      return;
    }
    print("SignInBloc - phoneValidation Phone inValid: =========================" );
    sink.add("Phone inValid");
  });

  var passValidation = StreamTransformer<String,String>.fromHandlers(handleData: (pass,sink){

    print("SignInBloc - passValidation: =========================" );
    //sau khi transform 'pass' xong => thì dùng 'sink' đẩy ra ngoài
    if(Validation.isPassValid(pass)) {
      print("SignInBloc - passValidation null: =========================" );
      sink.add(null);
      return;
    }
    print("SignInBloc - passValidation Pass too short: =========================" );
    sink.add("Pass too short");
  });

  // combineLatest2 callback nhan dc 2 thong tu _phoneSubject,_passSubject đẳy ra
  validateForm() {
    Observable.combineLatest2(
      _phoneSubject,
      _passSubject,
          (phone, pass) {
        print("SignInBloc - validateForm: " + phone + " === " + pass);
        return Validation.isPhoneValid(phone) && Validation.isPassValid(pass);
      },
    ).listen((enable) {
      print("SignInBloc - validateForm - listen: " + enable.toString() + " === " );
      btnSink.add(enable);
    });
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

    btnSink.add(false); // Khi bắt đầu call API thì disable nút sign-in
    loadingSink.add(true);//Show Loading


    Future.delayed(Duration(seconds: 6), () {
      _userRepo.signIn(signInEvent.phone, signInEvent.pass).then(
              (userData) {
            //sign in success

            btnSink.add(false);
            loadingSink.add(true);
            print("_handleSignIn: " + userData.displayName);
            processEventSink.add(SignInSuccessEvent(userData));

          },
          onError: (error){
            ////sign in fail
            print("_handleSignIn error: " + error.toString());
            processEventSink.add(SignInFailEvent(error.toString()));

            btnSink.add(false);
            loadingSink.add(true);

          }
      );

    });



  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _phoneSubject.close();
    _passSubject.close();
    _btnSubject.close();
  }

}