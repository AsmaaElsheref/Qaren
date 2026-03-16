import 'package:flutter/foundation.dart';

@immutable
class SearchLoadingState {
  final List<String> steps;
  final int currentPage;
  final Duration stepDuration;
  final bool isRunning;
  final bool isCompleted;

  const SearchLoadingState({
    required this.steps,
    required this.currentPage,
    required this.stepDuration,
    required this.isRunning,
    required this.isCompleted,
  });

  String get currentStep => steps[currentPage];

  SearchLoadingState copyWith({
    List<String>? steps,
    int? currentPage,
    Duration? stepDuration,
    bool? isRunning,
    bool? isCompleted,
  }) {
    return SearchLoadingState(
      steps: steps ?? this.steps,
      currentPage: currentPage ?? this.currentPage,
      stepDuration: stepDuration ?? this.stepDuration,
      isRunning: isRunning ?? this.isRunning,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}