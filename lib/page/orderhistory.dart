import 'package:flutter/material.dart';
import 'package:flutter_doanlt/api_service/order_service.dart';
import 'package:flutter_doanlt/utility/date_format.dart';
import 'package:flutter_doanlt/utility/format_price.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  final String userId;
  final String token;

  const OrderHistoryScreen({Key? key, required this.userId, required this.token}) : super(key: key);

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late Future<List<dynamic>> futureOrders;

  @override
  void initState() {
    super.initState();
    futureOrders = OrderService().getOrdersByUserId(widget.userId, widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Lịch Sử Đơn Hàng', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Color(0xFFE3F2FD),
        child: FutureBuilder<List<dynamic>>(
          future: futureOrders,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No orders found.'));
            } else {
              List<dynamic> orders = snapshot.data!;
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderCard(order: order);
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final dynamic order;

  OrderCard({required this.order});

 
  @override
  Widget build(BuildContext context) {
    if (order['items'] != null && order['items'].isNotEmpty) {
      final item = order['items'][0];
      final shoe = item['shoe'];
      final shoeImageUrl = shoe != null ? shoe['imageUrl'] : null;
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: shoeImageUrl != null
                  ? Image.network(shoeImageUrl, width: 80, height: 80, fit: BoxFit.cover)
                  : Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey,
                      child: Icon(Icons.image, color: Colors.white),
                    ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formatDate(order['dateOrder']), style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(shoe != null ? shoe['name'] : 'Unknown Shoe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Size: ${item['stock']['size']}', style: TextStyle(fontSize: 14)),
                  Text(formatPrice(order['total'].toDouble()), style: TextStyle(fontSize: 14, color: Colors.black)),
                  Text(order['status'], style: TextStyle(fontSize: 14, color: order['status'] == 'completed' ? Colors.green : Colors.red)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('SL: ${item['quantity']}', style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text('No items found for this order'),
        ),
      );
    }
  }
}
