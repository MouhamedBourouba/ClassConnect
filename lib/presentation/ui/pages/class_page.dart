import 'package:flutter/material.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({super.key, required this.classId});

  final String classId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Text('Class Code: $classId'),
        ),
      ),
    );
  }
}
