import 'package:flutter/material.dart';

class MButton extends StatelessWidget {
  const MButton({super.key, required this.onClick, required this.title});

  final VoidCallback? onClick;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        backgroundColor: theme.colorScheme.secondary,
      ),
      onPressed: onClick,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          title,
          style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
