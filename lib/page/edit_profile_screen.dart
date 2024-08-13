import 'package:flutter/material.dart';
import 'package:flutter_doanlt/api_service/user_service.dart';
import 'package:flutter_doanlt/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// ignore: must_be_immutable
class EditProfileScreen extends StatefulWidget {
  final String token;
  final String userId;
  User user;

  EditProfileScreen({required this.token, required this.userId, required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _phone;
  String? _address;
  String? _gender;
  DateTime? _dob;
  File? _imageFile;
  TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _phone = widget.user.phone;
    _address = widget.user.address;
    _gender = widget.user.gender;
    _dob = widget.user.dob;
    if (_dob != null) {
      _dobController.text = "${_dob!.day}/${_dob!.month}/${_dob!.year}";
    }
  }

  Future<void> _updateUserDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _userService.updateUserDetails(
          widget.userId,
          widget.token,
          {
            'name': _name,
            'phone': _phone,
            'address': _address,
            'gender': _gender,
            'dob': _dob?.toIso8601String(),
          },
        );
        _fetchUpdatedUserDetails();
      } catch (e) {
        _showErrorDialog(e.toString());
      }
    }
  }

  Future<void> _updateUserProfilePicture() async {
    if (_imageFile != null) {
      try {
        await _userService.updateUserProfilePicture(
          widget.userId,
          widget.token,
          _imageFile!,
        );
        _fetchUpdatedUserDetails();
      } catch (e) {
        _showErrorDialog(e.toString());
      }
    }
  }

  Future<void> _fetchUpdatedUserDetails() async {
    try {
      User updatedUser = await _userService.getUserDetails(widget.userId, widget.token);
      setState(() {
        widget.user = updatedUser;
      });
      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _updateUserProfilePicture();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 20),
              Text('Thay đổi thông tin thành công !',
                  style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: Colors.red, size: 60),
              SizedBox(height: 20),
              Text('Có lỗi xảy ra: $message',
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
      backgroundColor: Color(0xFF6699CC),
      appBar: AppBar(
        backgroundColor: Color(0xFF6699CC),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
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
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_back_ios, size: 20),
            ),
          ),
        ),
        title: Center(
          child: Text(
            'Thay đổi thông tin',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {},
              splashColor: Color(0xFF6699CC),
              hoverColor: Color(0xFF6699CC),
              child: Container(
                decoration: BoxDecoration(
                  color:Color(0xFF6699CC),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(8.0),
        
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile == null
                    ? NetworkImage(widget.user.avatar ?? 'https://th.bing.com/th/id/OIP.JBpgUJhTt8cI2V05-Uf53AHaG1?w=179&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7')
                    : FileImage(_imageFile!) as ImageProvider,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: InkWell(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt, size: 15, color: Color(0xFF80A7D3)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Thông tin tài khoản',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ProfileDetailRow(
                      title: 'Họ và tên',
                      child: TextFormField(
                        initialValue: widget.user.name,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[400],
                        ),
                        onSaved: (value) {
                          _name = value;
                        },
                      ),
                    ),
                    ProfileDetailRow(
                      title: 'Ngày sinh',
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[400],
                        ),
                        onTap: () async {
                          try {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _dob ?? DateTime.now().subtract(Duration(days: 365 * 16)),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now().subtract(Duration(days: 365 * 16)),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                _dob = pickedDate;
                                _dobController.text = "${_dob!.day}/${_dob!.month}/${_dob!.year}";
                              });
                            }
                          } catch (e) {
                            _showErrorDialog('Error picking date: $e');
                          }
                        },
                        readOnly: true,
                        controller: _dobController,
                      ),
                    ),
                    ProfileDetailRow(
                      title: 'Giới tính',
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[400],
                        ),
                        value: widget.user.gender,
                        items: [
                          DropdownMenuItem(child: Text('Nam'), value: 'Nam'),
                          DropdownMenuItem(child: Text('Nữ'), value: 'Nữ'),
                        ],
                        onChanged: (value) {
                          _gender = value as String?;
                        },
                        onSaved: (value) {
                          _gender = value as String?;
                        },
                      ),
                    ),
                    ProfileDetailRow(
                      title: 'Điện thoại',
                      child: TextFormField(
                        initialValue: widget.user.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[400],
                        ),
                        onSaved: (value) {
                          _phone = value;
                        },
                      ),
                    ),
                    ProfileDetailRow(
                      title: 'Địa chỉ',
                      child: TextFormField(
                        initialValue: widget.user.address,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey[400],
                        ),
                        onSaved: (value) {
                          _address = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: _updateUserDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFE279),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('Lưu thay đổi',
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
      ),
    );
  }
}

class ProfileDetailRow extends StatelessWidget {
  final String title;
  final Widget child;

  ProfileDetailRow({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 4),
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
