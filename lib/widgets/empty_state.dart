import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String? message;
  final String? imageAsset;
  const EmptyState({this.message, this.imageAsset, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageAsset != null)
            Image.asset(imageAsset!, width: 110, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message ?? "Nothing found.",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
