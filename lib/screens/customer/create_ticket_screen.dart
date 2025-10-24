import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../providers/ticket_controller.dart';
import '../../config/app_config.dart';
import '../../config/theme.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({Key? key}) : super(key: key);

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final ticketC = Get.find<TicketController>();
  final descC = TextEditingController();
  String category = AppConfig.ticketCategories[0];
  String priority = AppConfig.priorityLevels[1];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Report a Problem")),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Category"),
                DropdownButton<String>(
                  value: category,
                  isExpanded: true,
                  items: AppConfig.ticketCategories
                      .map(
                        (e) =>
                            DropdownMenuItem<String>(value: e, child: Text(e)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => category = v ?? category),
                ),
                const SizedBox(height: 18),
                const Text("Describe the issue"),
                TextField(
                  controller: descC,
                  minLines: 3,
                  maxLines: 6,
                  decoration: const InputDecoration(
                      hintText: "Eg: Laptop not switching on...",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                const Text("Priority"),
                DropdownButton<String>(
                  value: priority,
                  isExpanded: true,
                  items: AppConfig.priorityLevels
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => priority = v ?? priority),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: ticketC.isLoading.value
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text("Submit Ticket"),
                  onPressed: ticketC.isLoading.value
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final result = await ticketC.createTicket(
                            category.toLowerCase(),
                            descC.text.trim(),
                            priority.toLowerCase(),
                          );
                          if (result) {
                            Get.back();
                            Get.snackbar(
                                'Submitted', "Your problem has been reported",
                                backgroundColor: Colors.green.shade100);
                            await ticketC.getTickets();
                          } else {
                            Get.snackbar(
                                'Failed',
                                ticketC.error.value.isNotEmpty
                                    ? ticketC.error.value
                                    : "Could not create ticket",
                                backgroundColor: Colors.red.shade100);
                          }
                        },
                ),
              ],
            )),
      ),
    );
  }
}
