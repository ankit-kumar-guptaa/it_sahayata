import 'dart:convert';
import '../config/app_config.dart';
import '../models/api_response.dart';
import '../models/feedback_model.dart';
import 'api_service.dart';

class FeedbackService {
  // Submit feedback (customer for resolved ticket)
  static Future<ApiResponse<FeedbackModel?>> submitFeedback({
    required int ticketId,
    required int rating,
    String? comment,
  }) async {
    try {
      final res = await ApiService.postRequest(
        AppConfig.submitFeedbackEndpoint,
        body: {
          "ticket_id": ticketId,
          "rating": rating,
          if (comment != null) "comment": comment,
        },
      );
      final json = jsonDecode(res.body);
      return ApiResponse<FeedbackModel?>.fromJson(
        json,
        (data) => data == null ? null : FeedbackModel.fromJson(data),
      );
    } catch (e) {
      return ApiResponse<FeedbackModel?>(
          status: 500, message: "Network Error", error: e.toString());
    }
  }
}
