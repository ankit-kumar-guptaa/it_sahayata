import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
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
  String? _selectedAttachmentUrl; // Track the uploaded file URL
  String? _selectedFileName; // Track the selected file name

  @override
  void initState() {
    super.initState();
    ticketId = Get.arguments['ticket_id'];
    messageController.getMessages(ticketId);
    
    // Listen for message changes to auto-scroll
    ever(messageController.messages, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    msgC.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage({String? fileUrl}) async {
    // Use selected attachment if no fileUrl provided
    final finalFileUrl = fileUrl ?? _selectedAttachmentUrl;
    if (msgC.text.trim().isEmpty && (finalFileUrl == null || finalFileUrl.isEmpty)) {
      return;
    }
    
    final sent = await messageController.sendMessage(
      msgC.text.trim(),
      fileUrl: finalFileUrl,
    );
    
    if (sent) {
      msgC.clear();
      focusNode.requestFocus();
      // Clear selected attachment after successful send
      setState(() {
        _selectedAttachmentUrl = null;
        _selectedFileName = null;
      });
      // Auto-scroll to bottom when new message is added
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      if (messageController.error.value.isNotEmpty) {
        Get.snackbar(
          'Failed',
          messageController.error.value,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  bool _isDifferentDay(DateTime date1, DateTime date2) {
    return date1.year != date2.year ||
        date1.month != date2.month ||
        date1.day != date2.day;
  }

  Widget _buildDateSeparator(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    String dateText;
    if (messageDate == today) {
      dateText = 'Today';
    } else if (messageDate == yesterday) {
      dateText = 'Yesterday';
    } else {
      dateText = DateFormat('MMM dd, yyyy').format(timestamp);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              dateText,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String myRole = authC.user.value?.role ?? "";
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Support Chat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor.withOpacity(0.05),
              theme.primaryColor.withOpacity(0.02),
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Obx(() {
          if (messageController.isLoading.value &&
              messageController.messages.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Loading messages...",
                    style: TextStyle(color: theme.primaryColor),
                  ),
                ],
              ),
            );
          }
          
          final messages = messageController.messages;
          
          return Column(
            children: [
              // Chat header with ticket info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.support_agent, color: theme.primaryColor, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Ticket #$ticketId - Live Support",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Messages list
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat,
                              size: 48,
                              color: theme.primaryColor.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Start the conversation!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Send a message to get support",
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        reverse: false,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        itemCount: messages.length,
                        itemBuilder: (c, i) {
                          final m = messages[i];
                          final isMe = m.senderRole == myRole;
                          
                          // Show date separator if needed
                          if (i == 0 || _isDifferentDay(messages[i - 1].timestamp, m.timestamp)) {
                            return Column(
                              children: [
                                _buildDateSeparator(m.timestamp),
                                _messageBubble(
                                  content: m.message,
                                  fileUrl: m.fileUrl,
                                  isMe: isMe,
                                  isRead: m.isRead,
                                  timestamp: m.timestamp,
                                  messageId: m.id,
                                ),
                              ],
                            );
                          }
                          
                          return _messageBubble(
                            content: m.message,
                            fileUrl: m.fileUrl,
                            isMe: isMe,
                            isRead: m.isRead,
                            timestamp: m.timestamp,
                            messageId: m.id,
                          );
                        },
                      ),
              ),
              
              // Show selected attachment with delete option
              if (_selectedAttachmentUrl != null && _selectedFileName != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.primaryColor.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.attach_file, size: 18, color: theme.primaryColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedFileName!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 18, color: Colors.grey.shade600),
                        onPressed: () {
                          setState(() {
                            _selectedAttachmentUrl = null;
                            _selectedFileName = null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              
              // Message input area
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Obx(() {
                      if (messageController.isLoading.value && isAttaching) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      return IconButton(
                        icon: Icon(Icons.attach_file, color: Colors.grey.shade600),
                        onPressed: () async {
                          setState(() => isAttaching = true);
                          try {
                            final result = await FilePicker.platform.pickFiles(
                              allowMultiple: false,
                              type: FileType.custom,
                              allowedExtensions: [
                                'jpg',
                                'jpeg',
                                'png',
                                'gif',
                                'bmp',
                                'webp',
                                'pdf',
                                'doc',
                                'docx',
                                'txt',
                                'zip',
                                'rar'
                              ],
                              dialogTitle: 'Select File to Upload',
                              lockParentWindow: true,
                            );
                            
                            if (result != null &&
                                result.files.isNotEmpty &&
                                result.files.first.path != null) {
                              final file = result.files.first;
                              
                              // Validate file size (max 10MB)
                              if (file.size > 10 * 1024 * 1024) {
                                Get.snackbar(
                                  'File Too Large',
                                  'Maximum file size is 10MB',
                                  backgroundColor: Colors.orange.shade100,
                                  colorText: Colors.orange.shade900,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                                return;
                              }
                              
                              final uploadResp = await messageController.uploadFile(file.path!);
                              if (uploadResp != null && uploadResp.isNotEmpty) {
                                setState(() {
                                  _selectedAttachmentUrl = uploadResp;
                                  _selectedFileName = file.name;
                                });
                                Get.snackbar(
                                  'Success',
                                  'File uploaded successfully!',
                                  backgroundColor: Colors.green.shade100,
                                  colorText: Colors.green.shade900,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } else {
                                Get.snackbar(
                                  'Upload Failed',
                                  messageController.error.value.isNotEmpty
                                      ? messageController.error.value
                                      : 'Failed to upload file',
                                  backgroundColor: Colors.red.shade100,
                                  colorText: Colors.red.shade900,
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            }
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Failed to pick file: $e',
                              backgroundColor: Colors.red.shade100,
                              colorText: Colors.red.shade900,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } finally {
                            setState(() => isAttaching = false);
                          }
                        },
                      );
                    }),
                    const SizedBox(width: 4),
                    Expanded(
                      child: TextField(
                        controller: msgC,
                        focusNode: focusNode,
                        enabled: !messageController.isLoading.value,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                        style: const TextStyle(fontSize: 15),
                        onSubmitted: (_) async {
                          await _sendMessage();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Obx(() {
                      final isSending = messageController.isSending.value;
                      if (isSending) {
                        return const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        );
                      }
                      return Container(
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withOpacity(0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white),
                          iconSize: 22,
                          onPressed: messageController.isLoading.value
                              ? null
                              : () async {
                                  await _sendMessage();
                                },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _messageBubble({
    required String content,
    String? fileUrl,
    required bool isMe,
    required bool isRead,
    required DateTime timestamp,
    required int messageId,
  }) {
    final bool isImage = fileUrl != null &&
        (fileUrl.endsWith('.jpg') ||
            fileUrl.endsWith('.png') ||
            fileUrl.endsWith('.jpeg') ||
            fileUrl.endsWith('.gif') ||
            fileUrl.endsWith('.webp') ||
            fileUrl.endsWith('.bmp'));
    final bool isFile = fileUrl != null && !isImage && fileUrl.isNotEmpty;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(4),
            bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: !isMe ? Border.all(color: Colors.grey.shade200) : null,
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isImage)
              GestureDetector(
                onTap: () {
                  if (fileUrl != null) {
                    Get.dialog(
                      Dialog(
                        child: Image.network(fileUrl, fit: BoxFit.contain),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      fileUrl ?? '',
                      width: 200,
                      height: 150,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.grey.shade500,
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Failed to load',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            
            if (isFile)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isMe
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.attach_file,
                      size: 18,
                      color: isMe ? Colors.white70 : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        fileUrl?.split('/').last ?? 'File',
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            
            if (content.isNotEmpty)
              Text(
                content,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
            
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm').format(timestamp),
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.grey.shade500,
                    fontSize: 11,
                  ),
                ),
                if (isMe)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Icon(
                      isRead ? Icons.done_all : Icons.done,
                      size: 14,
                      color: isRead ? Colors.white70 : Colors.white54,
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
