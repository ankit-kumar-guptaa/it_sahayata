import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/routes.dart';
import '../../providers/auth_controller.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);
  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final authC = Get.find<AuthController>();
  final otpC = TextEditingController();
  late String email;

  @override
  void initState() {
    super.initState();
    email = Get.arguments['email'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Verification code sent to",
                    style: TextStyle(color: Colors.grey.shade600)),
                Text(email, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),
                TextField(
                  controller: otpC,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Enter 6-digit OTP",
                    counterText: "",
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: authC.isOtpSending.value
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final ok =
                              await authC.verifyOtp(email, otpC.text.trim());
                          if (ok) {
                            Get.snackbar('Verified!',
                                "Your email is now verified! Please login.",
                                backgroundColor: Colors.green.shade100,
                                colorText: Colors.green.shade900);
                            Get.offAllNamed(AppRoutes.login);
                          } else {
                            Get.snackbar(
                                'Verification Failed', authC.error.value,
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.red.shade900);
                          }
                        },
                  child: authC.isOtpSending.value
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Text('Verify'),
                ),
                TextButton(
                  onPressed: authC.isOtpSending.value
                      ? null
                      : () async {
                          final ok = await authC.resendOtp(email);
                          if (ok) {
                            Get.snackbar('OTP Sent', "OTP resent to your email",
                                backgroundColor: Colors.green.shade100,
                                colorText: Colors.green.shade900);
                          } else {
                            Get.snackbar('Failed', authC.error.value,
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.red.shade900);
                          }
                        },
                  child: const Text("Resend OTP"),
                )
              ],
            )),
      ),
    );
  }
}
