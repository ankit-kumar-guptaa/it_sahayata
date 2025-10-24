class TicketModel {
  final int id;
  final int customerId;
  final String category;
  final String description;
  final String priority;
  final String status;
  final String? fileUrl;
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
    this.fileUrl,
    this.agentId,
    this.agentName,
    required this.createdAt,
    this.updatedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        id: int.parse(json['id'].toString()),
        customerId: int.parse(json['customer_id'].toString()),
        category: json['category'],
        description: json['description'],
        priority: json['priority'],
        status: json['status'],
        fileUrl: json['file_url'],
        agentId: json['agent_id'] != null
            ? int.tryParse(json['agent_id'].toString())
            : null,
        agentName: json['agent_name'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'category': category,
        'description': description,
        'priority': priority,
        'status': status,
        'file_url': fileUrl,
        'agent_id': agentId,
        'agent_name': agentName,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
