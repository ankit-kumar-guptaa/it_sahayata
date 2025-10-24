import 'package:get/get.dart';
import '../models/message_model.dart';
import '../services/message_service.dart';

class MessageController extends GetxController {
  var isLoading = false.obs;
  var messages = <MessageModel>[].obs;
  var error = "".obs;
  int? _currentTicketId;

  // For optimistic UI
  bool isSending = false;

  // Get all messages for ticket
  Future<void> getMessages(int ticketId) async {
    isLoading.value = true;
    error.value = "";
    _currentTicketId = ticketId;
    final res = await MessageService.getMessages(ticketId);
    isLoading.value = false;
    if (res.data != null) {
      messages.value = res.data!;
    } else {
      error.value = res.error ?? res.message;
    }
  }

  // Send new message (text and/or file)
  Future<bool> sendMessage(String message, {String? fileUrl}) async {
    if (_currentTicketId == null) return false;
    isSending = true;
    final res = await MessageService.sendMessage(
      ticketId: _currentTicketId!,
      message: message,
      fileUrl: fileUrl,
    );
    isSending = false;
    if (res.data != null) {
      messages.add(res.data!);
      return true;
    } else {
      error.value = res.error ?? res.message;
      return false;
    }
  }

  // Upload attachment (image/pdf etc.)
  Future<String?> uploadFile(String path) async {
    isLoading.value = true;
    final res = await MessageService.uploadFile(path);
    isLoading.value = false;
    if (res.data != null) return res.data!;
    error.value = res.error ?? res.message;
    return null;
  }
}
