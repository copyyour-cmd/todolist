import 'package:dio/dio.dart';

/// HTTP 异常类
class HttpException implements Exception {

  HttpException({
    required this.message, this.statusCode,
    this.data,
    this.errorCode,
  });

  factory HttpException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return HttpException(
          message: '连接超时，请检查网络连接',
          errorCode: 'TIMEOUT',
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        String message;
        String? errorCode;

        if (data is Map<String, dynamic>) {
          message = data['message'] ?? data['error'] ?? '服务器错误';
          errorCode = data['error'];
        } else {
          message = _getMessageFromStatusCode(statusCode);
        }

        return HttpException(
          statusCode: statusCode,
          message: message,
          data: data,
          errorCode: errorCode,
        );

      case DioExceptionType.cancel:
        return HttpException(
          message: '请求已取消',
          errorCode: 'CANCELLED',
        );

      case DioExceptionType.connectionError:
        return HttpException(
          message: '网络连接失败，请检查网络设置',
          errorCode: 'CONNECTION_ERROR',
        );

      case DioExceptionType.badCertificate:
        return HttpException(
          message: '证书验证失败',
          errorCode: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.unknown:
      default:
        return HttpException(
          message: error.message ?? '未知错误',
          errorCode: 'UNKNOWN',
        );
    }
  }
  final int? statusCode;
  final String message;
  final dynamic data;
  final String? errorCode;

  static String _getMessageFromStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '请求参数错误';
      case 401:
        return '未授权，请先登录';
      case 403:
        return '禁止访问';
      case 404:
        return '请求的资源不存在';
      case 405:
        return '请求方法不允许';
      case 408:
        return '请求超时';
      case 409:
        return '数据冲突';
      case 422:
        return '请求格式正确但无法处理';
      case 429:
        return '请求过于频繁，请稍后再试';
      case 500:
        return '服务器内部错误';
      case 502:
        return '网关错误';
      case 503:
        return '服务暂时不可用';
      case 504:
        return '网关超时';
      default:
        return '网络请求失败 ($statusCode)';
    }
  }

  @override
  String toString() => message;
}

/// 错误拦截器
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 可以在这里添加全局错误处理逻辑
    // 例如：记录错误日志、显示错误提示等

    handler.next(err);
  }
}
