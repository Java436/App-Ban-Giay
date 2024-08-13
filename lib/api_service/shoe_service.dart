import 'package:dio/dio.dart';
import 'package:flutter_doanlt/api_service/dio_config.dart';
import 'package:flutter_doanlt/models/shoe.dart';

class ShoeService {
  final Dio _dio = DioConfig.instance;

  Future<List<Shoe>> getShoes({String brand= ''}) async {
    try {
     String url = brand.isEmpty
          ? '/shoes'  // URL để lấy tất cả sản phẩm
          : '/shoes/brand/$brand';  // URL để lọc theo danh mục

      final response = await _dio.get(
        url,
      );
      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');
      if (response.statusCode == 200) {
        List<Shoe> shoes = (response.data as List).map((json) {
          print('Processing shoe JSON: $json');
          return Shoe.fromJson(json);
        }).toList();
        return shoes;
      } else {
        throw Exception('Failed to load shoes');
      }
    } catch (error) {
      if (error is DioError) {
        print('DioError: ${error.message}');
        if (error.response != null) {
          print('DioError response: ${error.response}');
        } else {
          print('DioError error: ${error.error}');
        }
      } else {
        print('Error: $error');
      }
      throw Exception('Failed to load shoes: $error');
    }
  }
 
  
  Future<Shoe> createShoe(Shoe shoe) async {
    try {
      final response = await _dio.post(
        '/shoes',
        data: shoe.toJson(),
      );
      if (response.statusCode == 201) {
        return Shoe.fromJson(response.data);
      } else {
        throw Exception('Failed to create shoe');
      }
    } catch (error) {
      throw Exception('Failed to create shoe: $error');
    }
  }

  Future<Shoe> updateShoe(String id, Shoe shoe) async {
    try {
      final response = await _dio.put(
        '/shoes/$id',
        data: shoe.toJson(),
      );
      if (response.statusCode == 200) {
        return Shoe.fromJson(response.data);
      } else {
        throw Exception('Failed to update shoe');
      }
    } catch (error) {
      throw Exception('Failed to update shoe: $error');
    }
  }

  Future<void> deleteShoe(String id) async {
    try {
      final response = await _dio.delete('/shoes/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete shoe');
      }
    } catch (error) {
      throw Exception('Failed to delete shoe: $error');
    }
  }
     Future<List<Shoe>> searchShoes(String query, String token) async {
    try {
      final response = await _dio.get(
        '/shoes',
        queryParameters: {'search': query},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => Shoe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch shoes');
      }
    } catch (error) {
      throw Exception('Failed to fetch shoes: $error');
    }
  }
}
