class TermsOfUseContent {
  const TermsOfUseContent({
    required this.name,
    required this.description,
    required this.htmlContent,
  });

  final String name;
  final String description;
  final String htmlContent;

  factory TermsOfUseContent.fromResponse(Map<String, dynamic> response) {
    final data = response['data'] as Map<String, dynamic>?;
    if (response['success'] != true || data == null) {
      throw const FormatException('Invalid terms-of-use response');
    }

    final details = data['details'] as List<dynamic>? ?? const [];
    final firstDetail = details.isNotEmpty && details.first is Map
        ? Map<String, dynamic>.from(details.first as Map)
        : const <String, dynamic>{};
    final htmlContent = firstDetail['content'] as String? ?? '';

    if (htmlContent.trim().isEmpty) {
      throw const FormatException('Terms-of-use content is empty');
    }

    return TermsOfUseContent(
      name: data['name'] as String? ?? '',
      description:
          firstDetail['description'] as String? ??
          data['description'] as String? ??
          '',
      htmlContent: htmlContent,
    );
  }
}
