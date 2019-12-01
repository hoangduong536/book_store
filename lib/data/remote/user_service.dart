

import 'package:book_store/network/book_client.dart';
import 'package:book_store/shared/api_method_name.dart';
import 'package:dio/dio.dart';

class UserService {
  Future<Response> signIn(String phone,String pass) {
    return BookClient.instance.dio.post(
      APIMethodName.SIGN_IN,
      data: {
        'phone':phone,
        'password':pass,
      },
    );
  }


  Future<Response> signUp(String displayName, String phone, String pass) {
    return BookClient.instance.dio.post(
      APIMethodName.SIGN_UP,
      data: {
        'displayName': displayName,
        'phone': phone,
        'password': pass,
      },
    );
  }
}