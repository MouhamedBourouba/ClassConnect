import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class AuthenticationScaffold extends StatelessWidget {
  const AuthenticationScaffold({Key? key, required this.body, this.topImageSize, this.hideWhenKeyboardAppears})
      : super(key: key);
  final Widget body;
  final double? topImageSize;
  final bool? hideWhenKeyboardAppears;

  @override
  Widget build(BuildContext context) {
    var isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: SvgPicture.asset(
                "assets/images/top.svg",
                width: isKeyboardOpen && (hideWhenKeyboardAppears == true) ? 0 : topImageSize,
              ),
            ),
            body,
          ],
        ),
      ),
    );
  }
}
