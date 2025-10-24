import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/routes.dart';
import '../../providers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final authC = Get.find<AuthController>();
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final passC = TextEditingController();
  String role = 'customer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Obx(() => Column(
              children: [
                TextField(
                  controller: nameC,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailC,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: phoneC,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "Phone"),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passC,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: role,
                  decoration: const InputDecoration(labelText: "Role"),
                  items: [
                    DropdownMenuItem(
                        value: 'customer', child: Text('Customer')),
                    DropdownMenuItem(value: 'agent', child: Text('Agent')),
                  ],
                  onChanged: (v) => setState(() {
                    if (v != null) role = v;
                  }),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: authC.isLoading.value
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          final ok = await authC.register(
                            name: nameC.text.trim(),
                            email: emailC.text.trim(),
                            phone: phoneC.text.trim(),
                            password: passC.text.trim(),
                            role: role,
                          );
                          if (ok) {
                            Get.toNamed(AppRoutes.otpVerification,
                                arguments: {'email': emailC.text.trim()});
                          } else {
                            Get.snackbar('Register Failed', authC.error.value,
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
                      : const Text('Create Account'),
                ),
              ],
            )),
      ),
    );
  }
}
