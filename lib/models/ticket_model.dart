class TicketModel {
  final int id;
  final int customerId;
  final String category;
  final String description;
  final String priority;
  final String status;
  final List<String> fileUrls; // UPDATED TO LIST
  final int? agentId;
  final String? agentName;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TicketModel({
    required this.id,
    required this.customerId,
    required this.category,
    required this.description,
    required this.priority,
    required this.status,
    required this.fileUrls,
    this.agentId,
    this.agentName,
    required this.createdAt,
    this.updatedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        id: int.tryParse(json['id'].toString()) ?? 0,
        customerId: int.tryParse(json['customer_id'].toString()) ?? 0,
        category: json['category'] ?? '',
        description: json['description'] ?? '',
        priority: json['priority'] ?? '',
        status: json['status'] ?? '',
        fileUrls: (json['file_urls'] != null && json['file_urls'] != '')
            ? (json['file_urls'] is List
                ? List<String>.from(json['file_urls'])
                : json['file_urls'].toString().split(','))
            : [],
        agentId: json['agent_id'] != null
            ? int.tryParse(json['agent_id'].toString())
            : null,
        agentName: json['agent_name'],
        createdAt:
            DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'category': category,
        'description': description,
        'priority': priority,
        'status': status,
        'file_urls': fileUrls.join(','), // If string needed by API
        'agent_id': agentId,
        'agent_name': agentName,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
