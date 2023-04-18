import 'package:ClassConnect/presentation/cubit/class_page/class_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassPage extends StatelessWidget {
  const ClassPage({super.key, required this.classId});

  final String classId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => ClassCubit(classId),
      child: Scaffold(
        body: Center(
          child: Text('Class Code: $classId && iam i the teacher: &'),
        ),
      ),
    );
  }
}
