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
        id: _parseInt(json['id']),
        ticketId: _parseInt(json['ticket_id']),
        senderId: _parseInt(json['sender_id']),
        message: json['message']?.toString() ?? '',
        fileUrl: json['file_url']?.toString(),
        isRead: json['is_read'].toString() == '1' || json['is_read'] == true,
        senderName: json['sender_name']?.toString() ?? '',
        senderRole: json['sender_role']?.toString() ?? '',
        timestamp: DateTime.parse(json['timestamp']?.toString() ?? DateTime.now().toIso8601String()),
      );

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String && value.isNotEmpty) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

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
