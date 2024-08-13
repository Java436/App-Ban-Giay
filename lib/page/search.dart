import 'package:flutter/material.dart';
import 'package:flutter_doanlt/api_service/shoe_service.dart';
import 'package:flutter_doanlt/models/shoe.dart';

class SearchScreen extends StatefulWidget {
  final String token;

  SearchScreen({required this.token});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Shoe> _searchResults = [];
  bool _isLoading = false;

  void _searchShoes(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await ShoeService().searchShoes(query, widget.token);
      setState(() {
        _searchResults = results;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchShoes(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Color(0xFF6699CC), // Blue background color
            child: SafeArea(
              child: Column(
                children: [
                  AppBar(
                    backgroundColor: Color(0xFF6699CC), // Same blue background color
                    elevation: 0,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: Text('Tìm kiếm'),
                    centerTitle: true,
                    actions: [
                      TextButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        child: Text(
                          'Huỷ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Tìm kiếm',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white, // White background color
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giày',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Expanded(
                    child: _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : _searchResults.isEmpty
                            ? Center(child: Text('Không có kết quả tìm kiếm'))
                            : ListView.builder(
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  final shoe = _searchResults[index];
                                  return ListTile(
                                    leading: Image.network(shoe.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                                    title: Text(shoe.name),
                                    subtitle: Text('${shoe.price}đ'),
                                    onTap: () {
                                      // Handle search item tap, navigate to detail screen
                                    },
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
    );
  }
}