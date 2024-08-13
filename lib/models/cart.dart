import 'package:flutter_doanlt/models/cart_item.dart';

class Cart {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalPrice; // Đảm bảo totalPrice là int

  Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<CartItem> itemsList = itemsJson.map((i) => CartItem.fromJson(i)).toList();

    return Cart(
      id: json['_id'],
      userId: json['userId'],
      items: itemsList,
      totalPrice: json['totalPrice'] ?? 0, // Thêm kiểm tra null ở đây
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
    };
  }
}
