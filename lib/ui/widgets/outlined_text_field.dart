import 'package:flutter/material.dart';

class OutlinedTextFiled extends StatelessWidget {
  const OutlinedTextFiled({
    Key? key,
    required this.hint,
    required this.prefixIcon,
    this.isTextShown,
    this.suffixIcon,
    required this.onValueChanged,
    this.inputType,
    this.padding,
    this.errorText,
    this.validator,
  }) : super(key: key);

  final String hint;
  final IconData prefixIcon;
  final bool? isTextShown;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final Function(String value) onValueChanged;
  final EdgeInsets? padding;
  final String? errorText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          errorText: errorText == "" ? null : errorText,
          hintText: hint,
        ),
        maxLines: 1,
        keyboardType: inputType,
        onChanged: onValueChanged,
        obscureText: isTextShown == false,
        validator: validator,
      ),
    );
  }
}
