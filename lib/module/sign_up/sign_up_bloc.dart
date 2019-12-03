
import 'dart:async';

import 'package:book_store/data/repo/user_repo.dart';
import 'package:book_store/base/base_bloc.dart';
import 'package:book_store/base/base_event.dart';
import 'package:book_store/event/sign_in/sign_in_event.dart';
import 'package:book_store/event/sign_up/sign_up_event.dart';
import 'package:book_store/event/sign_up/sign_up_fail_event.dart';
import 'package:book_store/event/sign_up/sign_up_sucess_event.dart';
import 'package:book_store/shared/validation.dart';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends BaseBloc {

  UserRepo _userRepo;
  final _displayNameSubject = BehaviorSubject<String>();
  final _phoneSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  Stream<String> get displayNameStream => _displayNameSubject.stream.transform(displayNameValidation);
  Stream<String> get phoneStream => _phoneSubject.stream.transform(phoneValidation);
  Stream<String> get passStream => _passSubject.stream.transform(passValidation);
  Stream<bool> get btnStream => _btnSubject.stream;

  // Push Event to Stream
  Sink<String> get displayNameSink => _displayNameSubject.sink;
  Sink<String> get phoneSink => _phoneSubject.sink;
  Sink<String> get passSink => _passSubject.sink;
  Sink<bool> get btnSink => _btnSubject.sink;

  SignUpBloc({@required UserRepo userRepo}) {
    _userRepo = userRepo;
    validateForm();
  }

  //StreamTransformer:xử lý dữ liệu đầu vào
  //StreamTransformer<1//input,2//output>:nhận vào input transform return output
  //
  var phoneValidation = StreamTransformer<String,String>.fromHandlers(handleData: (phone,sink){

    print("SignUpBloc - phoneValidation: =========================" );
    //sau khi transform 'phone' xong => thì dùng 'sink' đẩy ra ngoài
    if(Validation.isPhoneValid(phone)) {
      print("SignUpBloc - phoneValidation null: =========================" );
      sink.add(null);
      return;
    }
    print("SignUpBloc - phoneValidation Phone inValid: =========================" );
    sink.add("Phone inValid");
  });

  var passValidation = StreamTransformer<String,String>.fromHandlers(handleData: (pass,sink){

    print("SignUpBloc - passValidation: =========================" );
    //sau khi transform 'pass' xong => thì dùng 'sink' đẩy ra ngoài
    if(Validation.isPassValid(pass)) {
      print("SignInBloc - passValidation null: =========================" );
      sink.add(null);
      return;
    }
    print("SignUpBloc - passValidation Pass too short: =========================" );
    sink.add("Pass too short");
  });

  var displayNameValidation = StreamTransformer<String, String>.fromHandlers(
      handleData: (displayName, sink) {
        if (Validation.isDisplayNameValid(displayName)) {
          sink.add(null);
          return;
        }
        sink.add('Display name too short');
      });

  // combineLatest2 callback nhan dc 2 thong tu _phoneSubject,_passSubject đẳy ra
  validateForm() {
    Observable.combineLatest2(
      _phoneSubject,
      _passSubject,
          (phone, pass) {
        print("SignUpBloc - validateForm: " + phone + " === " + pass);
        return Validation.isPhoneValid(phone) && Validation.isPassValid(pass);
      },
    ).listen((enable) {
      print("SignUpBloc - validateForm - listen: " + enable.toString() + " === " );
      btnSink.add(enable);
    });
  }

  void dispatchEvent(BaseEvent event) {
    // TODO: implement dispatchEvent
    switch(event.runtimeType) {
      case SignUpEvent:
        _handleSignUp(event);
        break;
    }
  }

  void _handleSignUp(BaseEvent event) {
    SignUpEvent signUpEvent = event as SignUpEvent;
    print("Name: ${signUpEvent.displayName}  ==== Phone: ${signUpEvent.phone}  ====  Pass: ${signUpEvent.pass}");


    btnSink.add(false); // Khi bắt đầu call API thì disable nút sign-in
    loadingSink.add(true);//Show Loading

    _userRepo.signUp(signUpEvent.displayName,signUpEvent.phone, signUpEvent.pass).then(
            (userData) {
          //sign in success
              print("_handleSignUp: " + userData.displayName);
              processEventSink.add(SignUpSuccessEvent(userData));
        },
        onError: (error){
          ////sign in fail
          print("_handleSignUp error: " + error.toString());
          processEventSink.add(SignUpFailEvent(error.toString()));

        },

    );

    btnSink.add(false);
    loadingSink.add(true);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _displayNameSubject.close();
    _phoneSubject.close();
    _passSubject.close();
    _btnSubject.close();
  }

}