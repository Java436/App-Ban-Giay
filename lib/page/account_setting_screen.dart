import 'package:flutter/material.dart';
import 'package:flutter_doanlt/page/orderhistory.dart';
import 'package:flutter_doanlt/page/profile_screen.dart';
import 'package:flutter_doanlt/page/start.dart';

class AccountSettingScreen extends StatelessWidget {
  final String token;
  final String userId;

  AccountSettingScreen({required this.token, required this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: Scaffold(
        backgroundColor: Color(0xFF6699CC),

        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 15),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Tài khoản',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 0.0),
                              child: ListTile(
                                leading: Icon(Icons.person),
                                title: Text('Thông tin tài khoản'),
                                trailing: Icon(Icons.arrow_forward_ios, size: 20),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(token: token, userId: userId),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Divider(),
                            Container(
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              child: ListTile(
                                leading: Icon(Icons.security),
                                title: Text('Chính sách bảo mật'),
                                trailing: Icon(Icons.arrow_forward_ios, size: 20),
                                onTap: () {},
                              ),
                            ),
                            Divider(),
                            Container(
                              margin: EdgeInsets.only(top: 0.0),
                              child: ListTile(
                                leading: Icon(Icons.shopping_cart_checkout),
                                title: Text('Lịch sử đơn hàng'),
                                trailing: Icon(Icons.arrow_forward_ios, size: 20),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderHistoryScreen(userId: userId, token: token,)));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25.0),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Tuỳ chọn',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 0.0),
                              child: ListTile(
                                leading: Icon(Icons.layers),
                                title: Text('Kiểm tra phiên bản'),
                                trailing: Icon(Icons.arrow_forward_ios, size: 20),
                                onTap: () {},
                              ),
                            ),
                            Divider(),
                            Container(
                              margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                              child: ListTile(
                                leading: Icon(Icons.language),
                                title: Text('Ngôn ngữ'),
                                trailing: Icon(Icons.arrow_forward_ios, size: 20),
                                onTap: () {},
                              ),
                            ),
                            Divider(),
                            Container(
                              margin: EdgeInsets.only(top: 0.0),
                              child: ListTile(
                                leading: Icon(Icons.dark_mode_outlined),
                                title: Text('Giao diện'),
                                trailing: Icon(Icons.arrow_forward_ios, size: 20),
                                onTap: () {},
                              ),
                            ),
                          ],
                        ),
),
                      SizedBox(height: 30),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => StartPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Color(0xFFFFE279),
                          minimumSize: Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        icon: Icon(Icons.logout),
                        label: Text(
                          'Đăng xuất',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
