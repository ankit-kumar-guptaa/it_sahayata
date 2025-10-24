import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/app_config.dart';
import '../config/theme.dart';
import '../providers/auth_controller.dart';
import '../config/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Auth check on launch (small delay for splash effect)
    Future.delayed(const Duration(milliseconds: 1500), () {
      final authC = Get.find<AuthController>();
      if (authC.isLoggedIn.isTrue && authC.user.value != null) {
        // Customer or Agent home screen
        if (authC.user.value!.role == "customer") {
          Get.offAllNamed(AppRoutes.customerHome);
        } else if (authC.user.value!.role == "agent") {
          Get.offAllNamed(AppRoutes.agentHome);
        } else {
          // Default to login for other roles
          Get.offAllNamed(AppRoutes.login);
        }
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 120,
            ),
            const SizedBox(height: 24),
            Text(
              AppConfig.appName,
              style: AppTextStyles.h2.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              AppConfig.appTagline,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}
