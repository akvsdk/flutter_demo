import 'package:dio/dio.dart';
import 'package:flutterdemo/http/http_manager.dart';

class HeadInterceptor extends Interceptor {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  @override
  Future onRequest(RequestOptions options) {
    options.connectTimeout = HttpManager.CONNECT_TIMEOUT;
    options.receiveTimeout = HttpManager.RECEIVE_TIMEOUT;
    options.contentType = CONTENT_TYPE_JSON;
    return super.onRequest(options);
  }
}
