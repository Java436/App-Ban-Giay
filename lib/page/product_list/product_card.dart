import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_doanlt/models/shoe.dart';
import 'package:flutter_doanlt/models/stock.dart';
import 'package:flutter_doanlt/page/favorite_button.dart';
import 'package:flutter_doanlt/page/productDetailScreen.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductCard extends StatefulWidget {
  final Shoe shoe;
  final Function(Shoe, Stock, int) onAddToCart;
  final String userId;
  final String token;

  ProductCard({required this.shoe, required this.onAddToCart, required this.userId, required this.token});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;

  String formatPrice(double price) {
    final NumberFormat formatter = NumberFormat('#,###');
    return formatter.format(price).replaceAll(',', '.') + ' ' + 'VNĐ';
  }

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = prefs.getBool(widget.shoe.id) ?? false;
    });
  }

  void _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isFavorite = !_isFavorite;
      prefs.setBool(widget.shoe.id, _isFavorite);

      List<String> favoriteShoes = prefs.getStringList('favoriteShoes') ?? [];
      if (_isFavorite) {
        favoriteShoes.add(jsonEncode(widget.shoe.toJson()));
      } else {
        favoriteShoes.removeWhere((shoeJson) {
          Shoe shoe = Shoe.fromJson(jsonDecode(shoeJson));
          return shoe.id == widget.shoe.id;
        });
      }
      prefs.setStringList('favoriteShoes', favoriteShoes);
    });
  }

  void _showAddToCartDialog(BuildContext context) {
    int quantity = 1;
    int selectedSize = widget.shoe.stocks.isNotEmpty ? widget.shoe.stocks.first.size : 0;
    Stock selectedStock = widget.shoe.stocks.isNotEmpty ? widget.shoe.stocks.first : Stock(id: '', size: 0, quantity: 0);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add to Cart'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text('Size: '),
                  DropdownButton<int>(
                    value: selectedSize,
                    items: widget.shoe.stocks.map((stock) {
                      return DropdownMenuItem<int>(
                        value: stock.size,
                        child: Text(stock.size.toString()),
                        onTap: () {
                          setState(() {
                            selectedStock = stock;
                          });
                        },
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSize = value!;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Quantity: '),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          quantity = int.tryParse(value) ?? 1;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter quantity',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onAddToCart(widget.shoe, selectedStock, quantity);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(shoe: widget.shoe, token: widget.token, userId: widget.userId),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  child: Image.network(
                    widget.shoe.imageUrl,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.scaleDown,
                  ),
                ),    
                 Positioned(
                  right: 0.0,
                  top: 0.0,
                  child: FavoriteButton(shoe: widget.shoe, userId: widget.userId, token: widget.token,),
                ),  
              ],
            ),
               
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.shoe.brand,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          widget.shoe.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          widget.shoe.isOutOfStock ? 'Hết hàng' : 'Còn hàng',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Text(
                          formatPrice(widget.shoe.price),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    color: Colors.blue,
                    onPressed: () {
                      _showAddToCartDialog(context);
                    },
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
