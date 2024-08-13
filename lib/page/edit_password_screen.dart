import 'package:flutter/material.dart';

class EditPasswordScreen extends StatefulWidget {
  @override
  _EditPasswordScreenState createState() => _EditPasswordScreenState();
}

class _EditPasswordScreenState extends State<EditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmNewPassword = '';

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 20),
              Text('Thay đổi mật khẩu thành công!',
                  style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6699CC), // Màu nền xanh
      appBar: AppBar(
        backgroundColor: Color(0xFF6699CC),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0), // Add padding to the left
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            }, // Add tap callback
            splashColor: Color(0xFF6699CC), // Remove splash effect
            hoverColor: Color(0xFF6699CC),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // White background
                shape: BoxShape.circle, // Circular shape
              ),
              padding: const EdgeInsets.all(8.0), // Add padding to the icon
              child: Icon(Icons.arrow_back_ios, size: 20), // Reduce icon size
            ),
          ),
        ),
        title: Center(
          child: Text(
            'Đổi mật khẩu',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
                  color: Colors.white, // White background
                  shape: BoxShape.circle, // Circular shape
                ),
                padding: const EdgeInsets.all(8.0), // Add padding to the icon
                child:
                    Icon(Icons.edit, color: Colors.black), // Reduce icon size
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lưu ý: Mật khẩu phải có ít nhất 8 ký tự bao gồm ít nhất 1 chữ thường, 1 ký tự đặc biệt và 1 số.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    ProfileDetailRow(
                      title: 'Mật khẩu hiện tại',
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập mật khẩu hiện tại',
                          filled: true,
                          fillColor: Colors.grey[400],
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập mật khẩu hiện tại';
                          }
                          return null;
                        },
                        onSaved: (value) => _currentPassword = value!,
                      ),
                    ),
                    ProfileDetailRow(
                      title: 'Mật khẩu mới',
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nhập mật khẩu mới',
                          filled: true,
                          fillColor: Colors.grey[400],
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập mật khẩu mới';
                          } else if (value.length < 8) {
                            return 'Mật khẩu phải có ít nhất 8 ký tự';
                          } else if (!hasLowercaseLetter(value)) {
                            return 'Mật khẩu phải có ít nhất 1 chữ thường';
                          } else if (!hasUppercaseLetter(value)) {
                            return 'Mật khẩu phải có ít nhất 1 chữ hoa';
                          } else if (!hasDigit(value)) {
                            return 'Mật khẩu phải có ít nhất 1 số';
                          } else if (!hasSpecialCharacter(value)) {
                            return 'Mật khẩu phải có ít nhất 1 ký tự đặc biệt';
                          }
                          return null;
                        },
                        onSaved: (value) => _newPassword = value!,
                      ),
                    ),
                    ProfileDetailRow(
                      title: 'Xác nhận mật khẩu mới',
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Xác nhận mật khẩu mới',
                          filled: true,
                          fillColor: Colors.grey[400],
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng xác nhận mật khẩu mới';
                          } else if (value != _newPassword) {
                            return 'Mật khẩu mới và xác nhận mật khẩu mới không khớp';
                          }
                          return null;
                        },
                        onSaved: (value) => _confirmNewPassword = value!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _showSuccessDialog(
                        context); // Xử lý khi nhấn nút lưu thay đổi
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFE279), // Màu vàng
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Đổi mật khẩu',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

bool hasLowercaseLetter(String password) {
  return password.contains(new RegExp(r'[a-z]'));
}

bool hasUppercaseLetter(String password) {
  return password.contains(new RegExp(r'[A-Z]'));
}

bool hasDigit(String password) {
  return password.contains(new RegExp(r'\d'));
}

bool hasSpecialCharacter(String password) {
  return password.contains(new RegExp(r'[^A-Za-z0-9]'));
}

class ProfileDetailRow extends StatelessWidget {
  final String title;
  final Widget child;

  ProfileDetailRow({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
