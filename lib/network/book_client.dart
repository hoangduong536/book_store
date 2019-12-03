


import 'package:book_store/shared/api_method_name.dart';
import 'package:dio/dio.dart';
import 'package:book_store/data/spref/spref.dart';
import 'package:book_store/shared/constant.dart';

class BookClient {
  static BaseOptions _options = new BaseOptions(
    baseUrl:APIMethodName.BASE_URL,
    connectTimeout: 5000,
    receiveTimeout: 3000,

  );
  static Dio _dio = Dio(_options);

  BookClient._internal() {
   // _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (Options myOption) async {
      var token = await SPref.instance.get(SPrefCache.KEY_TOKEN);
      if (token != null) {
        myOption.headers["Authorization"] = "Bearer " + token;
      }

      return myOption;
    }));
  }
  static final BookClient instance = BookClient._internal();

  Dio get dio => _dio;
}
