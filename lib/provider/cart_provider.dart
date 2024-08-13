import 'package:flutter/material.dart';
import 'package:flutter_doanlt/models/shoe.dart';
import 'package:flutter_doanlt/models/stock.dart';

class CartProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addToCart(Shoe shoe, Stock stock, int quantity) {
    Map<String, dynamic> item = {
      'productId': shoe.id,
      'quantity': quantity,
      'stockId': stock.id,
      'title': shoe.name,
      'image': shoe.imageUrl,
      'price': shoe.price,
      'size': stock.size,
      'colors': shoe.colors
    };

    var existingItem = _items.firstWhere(
      (cartItem) => cartItem['productId'] == shoe.id && cartItem['stockId'] == stock.id,
      orElse: () => <String, dynamic>{},
    );

    if (existingItem.isNotEmpty) {
      existingItem['quantity'] += quantity;
    } else {
      _items.add(item);
    }

    notifyListeners();
  }

  void loadCartItems(List<Map<String, dynamic>> cartItems) {
    for (var item in cartItems) {
      var existingItem = _items.firstWhere(
        (cartItem) => cartItem['productId'] == item['productId'] && cartItem['stockId'] == item['stockId'],
        orElse: () => <String, dynamic>{},
      );

      if (existingItem.isNotEmpty) {
        existingItem['quantity'] = item['quantity'];
      } else {
        _items.add(item);
      }
    }
    notifyListeners();
  }

  int get itemCount => _items.length;
}
