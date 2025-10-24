import 'package:get/get.dart';
import '../services/resolution_service.dart';

class ResolutionController extends GetxController {
  var isLoading = false.obs;
  var error = "".obs;

  // Submit resolution (agent marks as resolved)
  Future<bool> addResolution(int ticketId, String notes) async {
    isLoading.value = true;
    final res = await ResolutionService.addResolution(
      ticketId: ticketId,
      resolution: notes,
    );
    isLoading.value = false;
    if (res.status == 200) {
      return true;
    } else {
      error.value = res.error ?? res.message;
      return false;
    }
  }
}
