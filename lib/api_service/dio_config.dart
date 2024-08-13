import 'package:dio/dio.dart';

class DioConfig {
  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: 'http://192.168.1.172:3000/api',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
}
