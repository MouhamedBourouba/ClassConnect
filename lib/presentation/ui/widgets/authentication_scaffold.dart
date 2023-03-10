import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthenticationScaffold extends StatelessWidget {
  const AuthenticationScaffold({super.key, required this.body, this.topImageSize, this.hideTopImageOnkeyboard});

  final Widget body;
  final double? topImageSize;
  final bool? hideTopImageOnkeyboard;

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return SafeArea(
      child: Scaffold(

        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: SvgPicture.asset(
                "assets/images/top.svg",
                width: isKeyboardOpen ? 0  : topImageSize ,
              ),
            ),
            body,
          ],
        ),
      ),
    );
  }
}
