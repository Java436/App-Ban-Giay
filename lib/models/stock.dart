class Stock {
  final String id; // Thêm trường id
  final int size;
  final int quantity;

  Stock({
    required this.id, // Thêm trường id vào constructor
    required this.size,
    required this.quantity,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      id: json['_id'], // Thêm id vào fromJson
      size: json['size'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Thêm id vào toJson
      'size': size,
      'quantity': quantity,
    };
  }
}
