import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 100),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Creating Account"),
          ],
        ),
      ),
    );
  }
}

void showLoading(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => const LoadingDialog(),
    barrierDismissible: false,
  );
}

void hideLoading(BuildContext context) {
  if (ModalRoute.of(context)?.isCurrent != true) {
    Navigator.pop(context);
  }
}
