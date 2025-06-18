import 'package:dio/dio.dart';
import '../utils/app_logger.dart';

class DioLoggerInterceptor extends Interceptor {
  final AppLogger _logger = AppLogger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.logNetworkRequest(
      method: options.method,
      url: options.uri.toString(),
      headers: options.headers,
      body: options.data,
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.logNetworkRequest(
      method: response.requestOptions.method,
      url: response.requestOptions.uri.toString(),
      statusCode: response.statusCode,
      responseBody: response.data?.toString().substring(0, 500), // Limit response size
      duration: Duration(
        milliseconds: DateTime.now().millisecondsSinceEpoch -
            response.requestOptions.extra['start_time'] as int? ?? 0,
      ),
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.logNetworkRequest(
      method: err.requestOptions.method,
      url: err.requestOptions.uri.toString(),
      statusCode: err.response?.statusCode,
      responseBody: err.response?.data?.toString(),
    );

    _logger.logErrorWithContext(
      'Network Request Failed',
      err,
      err.stackTrace,
      {
        'method': err.requestOptions.method,
        'url': err.requestOptions.uri.toString(),
        'status_code': err.response?.statusCode,
      },
    );

    super.onError(err, handler);
  }
}