class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String role;
  final bool isVerified;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.role,
    required this.isVerified,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: int.parse(json['id'].toString()),
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        avatarUrl: json['avatar_url'],
        role: json['role'] ?? 'customer',
        isVerified: json['is_verified'].toString() == '1',
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'avatar_url': avatarUrl,
        'role': role,
        'is_verified': isVerified ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };
}
