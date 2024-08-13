import 'package:flutter/material.dart';

class CategoryButton extends StatelessWidget {
  final String iconPath;
  final bool isSelected;
  final String label;
  final VoidCallback onTap;

  CategoryButton({
    required this.iconPath,
    required this.isSelected,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundColor: isSelected ? Color(0xFFFEB941) : Color(0xFFFFE279),
              child: Image.network(
                iconPath,
                width: 35.0,
                height: 35.0,
              ),
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
