import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final IconData? prefixIcon;
  final bool isPassword;
  const CustomTextField({
    this.controller,
    this.hint,
    this.prefixIcon,
    this.isPassword = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        hintText: hint ?? '',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 13, horizontal: 14),
      ),
    );
  }
}
