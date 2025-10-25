import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_config.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../providers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authC = Get.find<AuthController>();
  final emailC = TextEditingController();
  final passC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 90),
              const SizedBox(height: 18),
              // Text(AppConfig.appName, style: AppTextStyles.h2),
              const SizedBox(height: 32),
              Obx(
                () => Column(
                  children: [
                    TextField(
                      controller: emailC,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: passC,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: authC.isLoading.value
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              final ok = await authC.login(
                                  emailC.text.trim(), passC.text.trim());
                              if (ok) {
                                Get.offAllNamed(
                                    authC.user.value!.role == 'agent'
                                        ? AppRoutes.agentHome
                                        : AppRoutes.customerHome);
                              } else {
                                Get.snackbar('Login Failed', authC.error.value,
                                    backgroundColor: Colors.red.shade100,
                                    colorText: Colors.red.shade900);
                              }
                            },
                      child: authC.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Login'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.register);
                      },
                      child: const Text("Don't have an account? Register"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
