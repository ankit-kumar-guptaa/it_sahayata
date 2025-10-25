import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart'; // <-- ADD THIS!
import '../config/app_config.dart';

class ApiService {
  // GET request
  static Future<http.Response> getRequest(String url,
      {Map<String, String>? headers}) async {
    var finalHeaders = await _addAuthHeader(headers);
    return await http
        .get(Uri.parse(url), headers: finalHeaders)
        .timeout(AppConfig.timeoutDuration);
  }

  // POST request
  static Future<http.Response> postRequest(String url,
      {Map<String, String>? headers, dynamic body}) async {
    var finalHeaders = await _addAuthHeader(headers);
    return await http
        .post(
          Uri.parse(url),
          headers: finalHeaders,
          body: (finalHeaders['Content-Type'] == 'application/json')
              ? jsonEncode(body)
              : body, // Handles form-data for file uploads etc.
        )
        .timeout(AppConfig.timeoutDuration);
  }

  // PUT request
  static Future<http.Response> putRequest(String url,
      {Map<String, String>? headers, dynamic body}) async {
    var finalHeaders = await _addAuthHeader(headers);
    return await http
        .put(
          Uri.parse(url),
          headers: finalHeaders,
          body: jsonEncode(body),
        )
        .timeout(AppConfig.timeoutDuration);
  }

  // DELETE request
  static Future<http.Response> deleteRequest(String url,
      {Map<String, String>? headers}) async {
    var finalHeaders = await _addAuthHeader(headers);
    return await http
        .delete(Uri.parse(url), headers: finalHeaders)
        .timeout(AppConfig.timeoutDuration);
  }

  // FOR FILE UPLOAD (multi-part)
  static Future<http.StreamedResponse> uploadFile(String url,
      {required String filePath,
      String fieldName = 'file',
      Map<String, String>? headers,
      Map<String, String>? fields}) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    
    // Add the file with the correct field name 'file' as expected by PHP API
    final file = await http.MultipartFile.fromPath('file', filePath);
    request.files.add(file);
    
    // For file uploads, we need to use the auth header without setting Content-Type
    // as multipart requests set their own content type with boundary
    var authHeaders = await _getAuthHeadersWithoutContentType(headers);
    request.headers.addAll(authHeaders);
    
    // Add any additional fields (like 'type' parameter)
    if (fields != null) request.fields.addAll(fields);
    
    return await request.send();
  }

  // Get auth headers without Content-Type for multipart requests
  static Future<Map<String, String>> _getAuthHeadersWithoutContentType(
      Map<String, String>? headers) async {
    Map<String, String> head = {...?headers};
    // Get token from storage
    final box = GetStorage();
    var token = box.read(AppConfig.tokenKey);
    if (token != null && token.toString().isNotEmpty) {
      head['Authorization'] = 'Bearer $token';
    }
    return head;
  }

  // THIS IS THE FIXED PART: always ATTACH TOKEN from GetStorage
  static Future<Map<String, String>> _addAuthHeader(
      Map<String, String>? headers) async {
    Map<String, String> head = {
      'Content-Type': 'application/json',
      ...?headers,
    };
    // The fixed, production code:
    final box = GetStorage();
    var token = box.read(AppConfig.tokenKey);
    if (token != null && token.toString().isNotEmpty) {
      head['Authorization'] = 'Bearer $token';
    }
    return head;
  }
}
