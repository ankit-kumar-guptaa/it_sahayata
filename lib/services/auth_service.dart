import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/api_response.dart';
import '../models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  // Login
  static Future<ApiResponse<UserModel?>> login(
      String email, String password) async {
    try {
      final res = await ApiService.postRequest(AppConfig.loginEndpoint,
          body: {"email": email, "password": password});
      final json = jsonDecode(res.body);
      if (res.statusCode == 200 && json['data'] != null) {
        // Save token/user locally
        await StorageService.saveToken(json['data']['token']);
        await StorageService.saveUser(UserModel.fromJson(json['data']['user']));
        return ApiResponse<UserModel?>.fromJson(
            json, (data) => UserModel.fromJson(data['user']));
      } else {
        return ApiResponse<UserModel?>(
            status: res.statusCode,
            message: json['message'] ?? "Login Failed",
            error: json['error']);
      }
    } catch (e) {
      return ApiResponse<UserModel?>(
          status: 500, message: "Network Error", error: e.toString());
    }
  }

  // Register
  static Future<ApiResponse> register(
      {required String name,
      required String email,
      required String phone,
      required String password,
      required String role}) async {
    try {
      final res = await ApiService.postRequest(AppConfig.registerEndpoint,
          body: {
            "name": name,
            "email": email,
            "phone": phone,
            "password": password,
            "role": role
          });
      final json = jsonDecode(res.body);
      return ApiResponse.fromJson(json, (data) => data);
    } catch (e) {
      return ApiResponse(
          status: 500, message: "Network Error", error: e.toString());
    }
  }

  // Verify OTP
  static Future<ApiResponse> verifyOtp(String email, String otp) async {
    try {
      final res =
          await ApiService.postRequest(AppConfig.verifyOtpEndpoint, body: {
        "email": email,
        "otp": otp,
      });
      final json = jsonDecode(res.body);
      return ApiResponse.fromJson(json, (data) => data);
    } catch (e) {
      return ApiResponse(
          status: 500, message: "Network Error", error: e.toString());
    }
  }

  // Resend OTP
  static Future<ApiResponse> resendOtp(String email) async {
    try {
      final res =
          await ApiService.postRequest(AppConfig.resendOtpEndpoint, body: {
        "email": email,
      });
      final json = jsonDecode(res.body);
      return ApiResponse.fromJson(json, (data) => data);
    } catch (e) {
      return ApiResponse(
          status: 500, message: "Network Error", error: e.toString());
    }
  }

  // Logout
  static Future<ApiResponse> logout() async {
    try {
      final res = await ApiService.postRequest(AppConfig.logoutEndpoint);
      final json = jsonDecode(res.body);
      await StorageService.clearAll();
      return ApiResponse.fromJson(json, (data) => data);
    } catch (e) {
      return ApiResponse(
          status: 500, message: "Network Error", error: e.toString());
    }
  }
}
