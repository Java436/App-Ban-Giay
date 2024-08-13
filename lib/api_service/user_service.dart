import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_doanlt/models/user.dart';
import 'package:flutter_doanlt/api_service/dio_config.dart';
import 'package:http_parser/http_parser.dart';


class UserService {
   final Dio _dio = DioConfig.instance;

  Future<User> getUserDetails(String userId, String token) async {
    try {
      final response = await _dio.get(
        '/users/$userId',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch user details');
      }
    } catch (error) {
      throw Exception('Failed to fetch user details: $error');
    }
  }
  
 Future<User> updateUserDetails(String userId, String token, Map<String, dynamic> updateData) async {
    try {
      final response = await _dio.put(
        '/users/$userId',
        data: updateData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update user details: $e');
    }
  }

    Future<User> updateUserProfilePicture(String userId, String token, File imageFile) async {
      try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType('image', 'jpeg', ), // Ensure correct MIME type
        ),
      });

      final response = await _dio.put(
        '/users/$userId/avatar',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to update user profile picture');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to update user profile picture: $e');
    }
  }
}