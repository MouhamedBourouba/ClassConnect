import 'package:ClassConnect/presentation/cubit/home/join_class/join_class_cubit.dart';
import 'package:ClassConnect/presentation/ui/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinClassDialog extends StatelessWidget {
  const JoinClassDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final JoinClassCubit joinClassCubit = context.watch<JoinClassCubit>();
    return BlocListener<JoinClassCubit, JoinClassState>(
      listener: (context, state) {
        if (state.isSuccess) {
          Navigator.pop(context);
        }
      },
      child: Dialog(
        insetPadding: EdgeInsets.zero,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          height: 270,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -100,
                child: Image.asset(
                  "assets/images/blackboard.png",
                  width: 160,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 76),
                    Text(
                      "Join Class",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: joinClassCubit.onClassIdChange,
                      decoration: const InputDecoration(
                        hintText: "Class code",
                        border: outlinedInputBorder,
                        prefixIcon: Icon(Icons.code),
                        suffixIcon: Tooltip(
                          triggerMode: TooltipTriggerMode.tap,
                          message: "Ask your teacher for the class code",
                          child: Icon(Icons.info_outline),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: joinClassCubit.state.classId.isNotEmpty && !joinClassCubit.state.isLoading ? joinClassCubit.joinClass : null,
                        child: const Text("join"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}