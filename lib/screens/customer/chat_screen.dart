import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../providers/message_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final int ticketId;
  final msgC = TextEditingController();
  final messageController = Get.put(MessageController());

  @override
  void initState() {
    ticketId = Get.arguments['ticket_id'];
    super.initState();
    messageController.getMessages(ticketId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ticket Chat"),
      ),
      body: Obx(() {
        if (messageController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: false,
                itemCount: messageController.messages.length,
                itemBuilder: (c, i) {
                  final m = messageController.messages[i];
                  final isMe = m.senderRole == "customer";
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 12),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color:
                            isMe ? Colors.blue.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(m.message),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: msgC,
                      decoration: const InputDecoration(
                          hintText: "Type your message...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8)),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.blue,
                    onPressed: () async {
                      if (msgC.text.trim().isEmpty) return;
                      final sent =
                          await messageController.sendMessage(msgC.text.trim());
                      if (sent) msgC.clear();
                    },
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
