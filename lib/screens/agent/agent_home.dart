import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../providers/ticket_controller.dart';
import '../../providers/auth_controller.dart';
import 'assigned_tickets_screen.dart';
import '../../screens/common/settings_screen.dart';
import '../../config/routes.dart';

class AgentHome extends StatelessWidget {
  const AgentHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final ticketC = Get.find<
        TicketController>(); // <== Use Get.find to avoid double instantiation

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agent Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.to(() => const SettingsScreen()),
          ),
        ],
      ),
      backgroundColor: Colors.blue.shade50,
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                Text(
                  "Hello, ${authC.user.value?.name ?? 'Agent'} 👋",
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _agentStatCard(
                      "Assigned",
                      ticketC.tickets
                          .where((t) => t.status == "assigned")
                          .length,
                      Colors.orange,
                    ),
                    const SizedBox(width: 14),
                    _agentStatCard(
                      "Active",
                      ticketC.tickets
                          .where((t) => t.status == "in_progress")
                          .length,
                      Colors.blue,
                    ),
                    const SizedBox(width: 14),
                    _agentStatCard(
                      "Resolved",
                      ticketC.tickets
                          .where((t) =>
                              t.status == "resolved" || t.status == "closed")
                          .length,
                      Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  icon: const Icon(Icons.assignment_turned_in),
                  label: const Text("My Tickets"),
                  onPressed: () => Get.to(() => const AssignedTicketsScreen()),
                ),
                const SizedBox(height: 22),
                Text("High Priority",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                ...ticketC.tickets
                    .where((t) => t.priority.toLowerCase() == "high")
                    .take(2)
                    .map((t) => ListTile(
                          leading: const Icon(Icons.bolt, color: Colors.red),
                          title: Text('Ticket #${t.id}: ${t.category}'),
                          subtitle: Text(
                            t.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () => Get.toNamed(
                            AppRoutes.ticketDetailAgent,
                            arguments: {'ticket_id': t.id},
                          ),
                        ))
                    .toList(),
              ],
            ),
          )),
    );
  }

  Widget _agentStatCard(String label, int value, Color color) {
    return Expanded(
      child: Card(
        color: color.withOpacity(0.13),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text("$value",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30, color: color)),
              Text(label, style: TextStyle(color: color, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
