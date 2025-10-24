class ApiResponse<T> {
  final int status;
  final String message;
  final T? data;
  final String? error;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.error,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      status: json['status'] is int
          ? json['status']
          : int.tryParse(json['status'].toString()) ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      error: json['error'],
    );
  }
}
