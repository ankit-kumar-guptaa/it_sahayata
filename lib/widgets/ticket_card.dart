import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../screens/common/status_badge.dart';

class TicketCard extends StatelessWidget {
  final TicketModel ticket;
  final VoidCallback? onTap;
  const TicketCard({required this.ticket, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(child: Text(ticket.category[0].toUpperCase())),
        title: Text(ticket.description,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category: ${ticket.category}"),
            Row(
              children: [
                StatusBadge(status: ticket.status),
                const SizedBox(width: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: ticket.priority == "high"
                        ? Colors.red.shade50
                        : ticket.priority == "medium"
                            ? Colors.orange.shade50
                            : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    ticket.priority.toUpperCase(),
                    style: TextStyle(
                        color: ticket.priority == "high"
                            ? Colors.red
                            : ticket.priority == "medium"
                                ? Colors.orange
                                : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
