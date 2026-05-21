import 'package:equatable/equatable.dart';

/// Body sent to `/api/compare/car-rental/ai-search`.
class AiSearchParams extends Equatable {
  final String prompt;
  final double currentLat;
  final double currentLng;

  const AiSearchParams({
    required this.prompt,
    required this.currentLat,
    required this.currentLng,
  });

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'current_lat': currentLat,
        'current_lng': currentLng,
      };

  @override
  List<Object?> get props => [prompt, currentLat, currentLng];
}

