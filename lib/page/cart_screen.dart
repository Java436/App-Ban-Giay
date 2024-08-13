import 'package:flutter/material.dart';
import 'package:flutter_doanlt/api_service/cart_service.dart';
import 'package:flutter_doanlt/utility/format_price.dart';
import 'package:provider/provider.dart';
import 'cart_item.dart';
import 'checkout_screen.dart';
import '../provider/cart_provider.dart';

class CartScreen extends StatefulWidget {
  final String userId;
  final String token;
  
  CartScreen({required this.userId, required this.token});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService cartService = CartService();

 

  void _increaseQuantity(Map<String, dynamic> item) {
    setState(() {
      item['quantity'] = (item['quantity'] ?? 0) + 1;
    });
    Provider.of<CartProvider>(context, listen: false).loadCartItems([...Provider.of<CartProvider>(context, listen: false).items]);
  }

  void _decreaseQuantity(Map<String, dynamic> item) {
    setState(() {
      if ((item['quantity'] ?? 0) > 1) {
        item['quantity'] = (item['quantity'] ?? 0) - 1;
      }
    });
    Provider.of<CartProvider>(context, listen: false).loadCartItems([...Provider.of<CartProvider>(context, listen: false).items]);
  }

  void _removeItem(Map<String, dynamic> item) {
    setState(() {
      Provider.of<CartProvider>(context, listen: false).items.remove(item);
    });
  }

  void _onQuantityChanged(Map<String, dynamic> item, int newQuantity) {
    setState(() {
      item['quantity'] = newQuantity;
    });
    Provider.of<CartProvider>(context, listen: false).loadCartItems([...Provider.of<CartProvider>(context, listen: false).items]);
  }

  Future<void> _checkout() async {
    final cartItems = Provider.of<CartProvider>(context, listen: false).items;
    final totalAmount = cartItems.fold(
      0.0,
      (sum, item) => sum + ((item['price'] ?? 0.0) * ((item['quantity'] ?? 0) as int)),
    );

    await cartService.createCart(widget.userId, cartItems, totalAmount, widget.token);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(
          token: widget.token,
          userId: widget.userId,
          cartItems: cartItems,
          totalAmount: totalAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<CartProvider>(context).items;
    final double totalAmount = cartItems.fold(
      0.0,
      (sum, item) => sum + ((item['price'] ?? 0.0) * ((item['quantity'] ?? 0) as int)),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6699CC),
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 0, 0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            splashColor: Color(0xFF6699CC),
            hoverColor: Color(0xFF6699CC),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
              child: Icon(Icons.arrow_back_ios, size: 20),
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Center(
            child: Text(
              'Giỏ hàng',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Container(
            width: 52,
            height: 40,
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return CartItem(
                    item: cartItems[index],
                    onIncreaseQuantity: _increaseQuantity,
                    onDecreaseQuantity: _decreaseQuantity,
                    onRemoveItem: _removeItem,
                    onQuantityChanged: _onQuantityChanged,
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng tiền hàng', style: TextStyle(fontSize: 18)),
                      Text(
                        formatPrice(totalAmount),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng thanh toán',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(
                        formatPrice(totalAmount),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _checkout,
                    child: Text('Đặt hàng',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFE279),
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
