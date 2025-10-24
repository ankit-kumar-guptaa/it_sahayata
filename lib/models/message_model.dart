class MessageModel {
  final int id;
  final int ticketId;
  final int senderId;
  final String message;
  final String? fileUrl;
  final bool isRead;
  final String senderName;
  final String senderRole;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.ticketId,
    required this.senderId,
    required this.message,
    this.fileUrl,
    required this.isRead,
    required this.senderName,
    required this.senderRole,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        id: int.parse(json['id'].toString()),
        ticketId: int.parse(json['ticket_id'].toString()),
        senderId: int.parse(json['sender_id'].toString()),
        message: json['message'] ?? '',
        fileUrl: json['file_url'],
        isRead: json['is_read'].toString() == '1',
        senderName: json['sender_name'] ?? '',
        senderRole: json['sender_role'] ?? '',
        timestamp: DateTime.parse(json['timestamp']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ticket_id': ticketId,
        'sender_id': senderId,
        'message': message,
        'file_url': fileUrl,
        'is_read': isRead ? 1 : 0,
        'sender_name': senderName,
        'sender_role': senderRole,
        'timestamp': timestamp.toIso8601String(),
      };
}
