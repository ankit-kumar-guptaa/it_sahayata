import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case "pending":
        color = Colors.orange;
        break;
      case "assigned":
        color = Colors.blue;
        break;
      case "in_progress":
        color = Colors.deepPurple;
        break;
      case "resolved":
        color = Colors.green;
        break;
      case "closed":
        color = Colors.grey;
        break;
      default:
        color = Colors.black38;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}
