import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../providers/auth_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final user = authC.user.value;
    return Scaffold(
      appBar: AppBar(title: const Text("Profile & Settings")),
      body: user == null
          ? const Center(child: Text("Not logged in!"))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                ListTile(
                  leading:
                      CircleAvatar(child: Text(user.name[0].toUpperCase())),
                  title: Text(user.name),
                  subtitle:
                      Text("${user.email}\n${user.phone}\nRole: ${user.role}"),
                  isThreeLine: true,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () async {
                    await authC.logout();
                    Get.offAllNamed('/login');
                  },
                ),
              ],
            ),
    );
  }
}
