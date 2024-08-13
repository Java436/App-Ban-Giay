import 'package:dio/dio.dart';
import 'package:flutter_doanlt/models/user.dart';
import 'package:flutter_doanlt/api_service/dio_config.dart';

class AuthService {
  final Dio _dio = DioConfig.instance;
  
 Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        return response.data;
      } 
      else if(response.statusCode == 401){
         throw Exception('Lỗi tài khoản hoặc mật khẩu');
      }
      else {
        throw Exception('Đăng nhập thất bại');
      }
    } catch (error) {
      throw Exception('Đăng nhập thất bại: $error');
    }
  }

    Future<User> register(User user) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: user.toJson(),
      );
      if (response.statusCode == 201) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to register');
      }
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        final errors = (error.response?.data['errors'] as List)
            .map((e) => e['msg'])
            .toList();
        throw Exception(errors.join(', '));
      } else {
        throw Exception('Failed to register: ${error.message}');
      }
    }
  }
}
