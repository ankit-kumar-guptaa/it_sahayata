import 'package:get/get.dart';
import '../models/feedback_model.dart';
import '../services/feedback_service.dart';

class FeedbackController extends GetxController {
  var isLoading = false.obs;
  var feedback = Rxn<FeedbackModel>();
  var error = "".obs;

  // Submit feedback
  Future<bool> submitFeedback(int ticketId, int rating,
      {String? comment}) async {
    isLoading.value = true;
    final res = await FeedbackService.submitFeedback(
      ticketId: ticketId,
      rating: rating,
      comment: comment,
    );
    isLoading.value = false;
    if (res.data != null) {
      feedback.value = res.data!;
      return true;
    } else {
      error.value = res.error ?? res.message;
      return false;
    }
  }
}
