import 'dart:convert';
import 'package:http/http.dart' as http;
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
          body: jsonEncode(body),
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
    final file = await http.MultipartFile.fromPath(fieldName, filePath);
    request.files.add(file);
    request.headers.addAll(await _addAuthHeader(headers));
    if (fields != null) request.fields.addAll(fields);
    return await request.send();
  }

  // Helper to attach token if exists
  static Future<Map<String, String>> _addAuthHeader(
      Map<String, String>? headers) async {
    Map<String, String> head = {
      'Content-Type': 'application/json',
      ...?headers,
    };
    // Token storage logic - update as per your storage
    // Example (with GetStorage):
    // String? token = GetStorage().read(AppConfig.tokenKey);
    // if (token?.isNotEmpty ?? false) head['Authorization'] = 'Bearer $token';

    return head;
  }
}
