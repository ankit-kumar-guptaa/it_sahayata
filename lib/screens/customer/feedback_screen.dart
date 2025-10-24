import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../providers/feedback_controller.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final fbC = Get.put(FeedbackController());
  int rating = 5;
  final commentC = TextEditingController();
  late final int ticketId;

  @override
  void initState() {
    ticketId = Get.arguments['ticket_id'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Feedback")),
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Rate Support Quality",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      5,
                      (i) => IconButton(
                            icon: Icon(
                              Icons.star,
                              size: 35,
                              color: i < rating ? Colors.amber : Colors.grey,
                            ),
                            onPressed: () => setState(() {
                              rating = i + 1;
                            }),
                          )),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: commentC,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(
                      labelText: "Feedback (optional)",
                      border: OutlineInputBorder(),
                      hintText: "What went well? Any suggestions?"),
                ),
                const SizedBox(height: 22),
                ElevatedButton.icon(
                  icon: fbC.isLoading.value
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.send),
                  label: const Text("Submit Feedback"),
                  onPressed: fbC.isLoading.value
                      ? null
                      : () async {
                          final ok = await fbC.submitFeedback(ticketId, rating,
                              comment: commentC.text.trim().isNotEmpty
                                  ? commentC.text.trim()
                                  : null);
                          if (ok) {
                            Get.snackbar('Thank you!', 'Feedback submitted.',
                                backgroundColor: Colors.green.shade100);
                            Get.back();
                          } else {
                            Get.snackbar('Error', fbC.error.value,
                                backgroundColor: Colors.red.shade100);
                          }
                        },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          )),
    );
  }
}
