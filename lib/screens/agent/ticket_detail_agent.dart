import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../providers/ticket_controller.dart';
import '../../providers/resolution_controller.dart';
import '../../screens/common/status_badge.dart';
import '../customer/chat_screen.dart';
import 'resolution_screen.dart';

class TicketDetailAgent extends StatelessWidget {
  const TicketDetailAgent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ticketC = Get.find<TicketController>();
    final resolutionC = Get.put(ResolutionController());
    final ticketId = Get.arguments['ticket_id'];

    return Scaffold(
      appBar: AppBar(title: const Text("Ticket Details (Agent)")),
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
                    const SizedBox(width: 14),
                    Chip(label: Text("Priority: ${t.priority}")),
                  ],
                ),
                const SizedBox(height: 10),
                Text("Category: ${t.category}"),
                const SizedBox(height: 10),
                Text("Customer: ${t.customerId}"),
                const SizedBox(height: 10),
                Text("Created: ${t.createdAt}"),
                const Divider(height: 30),
                ElevatedButton.icon(
                  icon: const Icon(Icons.chat),
                  label: const Text("Chat With Customer"),
                  onPressed: () => Get.to(() => const ChatScreen(),
                      arguments: {'ticket_id': ticketId}),
                ),
                if (!["resolved", "closed"].contains(t.status.toLowerCase()))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit, color: Colors.deepOrange),
                      label: Text("Mark as Resolved"),
                      onPressed: () => Get.to(() => ResolutionScreen(),
                          arguments: {'ticket_id': ticketId}),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
