import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../providers/message_controller.dart';
import '../../providers/auth_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final int ticketId;
  final msgC = TextEditingController();
  final messageController = Get.put(MessageController());
  final authC = Get.find<AuthController>();
  final scrollController = ScrollController();
  final focusNode = FocusNode();

  bool isAttaching = false; // For file loader spinner

  @override
  void initState() {
    super.initState();
    ticketId = Get.arguments['ticket_id'];
    messageController.getMessages(ticketId);
  }

  Future<void> _sendMessage({String? fileUrl}) async {
    if (msgC.text.trim().isEmpty && (fileUrl == null || fileUrl.isEmpty))
      return;
    setState(() {});
    final sent = await messageController.sendMessage(
      msgC.text.trim(),
      fileUrl: fileUrl,
    );
    if (sent) {
      msgC.clear();
      focusNode.requestFocus();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    } else {
      if (messageController.error.value.isNotEmpty) {
        Get.snackbar('Failed', messageController.error.value,
            backgroundColor: Colors.red.shade100,
            colorText: Colors.red.shade900);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String myRole = authC.user.value?.role ?? "";
    return Scaffold(
      appBar: AppBar(title: const Text("Ticket Chat")),
      body: Obx(() {
        if (messageController.isLoading.value &&
            messageController.messages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        final messages = messageController.messages;
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                reverse: false,
                itemCount: messages.length,
                itemBuilder: (c, i) {
                  final m = messages[i];
                  final isMe = m.senderRole == myRole;
                  return _messageBubble(
                    content: m.message,
                    fileUrl: m.fileUrl,
                    isMe: isMe,
                    isRead: m.isRead,
                  );
                },
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
                child: Row(
                  children: [
                    isAttaching
                        ? const SizedBox(
                            width: 35,
                            height: 35,
                            child: CircularProgressIndicator(strokeWidth: 2))
                        : IconButton(
                            icon: const Icon(Icons.attach_file),
                            onPressed: () async {
                              setState(() => isAttaching = true);
                              final result =
                                  await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type: FileType.image,
                              );
                              setState(() => isAttaching = false);

                              if (result != null &&
                                  result.files.isNotEmpty &&
                                  result.files.first.path != null) {
                                final uploadResp = await messageController
                                    .uploadFile(result.files.first.path!);
                                if (uploadResp != null &&
                                    uploadResp.isNotEmpty) {
                                  await _sendMessage(fileUrl: uploadResp);
                                } else {
                                  // upload error is shown by controller
                                }
                              }
                            },
                          ),
                    Expanded(
                      child: TextField(
                        controller: msgC,
                        focusNode: focusNode,
                        enabled: !messageController.isLoading.value,
                        decoration: const InputDecoration(
                          hintText: "Type your message...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onSubmitted: (_) async {
                          await _sendMessage();
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.blue,
                      onPressed: messageController.isLoading.value
                          ? null
                          : () async {
                              await _sendMessage();
                              // Optionally auto-scroll to latest
                            },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _messageBubble({
    required String content,
    String? fileUrl,
    required bool isMe,
    required bool isRead,
  }) {
    final bool isImage = fileUrl != null &&
        (fileUrl.endsWith('.jpg') ||
            fileUrl.endsWith('.png') ||
            fileUrl.endsWith('.jpeg'));
    final bool isFile = fileUrl != null && !isImage && fileUrl.isNotEmpty;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isImage)
              GestureDetector(
                onTap: () {
                  if (fileUrl != null) {
                    Get.dialog(Dialog(
                      child: Image.network(fileUrl, fit: BoxFit.contain),
                    ));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.network(
                      fileUrl ?? '',
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, o, s) => Container(
                        width: 140,
                        height: 80,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),
                ),
              ),
            if (isFile)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.file_present,
                      color: Colors.grey.shade700, size: 20),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => Get.snackbar('File', fileUrl ?? ''),
                    child: Text(
                      fileUrl?.split('/').last ?? '',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            if (content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(content,
                    style:
                        const TextStyle(fontSize: 15, color: Colors.black87)),
              ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isMe)
                  Padding(
                    padding: const EdgeInsets.only(left: 3, top: 4),
                    child: Icon(
                      isRead ? Icons.done_all : Icons.check,
                      size: 17,
                      color: isRead ? Colors.blue : Colors.grey,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
