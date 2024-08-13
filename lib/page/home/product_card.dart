import 'package:flutter/material.dart';
import 'package:flutter_doanlt/models/shoe.dart';
import 'package:flutter_doanlt/page/favorite_button.dart';
import 'package:flutter_doanlt/page/productDetailScreen.dart';
import 'package:flutter_doanlt/utility/format_price.dart';

class HomePageCard extends StatelessWidget {
  final Shoe shoe;
  final String userId;
  final String token;

  HomePageCard({required this.shoe, required this.token, required this.userId});

  void _navigateToDetailScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(shoe: shoe, token: token, userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: InkWell(
          onTap: () => _navigateToDetailScreen(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    child: Image.network(
                      shoe.imageUrl,
                      fit: BoxFit.cover,
                      height: 120,
                      width: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shoe.name,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
 
                    SizedBox(height: 8.0),
                    Text(
                      formatPrice(shoe.price),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FavoriteButton(shoe: shoe, userId: userId, token: token),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
