import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../providers/resolution_controller.dart';
import '../../providers/ticket_controller.dart';

class ResolutionScreen extends StatefulWidget {
  const ResolutionScreen({Key? key}) : super(key: key);

  @override
  State<ResolutionScreen> createState() => _ResolutionScreenState();
}

class _ResolutionScreenState extends State<ResolutionScreen> {
  final controller = Get.put(ResolutionController());
  final ticketC = Get.find<TicketController>();
  final notesC = TextEditingController();
  late int ticketId;

  @override
  void initState() {
    ticketId = Get.arguments['ticket_id'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Resolution Notes")),
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Resolution / Fix Applied"),
                const SizedBox(height: 8),
                TextField(
                  controller: notesC,
                  minLines: 3,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Explain how you resolved the ticket...",
                  ),
                ),
                const SizedBox(height: 22),
                ElevatedButton.icon(
                  icon: controller.isLoading.value
                      ? SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.check),
                  label: const Text("Mark as Resolved"),
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          final ok = await controller.addResolution(
                              ticketId, notesC.text.trim());
                          if (ok) {
                            Get.snackbar('Done', 'Ticket marked as resolved.');
                            ticketC.getTickets();
                            Get.back();
                          } else {
                            Get.snackbar('Failed', controller.error.value,
                                backgroundColor: Colors.red.shade100);
                          }
                        },
                ),
              ],
            ),
          )),
    );
  }
}
