import 'package:flutter/material.dart';
import 'package:flutter_doanlt/page/Intro.dart';
import 'package:flutter_doanlt/page/sign_in.dart';
import 'package:flutter_doanlt/page/start.dart';
import 'package:flutter_doanlt/provider/cart_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // Other providers...
      ],
      child: ShoeApp(),
    ),
  );
}
class ShoeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        // Add other providers here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Color(0xFF6699CC),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF6699CC),
          ),
        ),
        home: SignInScreen(),
      ),
    );
  }
}
