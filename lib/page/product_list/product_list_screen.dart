import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_doanlt/api_service/cart_service.dart';
import 'package:flutter_doanlt/api_service/shoe_service.dart';
import 'package:flutter_doanlt/models/shoe.dart';
import 'package:flutter_doanlt/models/stock.dart';
import 'package:flutter_doanlt/page/cart_screen.dart';
import 'package:flutter_doanlt/page/filter.dart';
import 'package:flutter_doanlt/page/product_list/product_card.dart';
import 'package:flutter_doanlt/page/search.dart';
import 'package:flutter_doanlt/provider/cart_provider.dart';

class ProductListScreen extends StatefulWidget {
  final String userId;
  final String token;

  ProductListScreen({required this.userId, required this.token});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Shoe> shoes = [];
  List<Shoe> allShoes = [];
  bool isLoading = true;
  List<Map<String, dynamic>> cartItems = [];
  final CartService cartService  = CartService();

  @override
  void initState() {
    super.initState();
    _loadCart();
    _loadProducts();
  }

  Future<void> _loadCart() async {
    CartService cartService = CartService();
    try {
      List<Map<String, dynamic>> fetchedCartItems = await cartService.getCartItems(widget.userId, widget.token);
      setState(() {
        cartItems = fetchedCartItems;
      });
      Provider.of<CartProvider>(context, listen: false).loadCartItems(fetchedCartItems);
    } catch (e) {
      print('Error loading cart items: $e');
    }
  }

  Future<void> _loadProducts() async {
    ShoeService apiService = ShoeService();
    try {
      List<Shoe> fetchedShoes = await apiService.getShoes();
      setState(() {
        shoes = fetchedShoes;
        allShoes = fetchedShoes;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FilterSheet(
          onFilterApplied: (filteredShoes) {
            setState(() {
              shoes = filteredShoes;
            });
          },
          allShoes: allShoes,
        );
      },
    );
  }

 Future<void> _addToCart(Shoe shoe, Stock stock, int quantity) async {
  Provider.of<CartProvider>(context, listen: false).addToCart(shoe, stock, quantity);

  double totalPrice = Provider.of<CartProvider>(context, listen: false).items.fold(0, (sum, item) => sum + item['price'] * item['quantity']);
  
  await CartService().createCart(widget.userId, Provider.of<CartProvider>(context, listen: false).items, totalPrice, widget.token);
}

  

  Future<void> _navigateToCartScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(userId: widget.userId, token: widget.token,),
      ),
    );
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    int totalItemsInCart = Provider.of<CartProvider>(context).itemCount;

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
              'Giày Nike',
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen(token: widget.token)),
                );
              },
              splashColor: Color(0xFF6699CC),
              hoverColor: Color(0xFF6699CC),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.search, size: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 0),
            child: InkWell(
              onTap: _openFilterSheet,
              splashColor: Color(0xFF6699CC),
              hoverColor: Color(0xFF6699CC),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.filter_list, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 16),
        child: Container(
          color: Color(0xFF6699CC),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : shoes.isNotEmpty
                  ? GridView.builder(
                      padding: EdgeInsets.all(5.0),
                      itemCount: shoes.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.730,
                      ),
                      itemBuilder: (context, index) {
                        return ProductCard(
                          shoe: shoes[index],
                          onAddToCart: (shoe, stock, quantity) => _addToCart(shoe, stock, quantity),
                          userId: widget.userId,
                          token: widget.token,
                        );
                      },
                    )
                  : Center(child: Text('Không tìm thấy sản phẩm')),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: _navigateToCartScreen,
            child: Icon(Icons.shopping_cart),
            backgroundColor: Colors.blue,
          ),
          if (totalItemsInCart > 0)
            Positioned(
              right: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red,
                child: Text(
                  '$totalItemsInCart',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
