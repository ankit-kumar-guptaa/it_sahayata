import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  // App wide state variables
  var isLoading = false.obs; // Login/register processing
  var isOtpSending = false.obs; // Sending, resending OTP
  var isLoggedIn = false.obs;
  var user = Rxn<UserModel>();
  var error = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  // Load user from local storage (if exists)
  void loadCurrentUser() {
    final current = StorageService.getUser();
    if (current != null) {
      user.value = current;
      isLoggedIn.value = true;
    }
  }

  // Handle login
  // Future<bool> login(String email, String password) async {
  //   isLoading.value = true;
  //   error.value = "";
  //   final res = await AuthService.login(email, password);
  //   isLoading.value = false;
  //   if (res.data != null) {
  //     user.value = res.data;
  //     isLoggedIn.value = true;
  //     return true;
  //   } else {
  //     error.value = res.error ?? res.message;
  //     return false;
  //   }
  // }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    error.value = "";
    final res = await AuthService.login(email, password);
    isLoading.value = false;
    if (res.data != null) {
      user.value = res.data;
      isLoggedIn.value = true;
      return true;
    } else {
      // FIX: always show a String
      final errorMsg = (res.error ?? res.message ?? "Login failed").toString();
      error.value = errorMsg;
      return false;
    }
  }

  // Handle registration
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    isLoading.value = true;
    error.value = "";
    final res = await AuthService.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
      role: role,
    );
    isLoading.value = false;
    if (res.status == 201 || res.message.contains('successful')) {
      return true;
    } else {
      error.value = res.error ?? res.message;
      return false;
    }
  }

  // OTP Verification
  Future<bool> verifyOtp(String email, String otp) async {
    isOtpSending.value = true;
    final res = await AuthService.verifyOtp(email, otp);
    isOtpSending.value = false;
    if (res.status == 200) {
      return true;
    } else {
      error.value = res.error ?? res.message;
      return false;
    }
  }

  // Resend OTP
  Future<bool> resendOtp(String email) async {
    isOtpSending.value = true;
    final res = await AuthService.resendOtp(email);
    isOtpSending.value = false;
    if (res.status == 200) {
      return true;
    } else {
      error.value = res.error ?? res.message;
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await AuthService.logout();
    user.value = null;
    isLoggedIn.value = false;
  }
}
