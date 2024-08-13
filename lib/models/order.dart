import 'order_item.dart';

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final DateTime dateOrder;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.dateOrder,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<OrderItem> orderItems = itemsList.map((i) => OrderItem.fromJson(i)).toList();

    return Order(
      id: json['_id'],
      userId: json['userId'],
      items: orderItems,
      total: json['total'].toDouble(),
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
      dateOrder: DateTime.parse(json['dateOrder']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
