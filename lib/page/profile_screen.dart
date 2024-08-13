import 'package:flutter/material.dart';
import 'package:flutter_doanlt/api_service/user_service.dart';
import 'package:flutter_doanlt/models/user.dart';
import 'package:flutter_doanlt/page/edit_profile_screen.dart'; // Import EditProfileScreen

class ProfileScreen extends StatefulWidget {
  final String token;
  final String userId;

  ProfileScreen({required this.token, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  late Future<User> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = _fetchUserDetails();
  }

  Future<User> _fetchUserDetails() async {
    return await _userService.getUserDetails(widget.userId, widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6699CC),
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
              'Thông tin tài khoản',
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
            padding:
                const EdgeInsets.only(right: 16.0), // Add padding to the right
            child: InkWell(
              onTap: () {}, // Add tap callback
              splashColor: Color(0xFF6699CC),
              hoverColor: Color(0xFF6699CC), // Remove splash effect
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF6699CC), // White background
                  shape: BoxShape.circle, // Circular shape
                ),
                padding: const EdgeInsets.all(8.0), // Add padding to the icon
                
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<User>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return Column(
              children: [
                SizedBox(height: 30),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.avatar ?? 'https://th.bing.com/th/id/OIP.JBpgUJhTt8cI2V05-Uf53AHaG1?w=179&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7'),
                ),
                SizedBox(height: 30),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileDetailRow(title: 'Họ và tên', value: user.name ?? ''),
                      ProfileDetailRow(title: 'Ngày sinh', value: user.formattedDob ?? ''),
                      ProfileDetailRow(title: 'Giới tính', value: user.gender ?? ''),
                      ProfileDetailRow(title: 'Email', value: user.email ?? ''),
                      PasswordDetailRow(title: 'Mật Khẩu', value: user.password ?? ''),
                      ProfileDetailRow(title: 'Điện thoại', value: user.phone ?? ''),
                      ProfileDetailRow(title: 'Địa chỉ', value: user.address ?? ''),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          token: widget.token,
                          userId: widget.userId,
                          user: user, // Pass user data
                        ),
                      ),
                    );
                  },
                  child: Text('Chỉnh sửa thông tin'),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String title;
  final String value;

  ProfileDetailRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            child: Text(
              '$title:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PasswordDetailRow extends StatefulWidget {
  final String title;
  final String value;

  PasswordDetailRow({required this.title, required this.value});

  @override
  _PasswordDetailRowState createState() => _PasswordDetailRowState();
}

class _PasswordDetailRowState extends State<PasswordDetailRow> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            child: Text(
              '${widget.title}:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _obscureText ? '••••••••' : widget.value,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18.0,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _toggleVisibility,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
