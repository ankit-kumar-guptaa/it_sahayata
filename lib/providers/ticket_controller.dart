import 'package:get/get.dart';
import '../models/ticket_model.dart';
import '../services/ticket_service.dart';

class TicketController extends GetxController {
  var isLoading = false.obs;
  var tickets = <TicketModel>[].obs;
  var error = "".obs;

  // For single ticket detail
  var selectedTicket = Rxn<TicketModel>();
  var detailLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getTickets();
  }

  // All tickets for user (customer/agent)
  Future<void> getTickets() async {
    isLoading.value = true;
    error.value = "";
    final res = await TicketService.fetchTickets();
    isLoading.value = false;
    if (res.data != null) {
      tickets.value = res.data!;
    } else {
      error.value = res.error ?? res.message;
    }
  }

  // Ticket detail
  Future<void> getTicketDetail(int ticketId) async {
    detailLoading.value = true;
    error.value = "";
    selectedTicket.value = null; // always reset before fetching
    final res = await TicketService.getTicketDetail(ticketId);
    detailLoading.value = false;
    if (res.data != null) {
      selectedTicket.value = res.data;
    } else {
      error.value = res.error ?? res.message;
    }
  }

  // Create new ticket - now supports attaching multiple images!
  Future<bool> createTicket(
    String category,
    String description,
    String priority, [
    List<String>? fileUrls, // <-- NOTE: now fileUrls list
  ]) async {
    isLoading.value = true;
    error.value = "";
    final res = await TicketService.createTicket(
      category: category,
      description: description,
      priority: priority,
      fileUrls: fileUrls,
    );
    isLoading.value = false;
    if (res.data != null) {
      tickets.insert(0, res.data!); // Add immediately at top for UI
      return true;
    } else {
      error.value = res.error ?? res.message;
      return false;
    }
  }

  // Update status (for agent)
  Future<bool> updateStatus(int ticketId, String status) async {
    isLoading.value = true;
    final res =
        await TicketService.updateStatus(ticketId: ticketId, status: status);
    isLoading.value = false;
    if (res.status == 200) {
      await getTickets(); // Refresh list
      return true;
    } else {
      error.value = res.error ?? res.message;
      return false;
    }
  }
}
