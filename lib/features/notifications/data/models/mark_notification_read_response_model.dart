class MarkNotificationReadResponseModel {
  final bool success;
  final String message;

  const MarkNotificationReadResponseModel({
    required this.success,
    required this.message,
  });

  factory MarkNotificationReadResponseModel.fromJson(Map<String, dynamic> json) {
    return MarkNotificationReadResponseModel(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
    );
  }
}

