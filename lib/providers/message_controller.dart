import 'package:get/get.dart';
import '../models/message_model.dart';
import '../services/message_service.dart';

class MessageController extends GetxController {
  var isLoading = false.obs;
  var messages = <MessageModel>[].obs;
  var error = "".obs;
  int? _currentTicketId;

  // For optimistic UI
  var isSending = false.obs;

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

  // Send new message (text and/or file) with optimistic UI
  Future<bool> sendMessage(String message, {String? fileUrl}) async {
    if (_currentTicketId == null) return false;
    
    // Create temporary message for optimistic UI
    final tempMessage = MessageModel(
      id: -1, // Temporary ID
      ticketId: _currentTicketId!,
      senderId: 0, // Will be updated by server
      message: message,
      fileUrl: fileUrl,
      isRead: false,
      senderName: "You", // Temporary name
      senderRole: "customer", // Temporary role
      timestamp: DateTime.now(),
    );
    
    // Add temporary message immediately for optimistic UI
    messages.add(tempMessage);
    isSending.value = true;
    
    try {
      final res = await MessageService.sendMessage(
        ticketId: _currentTicketId!,
        message: message,
        fileUrl: fileUrl,
      );
      
      isSending.value = false;
      
      if (res.data != null) {
        // Replace temporary message with actual message from server
        final index = messages.indexWhere((m) => m.id == -1 && m.message == message);
        if (index != -1) {
          messages[index] = res.data!;
        } else {
          messages.add(res.data!);
        }
        return true;
      } else {
        // Keep the temporary message if server response is null
        // Don't remove it so user can see what they sent
        error.value = res.error ?? res.message ?? "Failed to send message";
        
        // Update temporary message to show it's not delivered
        final index = messages.indexWhere((m) => m.id == -1 && m.message == message);
        if (index != -1) {
          final updatedMessage = MessageModel(
            id: -2, // Failed message ID
            ticketId: _currentTicketId!,
            senderId: 0,
            message: message,
            fileUrl: fileUrl,
            isRead: false,
            senderName: "You",
            senderRole: "customer",
            timestamp: DateTime.now(),
          );
          messages[index] = updatedMessage;
        }
        return false;
      }
    } catch (e) {
      isSending.value = false;
      // Don't remove the temporary message on network error
      // So user can see what they tried to send
      error.value = "Network error: ${e.toString()}";
      
      // Update temporary message to show network error
      final index = messages.indexWhere((m) => m.id == -1 && m.message == message);
      if (index != -1) {
        final updatedMessage = MessageModel(
          id: -3, // Network error message ID
          ticketId: _currentTicketId!,
          senderId: 0,
          message: message,
          fileUrl: fileUrl,
          isRead: false,
          senderName: "You",
          senderRole: "customer",
          timestamp: DateTime.now(),
        );
        messages[index] = updatedMessage;
      }
      return false;
    }
  }

  // Upload attachment (image/pdf etc.)
  Future<String?> uploadFile(String path) async {
    isLoading.value = true;
    error.value = "";
    final res = await MessageService.uploadFile(path);
    isLoading.value = false;
    if (res.data != null) return res.data!;
    error.value = res.error ?? res.message ?? "File upload failed";
    return null;
  }
}
