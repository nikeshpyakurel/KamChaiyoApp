import 'package:dio/dio.dart';
import 'package:kamchaiyo/core/network/api_endpoints.dart';
import 'package:kamchaiyo/core/network/auth_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  final Dio _dio;
  final AuthInterceptor _authInterceptor;

  DioClient(this._dio, this._authInterceptor) {
    _dio.options = BaseOptions(baseUrl: ApiEndpoints.baseUrl, connectTimeout: const Duration(seconds: 15), receiveTimeout: const Duration(seconds: 15), responseType: ResponseType.json);
    _dio.interceptors.add(_authInterceptor);
    _dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: false, error: true, compact: true, maxWidth: 90));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async => _dio.get(path, queryParameters: queryParameters);
  Future<Response> post(String path, {dynamic data}) async => _dio.post(path, data: data);
  Future<Response> patch(String path, {dynamic data}) async => _dio.patch(path, data: data);
  Future<Response> put(String path, {dynamic data}) async {
  return _dio.put(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) async =>
      _dio.delete(path, data: data);
}