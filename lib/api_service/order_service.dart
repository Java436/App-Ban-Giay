import 'package:dio/dio.dart';
import 'package:flutter_doanlt/models/order.dart';
import 'package:flutter_doanlt/models/user.dart';
import 'package:flutter_doanlt/api_service/dio_config.dart';

class OrderService {
  final Dio _dio = DioConfig.instance;
  
  Future<void> createOrder(String userId, List<Map<String, dynamic>> items, double total, String paymentMethod, String token) async {
    Map<String, dynamic> orderData = {
      'userId': userId,
      'items': items,
      'total': total,
      'paymentMethod': paymentMethod,
      'status': 'pending',
      'paymentStatus': 'pending'
    };

    try {
      final response = await _dio.post(
        '/orders',
        data: orderData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      if (response.statusCode == 201) {
        print('Order created successfully: ${response.data}');
      } else {
        throw Exception('Failed to create order');
      }
    } catch (e) {
      if (e is DioError) {
        print('Dio error: ${e.response?.data}');
      } else {
        print('Error: $e');
      }
      throw Exception('Failed to create order');
    }
  }
   Future<List<dynamic>> getOrdersByUserId(String userId, String token) async {
    try {
      final response = await _dio.get(
        '/orders/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            }),
      );
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load orders');
    }
  }
}
