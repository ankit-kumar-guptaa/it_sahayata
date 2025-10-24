import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/api_response.dart';
import '../models/ticket_model.dart';
import 'api_service.dart';

class TicketService {
  // Create Ticket (Customer)
  // static Future<ApiResponse<TicketModel?>> createTicket({
  //   required String category,
  //   required String description,
  //   required String priority,
  //   String? fileUrl,
  // }) async {
  //   try {
  //     final res = await ApiService.postRequest(
  //       AppConfig.createTicketEndpoint,
  //       body: {
  //         "category": category,
  //         "description": description,
  //         "priority": priority,
  //         if (fileUrl != null) "file_url": fileUrl,
  //       },
  //     );
  //     final json = jsonDecode(res.body);
  //     return ApiResponse<TicketModel?>.fromJson(
  //         json, (data) => data == null ? null : TicketModel.fromJson(data));
  //   } catch (e) {
  //     return ApiResponse<TicketModel?>(
  //         status: 500, message: "Network Error", error: e.toString());
  //   }
  // }

  static Future<ApiResponse<TicketModel?>> createTicket({
    required String category,
    required String description,
    required String priority,
    List<String>? fileUrls, // NOTE!
  }) async {
    try {
      final res = await ApiService.postRequest(
        AppConfig.createTicketEndpoint,
        body: {
          "category": category,
          "description": description,
          "priority": priority,
          if (fileUrls != null && fileUrls.isNotEmpty)
            "file_urls": fileUrls.join(','),
        },
      );
      final json = jsonDecode(res.body);
      return ApiResponse<TicketModel?>.fromJson(
        json,
        (data) => data == null ? null : TicketModel.fromJson(data),
      );
    } catch (e) {
      return ApiResponse<TicketModel?>(
          status: 500, message: "Network Error", error: e.toString());
    }
  }

  // List Tickets (role auto-detect: customer/agent/admin)
  static Future<ApiResponse<List<TicketModel>>> fetchTickets() async {
    try {
      final res = await ApiService.getRequest(AppConfig.listTicketsEndpoint);
      final json = jsonDecode(res.body);
      return ApiResponse<List<TicketModel>>.fromJson(
        json,
        (data) {
          if (data?['tickets'] != null && data['tickets'] is List) {
            return List<TicketModel>.from(
                data['tickets'].map((x) => TicketModel.fromJson(x)));
          }
          return <TicketModel>[];
        },
      );
    } catch (e) {
      return ApiResponse<List<TicketModel>>(
          status: 500, message: "Network Error", error: e.toString());
    }
  }

  // Single Ticket Detail (role based access allowed)
  static Future<ApiResponse<TicketModel?>> getTicketDetail(int ticketId) async {
    try {
      final url = "${AppConfig.ticketDetailEndpoint}?ticket_id=$ticketId";
      final res = await ApiService.getRequest(url);
      final json = jsonDecode(res.body);
      return ApiResponse<TicketModel?>.fromJson(
          json, (data) => data == null ? null : TicketModel.fromJson(data));
    } catch (e) {
      return ApiResponse<TicketModel?>(
          status: 500, message: "Network Error", error: e.toString());
    }
  }

  // Update Status (Agent/Admin)
  static Future<ApiResponse> updateStatus({
    required int ticketId,
    required String status,
  }) async {
    try {
      final res = await ApiService.putRequest(
        AppConfig.updateStatusEndpoint,
        body: {
          "ticket_id": ticketId,
          "status": status,
        },
      );
      final json = jsonDecode(res.body);
      return ApiResponse.fromJson(json, (data) => data);
    } catch (e) {
      return ApiResponse(
          status: 500, message: "Network Error", error: e.toString());
    }
  }

  // Agent assigned tickets (Agent only)
  static Future<ApiResponse<List<TicketModel>>> fetchAssignedTickets() async {
    try {
      final res =
          await ApiService.getRequest(AppConfig.assignedTicketsEndpoint);
      final json = jsonDecode(res.body);
      return ApiResponse<List<TicketModel>>.fromJson(
        json,
        (data) {
          if (data?['tickets'] != null && data['tickets'] is List) {
            return List<TicketModel>.from(
                data['tickets'].map((x) => TicketModel.fromJson(x)));
          }
          return <TicketModel>[];
        },
      );
    } catch (e) {
      return ApiResponse<List<TicketModel>>(
          status: 500, message: "Network Error", error: e.toString());
    }
  }
}
