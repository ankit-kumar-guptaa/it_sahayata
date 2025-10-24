import 'package:get_storage/get_storage.dart';
import '../config/app_config.dart';
import '../models/user_model.dart';

class StorageService {
  static final box = GetStorage();

  // Save token
  static Future<void> saveToken(String token) async =>
      await box.write(AppConfig.tokenKey, token);
  // Get token
  static String? getToken() => box.read(AppConfig.tokenKey);

  // Save user data
  static Future<void> saveUser(UserModel user) async =>
      await box.write(AppConfig.userKey, user.toJson());
  // Get current user
  static UserModel? getUser() {
    final data = box.read(AppConfig.userKey);
    return data != null
        ? UserModel.fromJson(Map<String, dynamic>.from(data))
        : null;
  }

  // Remove everything on logout
  static Future<void> clearAll() async => await box.erase();
}
