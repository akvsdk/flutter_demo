import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutterdemo/config/config.dart';
import 'package:flutterdemo/generated/json/base/json_convert_content.dart';

import 'HttpError.dart';

///http请求成功回调
typedef HttpSuccessCallback<T> = void Function(dynamic data);

///失败回调
typedef HttpFailureCallback = void Function(HttpError data);

///数据解析回调
typedef T JsonParse<T>(dynamic data);

class HttpManager {
  ///同一个CancelToken可以用于多个请求，当一个CancelToken取消时，所有使用该CancelToken的请求都会被取消，一个页面对应一个CancelToken。
  Map<String, CancelToken> _cancelTokens = Map<String, CancelToken>();

  ///超时时间
  static const int CONNECT_TIMEOUT = 30000;
  static const int RECEIVE_TIMEOUT = 30000;

  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';

  Dio _client;

  static final HttpManager _instance = HttpManager._internal();

  factory HttpManager() => _instance;

  Dio get client => _client;

  /// 创建 dio 实例对象
  HttpManager._internal() {
    if (_client == null) {
      /// 全局属性：请求前缀、连接超时时间、响应超时时间
      BaseOptions options = BaseOptions(
          connectTimeout: CONNECT_TIMEOUT, receiveTimeout: RECEIVE_TIMEOUT);
      _client = Dio(options);
      (_client.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (client) {
        //Charles 抓包设置
        client.findProxy = (uri) {
          return "PROXY 192.168.2.13:8888";
        };
        //放行HTTPS 证书认证
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          print('5555');
          return true;
        };
      };
    }
  }

  void init(
      {String baseUrl,
      int connectTimeout,
      int receiveTimeout,
      List<Interceptor> interceptors}) {
    _client.options = _client.options.merge(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
    );
    if (interceptors != null && interceptors.isNotEmpty) {
      _client.interceptors..addAll(interceptors);
    }
  }

  ///Get网络请求
  ///
  ///[url] 网络请求地址不包含域名
  ///[params] url请求参数支持restful
  ///[options] 请求配置
  ///[successCallback] 请求成功回调
  ///[errorCallback] 请求失败回调
  ///[tag] 请求统一标识，用于取消网络请求
  void get({
    @required String url,
    Map<String, dynamic> params,
    Options options,
    HttpSuccessCallback successCallback,
    HttpFailureCallback errorCallback,
    @required String tag,
  }) async {
    _request(
      url: url,
      params: params,
      method: GET,
      successCallback: successCallback,
      errorCallback: errorCallback,
      tag: tag,
    );
  }

  ///post网络请求
  ///
  ///[url] 网络请求地址不包含域名
  ///[data] post 请求参数
  ///[params] url请求参数支持restful
  ///[options] 请求配置
  ///[successCallback] 请求成功回调
  ///[errorCallback] 请求失败回调
  ///[tag] 请求统一标识，用于取消网络请求
  void post({
    @required String url,
    data,
    Map<String, dynamic> params,
    Options options,
    HttpSuccessCallback successCallback,
    HttpFailureCallback errorCallback,
    @required String tag,
  }) async {
    _request(
      url: url,
      data: data,
      method: POST,
      params: params,
      successCallback: successCallback,
      errorCallback: errorCallback,
      tag: tag,
    );
  }

  ///统一网络请求
  ///
  ///[url] 网络请求地址不包含域名
  ///[data] post 请求参数
  ///[params] url请求参数支持restful
  ///[options] 请求配置
  ///[successCallback] 请求成功回调
  ///[errorCallback] 请求失败回调
  ///[tag] 请求统一标识，用于取消网络请求
  void _request({
    @required String url,
    String method,
    data,
    Map<String, dynamic> params,
    Options options,
    HttpSuccessCallback successCallback,
    HttpFailureCallback errorCallback,
    @required String tag,
  }) async {
    //检查网络是否连接
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (errorCallback != null) {
        errorCallback(HttpError(HttpError.NETWORK_ERROR, "网络异常，请稍后重试！"));
      }
      LogUtil.v("请求网络异常，请稍后重试！");
      return;
    }

    //设置默认值
    params = params ?? {};
    method = method ?? 'GET';

    options?.method = method;

    options = options ??
        Options(
          method: method,
        );

    url = _restfulUrl(url, params);

