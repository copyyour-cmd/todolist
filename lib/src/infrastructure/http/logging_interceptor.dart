import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 日志拦截器 - 仅在开发模式下打印请求日志
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('╔══════════════════════════════════════════════════════════════');
      print('║ REQUEST: ${options.method} ${options.uri}');
      print('║ Headers: ${options.headers}');
      if (options.data != null) {
        print('║ Body: ${options.data}');
      }
      if (options.queryParameters.isNotEmpty) {
        print('║ Query: ${options.queryParameters}');
      }
      print('╚══════════════════════════════════════════════════════════════');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('╔══════════════════════════════════════════════════════════════');
      print('║ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}');
      print('║ Data: ${response.data}');
      print('╚══════════════════════════════════════════════════════════════');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('╔══════════════════════════════════════════════════════════════');
      print('║ ERROR: ${err.requestOptions.method} ${err.requestOptions.uri}');
      print('║ Status: ${err.response?.statusCode}');
      print('║ Message: ${err.message}');
      print('║ Data: ${err.response?.data}');
      print('╚══════════════════════════════════════════════════════════════');
    }
    handler.next(err);
  }
}
