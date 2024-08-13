import 'shoe.dart';
import 'stock.dart';

class OrderItem {
  String id;
  String orderId;
  Shoe shoe;
  Stock stock;
  int quantity;
  double priceShoe;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.shoe,
    required this.stock,
    required this.quantity,
    required this.priceShoe,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['orderItemId'] ?? '',
      orderId: json['orderId'] ?? '',
      shoe: Shoe.fromJson(json['productId'] ?? {}),
      stock: Stock.fromJson(json['stock'] ?? {}),
      quantity: json['quantity'] ?? 0,
      priceShoe: json['priceShoe']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderItemId': id,
      'orderId': orderId,
      'productId': shoe.toJson(),
      'stock': stock.toJson(),
      'quantity': quantity,
      'priceShoe': priceShoe,
    };
  }
}
