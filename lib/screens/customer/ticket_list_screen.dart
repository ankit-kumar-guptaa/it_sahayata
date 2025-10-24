import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../providers/ticket_controller.dart';
import '../../config/app_config.dart';

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ticketC = Get.find<TicketController>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Tickets")),
      body: Obx(() {
        if (ticketC.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ticketC.tickets.isEmpty) {
          return const Center(child: Text("No tickets found!"));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (c, i) => const SizedBox(height: 12),
          itemCount: ticketC.tickets.length,
          itemBuilder: (context, i) {
            final ticket = ticketC.tickets[i];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                    child: Text('${ticket.category[0].toUpperCase()}')),
                title: Text(ticket.description,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Category: ${ticket.category}"),
                    Text("Status: ${ticket.status}"),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Get.toNamed('/ticket-detail',
                    arguments: {'ticket_id': ticket.id}),
              ),
            );
          },
        );
      }),
    );
  }
}
