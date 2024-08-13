import 'package:dio/dio.dart';
import 'package:flutter_doanlt/api_service/dio_config.dart';
import 'package:flutter_doanlt/models/order.dart';

class CartService {
  final Dio _dio = DioConfig.instance;

  
  Future<void> createCart(String userId, List<Map<String, dynamic>> items,double totalPrice, String token) async {
    Map<String, dynamic> cartData = {
      'userId': userId,
      'items': items,
      'totalPrice': totalPrice,
    };

    try {
      final response = await _dio.post(
        '/carts',
        data: cartData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 201) {
        print('Cart created successfully: ${response.data}');
      } else {
        print('Failed to create cart: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioError) {
        print('Dio error: ${e.response?.data}');
      } else {
        print('Error: $e');
      }
    }
  }

   Future<List<Map<String, dynamic>>> getCartItems(String userId, String token) async {
    final response = await _dio.get(
      '/carts/$userId',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200) {
      final items = response.data['items'] as List?;
      if (items != null) {
        return items.map((item) {
          final product = item['productId'];
          final stock = item['stock'];
          return {
            'cartId': item['cartId'],
            'productId': product['_id'],
            'quantity': item['quantity'],
            'stockId': stock['_id'],
            'title': product['name'],
            'image': product['imageUrl'],
            'price': product['price'],
            'size': stock['size'],
          };
        }).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load cart items');
    }
  }


     Future<Order> checkout(String userId) async {
    try {
      final response = await _dio.post('/$userId');
      if (response.statusCode == 201) {
        return Order.fromJson(response.data['order']);
      } else {
        throw Exception('Failed to checkout');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to checkout');  
    }
  }

   Future<void> updateCartItemQuantity(String cartItemId, int quantity, String token) async {
    try {
      final response = await _dio.put(
        'carts/item/$cartItemId',
        data: {'quantity': quantity},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update cart item quantity');
      }
    } catch (e) {
      throw Exception('Error updating cart item quantity: $e');
    }
  }


  Future<void> deleteCart(String cartId, String token) async {
    try {
      await _dio.delete(
        '/carts/$cartId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      if (e is DioError) {
        return Future.error(e.response?.data ?? 'An error occurred');
      } else {
        return Future.error('An unexpected error occurred');
      }
    }
  }
}
