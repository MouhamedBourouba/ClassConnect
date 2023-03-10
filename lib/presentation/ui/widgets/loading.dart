import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key, this.loadingText});

  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 100),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(loadingText == null ? "Loading ..." : loadingText!),
          ],
        ),
      ),
    );
  }
}

void showLoading(BuildContext context, [String? loadingText]) {
  showDialog(
    context: context,
    builder: (ctx) => LoadingDialog(loadingText: loadingText),
    barrierDismissible: false,
  );
}

void hideLoading(BuildContext context) {
  if (ModalRoute.of(context)?.isCurrent != true) {
    Navigator.pop(context);
  }
}
