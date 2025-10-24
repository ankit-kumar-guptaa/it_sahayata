import 'dart:convert';
import '../config/app_config.dart';
import '../models/api_response.dart';
import 'api_service.dart';

class ResolutionService {
  static Future<ApiResponse> addResolution({
    required int ticketId,
    required String resolution,
  }) async {
    try {
      final res = await ApiService.postRequest(
        AppConfig.updateResolutionEndpoint,
        body: {"ticket_id": ticketId, "resolution": resolution},
      );
      final json = jsonDecode(res.body);
      return ApiResponse.fromJson(json, (data) => data);
    } catch (e) {
      return ApiResponse(
          status: 500, message: "Network Error", error: e.toString());
    }
  }
}
