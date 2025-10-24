import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final Widget? icon;
  const CustomButton({
    required this.label,
    this.onPressed,
    this.color,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon ?? const SizedBox.shrink(),
      onPressed: onPressed,
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