    try {
      CancelToken cancelToken;
      if (tag != null) {
        cancelToken =
            _cancelTokens[tag] == null ? CancelToken() : _cancelTokens[tag];
        _cancelTokens[tag] = cancelToken;
      }

      Response<Map<String, dynamic>> response = await _client.request(url,
          data: data,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken);
      int statusCode = response.data[Config.HTTP_ERROR_CODE];
      if (statusCode == Config.HTTP_DEF_SUCCESS_CODE) {
        //成功
        if (successCallback != null) {
          successCallback(response.data[Config.HTTP_DATA]);
        }
      } else {
        //失败
        String message = response.data[Config.HTTP_ERROR_MSG];
        LogUtil.v("请求服务器出错：$message");
        if (errorCallback != null) {
          errorCallback(HttpError(statusCode.toString(), message));
        }
      }
    } on DioError catch (e, s) {
      LogUtil.v("请求出错：$e\n$s");
      if (errorCallback != null && e.type != DioErrorType.CANCEL) {
        errorCallback(HttpError.dioError(e));
      }
    } catch (e, s) {
      LogUtil.v("未知异常出错：$e\n$s");
      if (errorCallback != null) {
        errorCallback(HttpError(HttpError.UNKNOWN, "网络异常，请稍后重试！"));
      }
    }
  }

  ///GET异步网络请求
  ///
  ///[url] 网络请求地址不包含域名
  ///[params] url请求参数支持restful
  ///[options] 请求配置
  ///[tag] 请求统一标识，用于取消网络请求
  Future<T> getAsync<T>({
    @required String url,
    Map<String, dynamic> params,
    Options options,
    JsonParse<T> jsonParse,
    @required String tag,
  }) async {
    return _requestAsync(
      url: url,
      method: GET,
      params: params,
      options: options,
      jsonParse: jsonParse,
      tag: tag,
    );
  }

  ///POST 异步网络请求
  ///
  ///[url] 网络请求地址不包含域名
  ///[data] post 请求参数
  ///[params] url请求参数支持restful
  ///[options] 请求配置
  ///[tag] 请求统一标识，用于取消网络请求
  Future<T> postAsync<T>({
    @required String url,
    data,
    Map<String, dynamic> params,
    Options options,
    JsonParse<T> jsonParse,
    @required String tag,
  }) async {
    return _requestAsync(
      url: url,
      method: POST,
      data: data,
      params: params,
      options: options,
      jsonParse: jsonParse,
      tag: tag,
    );
  }

  ///统一网络请求
  ///
  ///[url] 网络请求地址不包含域名
  ///[data] post 请求参数
  ///[params] url请求参数支持restful
  ///[options] 请求配置
  ///[tag] 请求统一标识，用于取消网络请求
  Future<T> _requestAsync<T>({
    @required String url,
    String method,
    data,
    Map<String, dynamic> params,
    Options options,
    JsonParse<T> jsonParse,
    @required String tag,
  }) async {
    //检查网络是否连接
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      LogUtil.v("请求网络异常，请稍后重试！");
      throw (HttpError(HttpError.NETWORK_ERROR, "网络异常，请稍后重试！"));
    }

    //设置默认值
    params = params ?? {};
    method = method ?? 'GET';

    options?.method = method;

    options = options ??
        Options(
          method: method,
        );

    url = _restfulUrl(url, params);

    try {
      CancelToken cancelToken;
      if (tag != null) {
        cancelToken =
            _cancelTokens[tag] == null ? CancelToken() : _cancelTokens[tag];
        _cancelTokens[tag] = cancelToken;
      }

      Response<Map<String, dynamic>> response = await _client.request(url,
          queryParameters: params,
          data: data,
          options: options,
          cancelToken: cancelToken);
      int statusCode = response.data[Config.HTTP_ERROR_CODE];
      if (statusCode == 0) {
        //成功
        if (jsonParse != null) {
          return jsonParse(response.data[Config.HTTP_DATA]);
        } else {
          return JsonConvert.fromJsonAsT<T>(response.data[Config.HTTP_DATA]);
        }
      } else {
        //失败
        String message = response.data[Config.HTTP_ERROR_MSG];
        LogUtil.v("请求服务器出错：$message");
        //只能用 Future，外层有 try catch
        return Future.error((HttpError(statusCode.toString(), message)));
      }
    } on DioError catch (e, s) {
      LogUtil.v("请求出错：$e\n$s");
      throw (HttpError.dioError(e));
    } catch (e, s) {
      LogUtil.v("未知异常出错：$e\n$s");
      throw (HttpError(HttpError.UNKNOWN, "网络异常，请稍后重试！"));
    }
  }

  ///异步下载文件
  ///
  ///[url] 下载地址
  ///[savePath]  文件保存路径
  ///[onReceiveProgress]  文件保存路径
  ///[data] post 请求参数
  ///[params] url请求参数支持restful
  ///[options] 请求配置
  ///[tag] 请求统一标识，用于取消网络请求
  Future<Response> downloadAsync({
    @required String url,
    @required savePath,
    ProgressCallback onReceiveProgress,
    Map<String, dynamic> params,
    data,
    Options options,
    @required String tag,
  }) async {
    //检查网络是否连接
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      LogUtil.v("请求网络异常，请稍后重试！");
      throw (HttpError(HttpError.NETWORK_ERROR, "网络异常，请稍后重试！"));
    }
    //设置下载不超时
    int receiveTimeout = 0;
    options ??= options == null
        ? Options(receiveTimeout: receiveTimeout)
        : options.merge(receiveTimeout: receiveTimeout);

    //设置默认值
    params = params ?? {};

    url = _restfulUrl(url, params);

    try {
      CancelToken cancelToken;
      if (tag != null) {
        cancelToken =
            _cancelTokens[tag] == null ? CancelToken() : _cancelTokens[tag];
        _cancelTokens[tag] = cancelToken;
      }

      return _client.download(url, savePath,
          onReceiveProgress: onReceiveProgress,
          queryParameters: params,
          data: data,
          options: options,
          cancelToken: cancelToken);
    } on DioError catch (e, s) {
      LogUtil.v("请求出错：$e\n$s");
      throw (HttpError.dioError(e));
    } catch (e, s) {
      LogUtil.v("未知异常出错：$e\n$s");
      throw (HttpError(HttpError.UNKNOWN, "网络异常，请稍后重试！"));
    }
  }

  ///上传文件
  ///
  ///[url] 网络请求地址不包含域名
  ///[data] post 请求参数
  ///[onSendProgress] 上传进度
  ///[params] url请求参数支持restful
  ///[options] 请求配置
  ///[tag] 请求统一标识，用于取消网络请求
  Future<T> uploadAsync<T>({
    @required String url,
    FormData data,
    ProgressCallback onSendProgress,
    Map<String, dynamic> params,
    Options options,
    JsonParse<T> jsonParse,
    @required String tag,
  }) async {
    //检查网络是否连接
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      LogUtil.v("请求网络异常，请稍后重试！");
      throw (HttpError(HttpError.NETWORK_ERROR, "网络异常，请稍后重试！"));
    }

    //设置默认值
    params = params ?? {};

    //强制 POST 请求
    options?.method = POST;

    options = options ??
        Options(
          method: POST,
        );

    url = _restfulUrl(url, params);

    try {
      CancelToken cancelToken;
      if (tag != null) {
        cancelToken =
            _cancelTokens[tag] == null ? CancelToken() : _cancelTokens[tag];
        _cancelTokens[tag] = cancelToken;
      }

      Response<Map<String, dynamic>> response = await _client.request(url,
          onSendProgress: onSendProgress,
          data: data,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken);

      int statusCode = response.data[Config.HTTP_ERROR_CODE];
      if (statusCode == 0) {
        //成功
        if (jsonParse != null) {
          return jsonParse(response.data[Config.HTTP_DATA]);
        } else {
          return JsonConvert.fromJsonAsT<T>(response.data[Config.HTTP_DATA]);
        }
      } else {
        //失败
        String message = response.data["statusDesc"];
        LogUtil.v("请求服务器出错：$message");
        return Future.error((HttpError(statusCode.toString(), message)));
      }
    } on DioError catch (e, s) {
      LogUtil.v("请求出错：$e\n$s");
      throw (HttpError.dioError(e));
    } catch (e, s) {
      LogUtil.v("未知异常出错：$e\n$s");
      throw (HttpError(HttpError.UNKNOWN, "网络异常，请稍后重试！"));
    }
  }

  ///取消网络请求
  void cancel(String tag) {
    if (_cancelTokens.containsKey(tag)) {
      if (!_cancelTokens[tag].isCancelled) {
        _cancelTokens[tag].cancel();
      }
      _cancelTokens.remove(tag);
    }
  }

  ///restful处理
  String _restfulUrl(String url, Map<String, dynamic> params) {
    // restful 请求处理
    // /gysw/search/hist/:user_id        user_id=27
    // 最终生成 url 为     /gysw/search/hist/27
    params.forEach((key, value) {
      if (url.indexOf(key) != -1) {
        url = url.replaceAll(':$key', value.toString());
      }
    });
    return url;
  }
}
