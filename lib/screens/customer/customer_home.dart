import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_config.dart';
import '../../config/theme.dart';
import '../../providers/ticket_controller.dart';
import '../../providers/auth_controller.dart';
import '../common/settings_screen.dart';
import 'create_ticket_screen.dart';
import 'ticket_list_screen.dart';

class CustomerHome extends StatelessWidget {
  const CustomerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final ticketC = Get.put(TicketController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('IT Sahayata'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.to(() => const SettingsScreen()),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: Obx(() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: ListView(
              children: [
                Text(
                  "Hello, ${authC.user.value?.name ?? 'User'} 👋",
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: 8),
                Text(
                    "Raise IT complaints, chat with agents, track your tickets!"),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: AppColors.primary,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              Text('${ticketC.tickets.length}',
                                  style: AppTextStyles.h2
                                      .copyWith(color: Colors.white)),
                              const SizedBox(height: 3),
                              Text('Total Tickets',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        color: AppColors.success,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              Text(
                                '${ticketC.tickets.where((t) => t.status == "resolved" || t.status == "closed").length}',
                                style: AppTextStyles.h2
                                    .copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 3),
                              Text('Resolved',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Card(
                        color: AppColors.warning,
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            children: [
                              Text(
                                '${ticketC.tickets.where((t) => t.status == "pending" || t.status == "assigned" || t.status == "in_progress").length}',
                                style: AppTextStyles.h2
                                    .copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 3),
                              Text('Open',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(color: Colors.white70)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                ElevatedButton.icon(
                  onPressed: () => Get.to(() => const CreateTicketScreen()),
                  icon: const Icon(Icons.add),
                  label: const Text("Report a Problem"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("My Tickets", style: AppTextStyles.h4),
                    TextButton(
                      onPressed: () => Get.to(() => const TicketListScreen()),
                      child: const Text("See All"),
                    ),
                  ],
                ),
                if (ticketC.isLoading.value)
                  const Center(child: CircularProgressIndicator())
                else
                  ...ticketC.tickets
                      .take(3)
                      .map((t) => ListTile(
                            leading: CircleAvatar(
                                child: Text('${t.category[0].toUpperCase()}')),
                            title: Text(t.description,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text('Status: ${t.status}'),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () => Get.toNamed('/ticket-detail',
                                arguments: {'ticket_id': t.id}),
                          ))
                      .toList(),
              ],
            ),
          )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (i) {
          if (i == 0) return; // Home
          if (i == 1) Get.to(() => const TicketListScreen());
          if (i == 2) Get.to(() => const SettingsScreen());
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: "My Tickets"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Profile"),
        ],
      ),
    );
  }
}
