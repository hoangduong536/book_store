
import 'dart:async';
import 'package:book_store/shared/model/rest_error.dart';
import 'package:dio/dio.dart';
import 'package:book_store/data/remote/user_service.dart';
import 'package:book_store/data/spref/spref.dart';
import 'package:book_store/shared/constant.dart';
import 'package:book_store/shared/model/user_data.dart';
import 'package:flutter/widgets.dart';

class UserRepo {
  UserService _userService;

  UserRepo({@required UserService userService}) : _userService = userService;

  Future<UserData> signIn(String phone, String pass) async {

    var c = Completer<UserData>();
    try {
      var response = await _userService.signIn(phone, pass);
      var userData = UserData.fromJson(response.data['data']);
      if (userData != null) {
        SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token);
        c.complete(userData);
      }
    } on DioError catch(e){
      print("UserRepo Dio Err: " + e.toString());
      print("UserRepo Dio data Err: " + e.response.data.toString());
      RestError error = RestError.fromJson(e.response.data);
      c.completeError(error);
    }

    return c.future;
  }

  Future<UserData> signUp(String displayName, String phone, String pass) async {
    var c = Completer<UserData>();
    try {
      var response = await _userService.signUp(displayName, phone, pass);
      var userData = UserData.fromJson(response.data['data']);
      if (userData != null) {
        SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token);
        c.complete(userData);
      }
    } on DioError catch(e) {
      print("UserRepo Sign Up Dio Err: " + e.toString());
      RestError error = RestError.fromJson(e.response.data);
      c.completeError(error);
    }

    return c.future;
  }
}