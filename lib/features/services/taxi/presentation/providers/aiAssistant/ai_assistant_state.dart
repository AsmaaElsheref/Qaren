import 'package:equatable/equatable.dart';

/// State for the floating AI-assistant search overlay shown above the map.
///
/// The overlay only parses the natural-language prompt into pickup/destination
/// values; it does **not** perform the price-comparison call. That still
/// happens when the user taps the existing "مقارنة الأسعار" button.
class AiAssistantState extends Equatable {
  final bool isLoading;
  final String? errorMessage;

  const AiAssistantState({
    this.isLoading = false,
    this.errorMessage,
  });

  AiAssistantState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AiAssistantState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}

