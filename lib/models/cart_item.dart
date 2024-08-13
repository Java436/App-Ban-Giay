import 'package:flutter_doanlt/models/stock.dart';

class CartItem {
  final String cartId;
  final String productId;
  final int quantity;
  final Stock stock;

  CartItem({
    required this.cartId,
    required this.productId,
    required this.quantity,
    required this.stock,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: json['cartId'] ?? '',
      productId: json['productId'] ?? '',
      quantity: json['quantity'] ?? 0,
      stock: Stock.fromJson(json['stock'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'productId': productId,
      'quantity': quantity,
      'stock': stock.toJson(),
    };
  }
}
