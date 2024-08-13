import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doanlt/api_service/dio_config.dart';
import 'package:flutter_doanlt/page/home/home_page.dart';
import 'package:flutter_doanlt/api_service/cart_service.dart';
import 'package:flutter_doanlt/api_service/user_service.dart';
import 'package:flutter_doanlt/models/user.dart';
import 'package:flutter_doanlt/utility/format_price.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CheckoutScreen extends StatefulWidget {
  final String token;
  final String userId;
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  CheckoutScreen({
    required this.token,
    required this.userId,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  List<Map<String, dynamic>> cartItems = [];
  final double discount = 40900;
  final CartService cartService = CartService();
  final UserService userService = UserService();
  late Future<User> userFuture;
  String selectedPaymentMethod = 'Paypal';
  String? apiurl;
  final Dio _dio = DioConfig.instance;
  final Dio dio = DioConfig.instance;
 

  @override
  void initState() {
    super.initState();
    apiurl = 'https://851d-2402-800-62b2-8ed9-9843-7837-1dd-95dd.ngrok-free.app';
    userFuture = _fetchUserDetails();
  }

  Future<User> _fetchUserDetails() async {
    return await userService.getUserDetails(widget.userId, widget.token);
  }

Future<void> saveOrder() async {
  try {
    final response = await dio.post(
      '/orders', // Thay đổi thành URL API của bạn
      data: {
        'userId': widget.userId,
        'items': widget.cartItems,
        'total': widget.totalAmount - discount,
        'paymentMethod': selectedPaymentMethod, 
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${widget.token}', // Thêm token để xác thực
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );

    if (response.statusCode == 201) {
      print('Order saved successfully');
      _showPaymentSuccessDialog(context); // Hiển thị thông báo thanh toán thành công
    } else {
      print('Failed to save order');
      _showOrderFailedDialog(context); // Hiển thị thông báo lỗi
    }
  } catch (e) {
    print('Error: $e');
    _showOrderFailedDialog(context); // Hiển thị thông báo lỗi
  }
}


  Future<void> _initiatePayment(String appUser) async {
    try {
      final response = await _dio.post(
        '$apiurl/payment',
        data: {
          'app_user': appUser,
          'amount': widget.totalAmount,
        },
        options: Options(
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        ),
      );

      if (response.statusCode == 200) {
        final result = response.data;
        final paymentUrl = result['order_url']; // Adjust based on your backend response

        if (paymentUrl != null) {
          await _launchURL(paymentUrl);
          await Future.delayed(Duration(seconds: 2)); // Adjust the delay as needed
        } else {
          print('Payment URL not found in response');
        }
      } else {
        print('Failed to create payment');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _launchURL(String url) async {
    final encodedUrl = Uri.encodeFull(url); // Ensure the URL is properly encoded
    print('Attempting to launch URL: $encodedUrl'); // Debug information
    try {
      final launched = await launchUrlString(encodedUrl, mode: LaunchMode.externalApplication);
      if (!launched) {
        // Try another mode if the first one fails
        await launchUrlString(encodedUrl, mode: LaunchMode.platformDefault);
        print('Launched URL: $encodedUrl'); // Debug information
      } else {
        print('Could not launch $encodedUrl');
      }
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  void _showNotImplementedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thông báo'),
          content: Text('Phương thức chưa được áp dụng'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double finalAmount = widget.totalAmount - discount;

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
              'Thanh toán',
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
      body: FutureBuilder<User>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading user information'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return _buildCheckoutContent(user, finalAmount);
          } else {
            return Center(child: Text('No user information found'));
          }
        },
      ),
    );
  }

  Widget _buildCheckoutContent(User user, double finalAmount) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildContactInfo(user),
                _buildAddressInfo(user),
                _buildPaymentMethod(user), // Pass the user to the payment method widget
                _buildProductInfo(),
              ],
            ),
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
                  Text(formatPrice(widget.totalAmount), style: TextStyle(fontSize: 18)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Chiết khấu', style: TextStyle(fontSize: 18)),
                  Text(formatPrice(discount), style: TextStyle(fontSize: 18)),
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tổng thanh toán',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(formatPrice(finalAmount),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (user.address == null || user.address!.isEmpty) {
                    _showMissingAddressDialog(context);
                  } else {
                    // Lưu đơn hàng trước khi thanh toán
                  await saveOrder();

                    if (selectedPaymentMethod == 'ZaloPay') {
                       
                      await _initiatePayment(widget.userId);
                    } else {
                      _showNotImplementedDialog(context);
                    }
                  }
                },
                child: Text('Thanh toán',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFE279),
                  foregroundColor: Colors.black,
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )

            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(User user) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin liên hệ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.people),
              SizedBox(width: 10),
              Expanded(
                child: Text(user.name ?? '', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.email),
              SizedBox(width: 10),
              Expanded(
                child: Text(user.email ?? '', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone),
              SizedBox(width: 10),
              Expanded(
                child: Text(user.phone ?? '', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressInfo(User user) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Địa chỉ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(user.address ?? ' ', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(User user) {
    List<String> paymentMethods = ['Paypal', 'ZaloPay', 'COD'];

    Map<String, String> paymentMethodLogos = {
      'Paypal': 'assets/images/paypal_logo.jpg',
      'ZaloPay': 'assets/images/zalo_pay.jpg',
      'COD': 'assets/images/cod_logo.jpg',
    };

    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Phương thức thanh toán', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: [
              if (paymentMethodLogos.containsKey(selectedPaymentMethod))
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Image.asset(
                    paymentMethodLogos[selectedPaymentMethod]!,
                    width: 100, // Increased width for logo
                    height: 50,
                    fit: BoxFit.cover, // Increased height for logo
                  ),
                ),
              SizedBox(
                width: 200, // Adjust the width as needed
                child: DropdownButton<String>(
                  value: selectedPaymentMethod,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPaymentMethod = newValue!;
                    });
                  },
                  items: paymentMethods.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(fontSize: 18)),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo() {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin sản phẩm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ...widget.cartItems.map((product) {
            return Column(
              children: [
                Row(
                  children: [
                    Image.network(
                      product['image'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product['title'], style: TextStyle(fontSize: 18)),
                          Text('${product['price']}đ', style: TextStyle(fontSize: 18)),
                          Text('Số lượng: ${product['quantity']}', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Color(0xFFDFEFFF),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/party_alert.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Thanh toán đơn hàng thành công!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                     MaterialPageRoute(builder: (context) => HomePage(token: widget.token, userId: widget.userId)));
                },
                child: Text('Tiếp tục mua sắm',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF5B9EE1),
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showMissingAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Lỗi'),
          content: Text('Vui lòng nhập địa chỉ để tiếp tục.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
  void _showOrderFailedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Lỗi'),
        content: Text('Không thể tạo đơn hàng. Vui lòng thử lại sau.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
}
