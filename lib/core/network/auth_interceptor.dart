import 'package:dio/dio.dart';
import 'package:kamchaiyo/features/auth/data/data_source/local/auth_local_data_source.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource localDataSource;
  AuthInterceptor(this.localDataSource);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await localDataSource.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}