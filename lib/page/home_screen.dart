import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = '';

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6699CC),
      appBar: AppBar(
        backgroundColor: Color(0xFF6699CC),
        elevation: 0,
        leading: Icon(Icons.menu),
        title: Center(
          // Wrap with Center widget
          child: Text(
            'F5Store',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold, // Make the text bold
              color: Colors.black, // Keep the text white
            ),
          ),
        ),
        actions: [
          Padding(
            // Align shopping cart button to the right edge of the search bar
            padding: EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor:
                Color(0xFF6699CC), // make the app bar fixed at the top
            title: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Tìm kiếm',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CategoryButton(
                        iconPath: 'assets/logo_nike.png',
                        //label: 'Nike',
                        isSelected: selectedCategory == 'Nike',
                        onTap: () => selectCategory('Nike'),
                      ),
                      CategoryButton(
                        iconPath: 'assets/logo_puma.png',
                        //label: 'Puma',
                        isSelected: selectedCategory == 'Puma',
                        onTap: () => selectCategory('Puma'),
                      ),
                      CategoryButton(
                        iconPath: 'assets/logo_underarmour.png',
                        //label: 'Under Armour',
                        isSelected: selectedCategory == 'Under Armour',
                        onTap: () => selectCategory('Under Armour'),
                      ),
                      CategoryButton(
                        iconPath: 'assets/logo_adidas.png',
                        //label: 'Adidas',
                        isSelected: selectedCategory == 'Adidas',
                        onTap: () => selectCategory('Adidas'),
                      ),
                      CategoryButton(
                        iconPath: 'assets/logo_converse.png',
                        //label: 'Converse',
                        isSelected: selectedCategory == 'Converse',
                        onTap: () => selectCategory('Converse'),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  SectionTitle(title: 'Nổi Bật', onViewAll: () {}),
                  SizedBox(height: 10.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ProductCard(
                          imagePath: 'assets/nike-zoom-winflo.png',
                          name: 'Nike Jordan',
                          price: '493.000đ',
                        ),
                        SizedBox(width: 16.0),
                        ProductCard(
                          imagePath: 'assets/nike_airmax.png',
                          name: 'Nike Air Max',
                          price: '899.000đ',
                        ),
                        SizedBox(width: 16.0),
                        ProductCard(
                          imagePath: 'assets/nike_airmax.png',
                          name: 'Nike Air Max',
                          price: '899.000đ',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SectionTitle(title: 'Sản Phẩm Mới', onViewAll: () {}),
                  SizedBox(height: 10.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ProductCard1(
                          imagePath: 'assets/nike_air_jordan.png',
                          name: 'Nike Air Jordan',
                          price: '849.000đ',
                        ),
                        SizedBox(width: 16.0),
                        ProductCard1(
                          imagePath: 'assets/nike_air_jordan.png',
                          name: 'Nike Air Jordan',
                          price: '849.000đ',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active_outlined),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String iconPath;
  //final String label;
  final bool isSelected;
  final VoidCallback onTap;

  CategoryButton({
    required this.iconPath,
    //required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFEB941) : Color(0xFFFFE279),
          borderRadius: BorderRadius.circular(35.0),
          border: Border.all(
            color: isSelected ? Color(0xFFFEB941) : Color(0xFF6699CC),
            width: 3.0,
          ),
        ),
        child: Column(
          children: [
            Image.asset(iconPath, width: 40.0, height: 40.0),
            //Text(label, style: TextStyle(fontSize: 12.0)),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  SectionTitle({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          child: Text('Xem thêm', style: TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }
}

class FavoriteButton extends StatefulWidget {
  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      },
      child: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        size: 30.0,
        color: _isFavorite ? Colors.red : Colors.black,
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;

  ProductCard({
    required this.imagePath,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 200,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0)),
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 110.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'THỊNH HÀNH',
                          style: TextStyle(
                            color: Color(0xFF5B9EE1),
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10.0,
                left: 10.0,
                child: FavoriteButton(),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: InkWell(
                  onTap: () {
                    // handle tap event here
                  },
                  splashColor: Colors.white,
                  child: Container(
                    width: 50.0, // adjust the width
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ), // adjust the radius to your liking
                    ),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductCard1 extends StatelessWidget {
  final String imagePath;
  final String name;
  final String price;

  ProductCard1({
    required this.imagePath,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 350,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 180,
                child: Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0), // add left padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                'ĐƯỢC ƯA CHUỘNG',
                                style: TextStyle(
                                  color: Color(0xFF5B9EE1),
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0), // add right padding
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          height: 130.0,
                          width: 170.0,
                        ),
                      ),
                      Positioned(
                        top: 20.0,
                        left: 10.0,
                        child: FavoriteButton(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
