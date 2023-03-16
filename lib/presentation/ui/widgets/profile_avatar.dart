import 'package:ClassConnect/utils/extension.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.width, required this.height, required this.username});

  final double width;
  final double height;
  final String username;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey,
      child: Text(username.firstLatter()),
    );
  }
}
