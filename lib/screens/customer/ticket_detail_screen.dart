import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../providers/ticket_controller.dart';
import '../common/status_badge.dart';
import 'chat_screen.dart';
import 'feedback_screen.dart';

class TicketDetailScreen extends StatelessWidget {
  const TicketDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ticketC = Get.find<TicketController>();
    final Map args = Get.arguments ?? {};
    final int ticketId = args['ticket_id'];

    return Scaffold(
      appBar: AppBar(title: const Text("Ticket Details")),
      body: FutureBuilder(
        future: ticketC.getTicketDetail(ticketId),
        builder: (context, snap) {
          final t = ticketC.selectedTicket.value;
          if (ticketC.detailLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (t == null) return const Center(child: Text("No data found"));

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: ListView(
              children: [
                Text("Subject",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(t.description, style: const TextStyle(fontSize: 17)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    StatusBadge(status: t.status),
                    const SizedBox(width: 16),
                    Chip(label: Text("Priority: ${t.priority}")),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.category, size: 18),
                    Text(" ${t.category}",
                        style: const TextStyle(fontSize: 15)),
                  ],
                ),
                if (t.agentName != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.person, size: 18),
                      Text(" Agent: ${t.agentName}"),
                    ],
                  ),
                ],
                const SizedBox(height: 18),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  leading: const Icon(Icons.date_range),
                  title: Text("Created"),
                  subtitle: Text("${t.createdAt}"),
                ),
                const Divider(height: 30),
                ElevatedButton.icon(
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text("Chat With Agent"),
                  onPressed: () => Get.to(() => const ChatScreen(),
                      arguments: {'ticket_id': ticketId}),
                ),
                if (["resolved", "closed"].contains(t.status.toLowerCase()))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.star, color: Colors.amber),
                      label: const Text("Submit Feedback"),
                      onPressed: () => Get.to(() => const FeedbackScreen(),
                          arguments: {'ticket_id': ticketId}),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
