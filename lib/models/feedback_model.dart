class FeedbackModel {
  final int id;
  final int ticketId;
  final int rating;
  final String? comment;
  final DateTime submittedAt;

  FeedbackModel({
    required this.id,
    required this.ticketId,
    required this.rating,
    this.comment,
    required this.submittedAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        id: int.parse(json['id'].toString()),
        ticketId: int.parse(json['ticket_id'].toString()),
        rating: int.parse(json['rating'].toString()),
        comment: json['comment'],
        submittedAt: DateTime.parse(json['submitted_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ticket_id': ticketId,
        'rating': rating,
        'comment': comment,
        'submitted_at': submittedAt.toIso8601String(),
      };
}
