import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../config/app_config.dart';
import '../config/theme.dart';
import '../providers/auth_controller.dart';
import '../config/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000), () async {
      final storage = GetStorage();
      final onboardingSeen = storage.read('onboarding_seen') == true;
      final authC = Get.find<AuthController>();

      // If user is already logged in
      if (authC.isLoggedIn.isTrue && authC.user.value != null) {
        if (authC.user.value!.role == "customer") {
          Get.offAllNamed(AppRoutes.customerHome);
        } else if (authC.user.value!.role == "agent") {
          Get.offAllNamed(AppRoutes.agentHome);
        } else {
          Get.offAllNamed(AppRoutes.login);
        }
        return;
      }

      // If onboarding is seen, go to login/register
      if (onboardingSeen) {
        Get.offAllNamed(AppRoutes.login);
      } else {
        // Else, show onboarding
        Get.offAllNamed(AppRoutes.onboarding);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/logo.png", height: 120),
            const SizedBox(height: 20),
            Text(AppConfig.appName,
                style: AppTextStyles.h2.copyWith(color: Colors.white)),
            const SizedBox(height: 8),
            Text(AppConfig.appTagline,
                style:
                    AppTextStyles.bodyMedium.copyWith(color: Colors.white70)),
            const SizedBox(height: 40),
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white)),
          ],
        ),
      ),
    );
  }
}
