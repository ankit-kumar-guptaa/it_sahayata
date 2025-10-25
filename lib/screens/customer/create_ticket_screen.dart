import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/ticket_controller.dart';
import '../../services/message_service.dart';
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
  List<String> selectedFiles = [];
  bool isUploading = false;

  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx', 'txt'],
      );

      if (result != null) {
        setState(() => isUploading = true);

        for (var file in result.files) {
          if (file.path != null) {
            final uploadResult = await MessageService.uploadFile(file.path!, type: "ticket");
            if (uploadResult.status == 200 && uploadResult.data != null) {
              setState(() => selectedFiles.add(uploadResult.data!));
            } else {
              Get.snackbar('Upload Failed',
                  uploadResult.message ?? 'Failed to upload file',
                  backgroundColor: Colors.red.shade100);
            }
          }
        }

        setState(() => isUploading = false);
      }
    } catch (e) {
      setState(() => isUploading = false);
      Get.snackbar('Error', 'Failed to pick files: \$e',
          backgroundColor: Colors.red.shade100);
    }
  }

  void removeFile(int index) {
    setState(() => selectedFiles.removeAt(index));
  }

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
                const SizedBox(height: 18),

                // File Upload Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Attach Files (optional)"),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.attach_file),
                      label: isUploading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text("Choose Files"),
                      onPressed: isUploading ? null : pickFiles,
                    ),
                    const SizedBox(height: 8),
                    if (selectedFiles.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Selected Files:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...selectedFiles.asMap().entries.map((entry) {
                            final index = entry.key;
                            final fileUrl = entry.value;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.insert_drive_file),
                              title: Text(fileUrl.split('/').last),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => removeFile(index),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                  ],
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
                            selectedFiles.isNotEmpty ? selectedFiles : null,
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
