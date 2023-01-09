import 'package:flutter/material.dart';

const outlinedInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(100),
  ),
);
class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    this.initValue,
    required this.onChange,
  });

  final void Function(String value) onChange;
  final String? initValue;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initValue,
      decoration: InputDecoration(
        border: outlinedInputBorder,
        hintText: "password",
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      obscureText: !isPasswordVisible,
      onChanged: widget.onChange,
      validator: (value) {
        if (value == "" || value == null || value.length > 8) return null;
        return "Password is too short";
      },
    );
  }
}
