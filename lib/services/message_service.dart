import 'dart:convert';
import '../config/app_config.dart';
import '../models/api_response.dart';
import '../models/message_model.dart';
import 'api_service.dart';
import 'package:http/http.dart' as http;

class MessageService {
  // Send chat message (text + optional file)
  static Future<ApiResponse<MessageModel?>> sendMessage({
    required int ticketId,
    required String message,
    String? fileUrl,
  }) async {
    try {
      final res = await ApiService.postRequest(
        AppConfig.sendMessageEndpoint,
        body: {
          "ticket_id": ticketId,
          "message": message,
          if (fileUrl != null && fileUrl.isNotEmpty) "file_url": fileUrl,
        },
      );
      final json = jsonDecode(res.body);
      return ApiResponse<MessageModel?>.fromJson(
          json, (data) => data == null ? null : MessageModel.fromJson(data));
    } catch (e) {
      return ApiResponse<MessageModel?>(
          status: 500, message: "Network Error", error: e.toString());
    }
  }

  // Get all messages for a ticket (chat)
  static Future<ApiResponse<List<MessageModel>>> getMessages(
      int ticketId) async {
    try {
      final url = "${AppConfig.getMessagesEndpoint}?ticket_id=$ticketId";
      final res = await ApiService.getRequest(url);
      final json = jsonDecode(res.body);
      return ApiResponse<List<MessageModel>>.fromJson(json, (data) {
        if (data?['messages'] != null && data['messages'] is List) {
          return List<MessageModel>.from(
              data['messages'].map((x) => MessageModel.fromJson(x)));
        }
        return <MessageModel>[];
      });
    } catch (e) {
      return ApiResponse<List<MessageModel>>(
          status: 500, message: "Network Error", error: e.toString());
    }
  }

  // Upload file (image, pdf etc.)
  static Future<ApiResponse<String?>> uploadFile(
    String filePath, {
    String type = "chat",
  }) async {
    try {
      final resp = await ApiService.uploadFile(
        AppConfig.uploadFileEndpoint,
        filePath: filePath,
        fields: {'type': type},
      );
      final res = await http.Response.fromStream(resp);
      final responseBody = res.body;
      
      // Debug logging
      print('File upload response status: ${res.statusCode}');
      print('File upload response body: $responseBody');
      
      final json = jsonDecode(responseBody);
      
      if (res.statusCode == 200) {
        // Handle different response formats
        final fileUrl = json['data']?['file_url'] ?? json['file_url'];
        if (fileUrl != null && fileUrl is String) {
          return ApiResponse<String?>(
            status: 200,
            message: json['message'] ?? 'File uploaded successfully',
            data: fileUrl,
          );
        }
      }
      
      return ApiResponse<String?>(
          status: res.statusCode,
          message: json['message'] ?? 'Upload failed',
          error: json['error'] ?? 'Unknown error');
    } catch (e) {
      print('File upload error: $e');
      return ApiResponse<String?>(
          status: 500, 
          message: "Network Error", 
          error: e.toString());
    }
  }
}
