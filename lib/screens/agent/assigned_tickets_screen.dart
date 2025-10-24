import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../providers/ticket_controller.dart';

class AssignedTicketsScreen extends StatelessWidget {
  const AssignedTicketsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ticketC = Get.find<TicketController>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Assigned Tickets")),
      body: Obx(() {
        final myTickets = ticketC.tickets;
        if (ticketC.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (myTickets.isEmpty) {
          return const Center(child: Text("No tickets assigned yet!"));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(18),
          itemCount: myTickets.length,
          itemBuilder: (context, i) {
            final t = myTickets[i];
            return Card(
              child: ListTile(
                leading: CircleAvatar(child: Text(t.category[0].toUpperCase())),
                title: Text(t.description,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                    "Status: ${t.status} • Priority: ${t.priority.toUpperCase()}"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.toNamed('/ticket-detail-agent',
                    arguments: {'ticket_id': t.id}),
              ),
            );
          },
        );
      }),
    );
  }
}
