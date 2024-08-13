import 'package:flutter/material.dart';
import 'package:flutter_doanlt/models/shoe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteButton extends StatefulWidget {
  final Shoe shoe;
  final String userId;
  final String token;
  FavoriteButton({required this.shoe, required this.userId, required this.token});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  void _loadFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteShoesJson = prefs.getStringList('favoriteShoes') ?? [];
    List<Shoe> favoriteShoes = favoriteShoesJson.map((shoeJson) {
      return Shoe.fromJson(jsonDecode(shoeJson));
    }).toList();
    
    setState(() {
      _isFavorite = favoriteShoes.any((shoe) => shoe.id == widget.shoe.id);
    });
  }

  void _toggleFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteShoesJson = prefs.getStringList('favoriteShoes') ?? [];
    List<Shoe> favoriteShoes = favoriteShoesJson.map((shoeJson) {
      return Shoe.fromJson(jsonDecode(shoeJson));
    }).toList();

    setState(() {
      _isFavorite = !_isFavorite;
      if (_isFavorite) {
        favoriteShoes.add(widget.shoe);
      } else {
        favoriteShoes.removeWhere((shoe) => shoe.id == widget.shoe.id);
      }
      List<String> updatedFavoriteShoesJson = favoriteShoes.map((shoe) {
        return jsonEncode(shoe.toJson());
      }).toList();
      prefs.setStringList('favoriteShoes', updatedFavoriteShoesJson);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleFavorite,
      child: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        size: 24.0,
        color: _isFavorite ? Colors.red : Colors.black,
      ),
    );
  }
}
