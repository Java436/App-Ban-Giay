import 'package:flutter/material.dart';
import 'package:flutter_doanlt/api_service/cart_service.dart';
import 'package:flutter_doanlt/models/shoe.dart';
import 'package:flutter_doanlt/models/stock.dart';
import 'package:flutter_doanlt/page/cart_screen.dart';
import 'package:flutter_doanlt/provider/cart_provider.dart';
import 'package:flutter_doanlt/utility/format_price.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Shoe shoe;
  final String userId;
  final String token;

  ProductDetailScreen({required this.shoe, required this.userId, required this.token});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String selectedColor = '';
  int selectedSize = 0;
  final CartService cartService  = CartService();
  List<Shoe> shoes = [];
  List<Shoe> allShoes = [];
  List<Map<String, dynamic>> cartItems = [];
  bool isLoading = true;
 

  @override
  void initState() {
    super.initState();
    selectedColor = widget.shoe.colors.isNotEmpty ? widget.shoe.colors[0] : '';
    selectedSize = widget.shoe.stocks.isNotEmpty ? widget.shoe.stocks[0].size  : 0;
    _loadCart();

  }

 
Future<void> _addToCart(Shoe shoe, Stock stock, int quantity) async {
  Provider.of<CartProvider>(context, listen: false).addToCart(shoe, stock, quantity);

  double totalPrice = Provider.of<CartProvider>(context, listen: false).items.fold(0, (sum, item) => sum + item['price'] * item['quantity']);
  
  await CartService().createCart(widget.userId, Provider.of<CartProvider>(context, listen: false).items, totalPrice, widget.token);
}


  
  Future<void> _loadCart() async {
    CartService cartService = CartService();
    try {
      List<Map<String, dynamic>> fetchedCartItems = await cartService.getCartItems(widget.userId, widget.token);
      setState(() {
        cartItems = fetchedCartItems;
      });
      // Update cart provider
      Provider.of<CartProvider>(context, listen: false).loadCartItems(fetchedCartItems);
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }
  
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6699CC),
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
          padding: const EdgeInsets.only(top: 22),
          child: Center(
            child: Text(
              'Giày Nam',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
            child: InkWell(
              onTap: () {
                // Navigate to cart screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen( userId: widget.userId, token: widget.token,)),
                );
              },
              splashColor: Color(0xFF6699CC),
              hoverColor: Color(0xFF6699CC),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.shopping_bag, size: 20),
                  ),
                  Positioned(
                    right: 0,
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        return CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(
                            '${cart.itemCount}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Color(0xFF6699CC),
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Image.network(widget.shoe.imageUrl,
                  height: 180, fit: BoxFit.cover),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFD3E2E9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.shoe.brand,
                      style: TextStyle(
                        color: Color(0xFF5B9EE1),
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.shoe.name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.shoe.isOutOfStock ? 'Hết hàng' : 'Còn hàng',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Mô tả:',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "   " + widget.shoe.descriptions,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      'MÀU SẮC',
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: widget.shoe.colors.map<Widget>((color) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: ColorOption(
                            _getColor(color),
                            isSelected: selectedColor == color,
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'KÍCH CỠ',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: widget.shoe.stocks.map<Widget>((stock) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSize = stock.size;
                            });
                          },
                          child: SizeOption(
                            stock.size.toString(),
                            isSelected: selectedSize == stock.size,
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GIÁ SẢN PHẨM',
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              formatPrice(widget.shoe.price) ,
                              style: TextStyle(
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            Stock selectedStock = widget.shoe.stocks.firstWhere((stock) => stock.size == selectedSize);
                            await _addToCart(widget.shoe, selectedStock, 1);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Thêm vào giỏ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(String color) {
    switch (color.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'yellow':
        return Colors.yellow;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'grey':
        return Colors.grey;
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'teal':
        return Colors.teal;
      case 'purple':
        return Colors.purple;
      case 'amber':
        return Colors.amber;
      default:
        return Colors.transparent;
    }
  }
}

class ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;

  ColorOption(this.color, {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
      ),
      child: CircleAvatar(
        radius: 15,
        backgroundColor: color,
      ),
    );
  }
}

class SizeOption extends StatelessWidget {
  final String size;
  final bool isSelected;

  SizeOption(this.size, {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Colors.white,
        border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        size,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
