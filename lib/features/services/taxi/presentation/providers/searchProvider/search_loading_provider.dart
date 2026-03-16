import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'search_loading_state.dart';

final searchLoadingProvider =
NotifierProvider.autoDispose<SearchLoadingNotifier, SearchLoadingState>(
  SearchLoadingNotifier.new,
);

class SearchLoadingNotifier extends AutoDisposeNotifier<SearchLoadingState> {
  Timer? _timer;

  static const List<String> _defaultSteps = [
    'جاري تحليل طلبك...',
    'التحقق من التوفر...',
    'البحث عن أفضل الخدمات...',
    'مقارنة الأسعار...',
    'تجهيز أفضل النتائج...',
  ];

  static const Duration _defaultStepDuration = Duration(seconds: 2);

  @override
  SearchLoadingState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    return const SearchLoadingState(
      steps: _defaultSteps,
      currentPage: 0,
      stepDuration: _defaultStepDuration,
      isRunning: false,
      isCompleted: false,
    );
  }

  void startAutoCycle() {
    if (state.isRunning || state.isCompleted) return;

    _timer?.cancel();
    state = state.copyWith(isRunning: true);

    _timer = Timer.periodic(state.stepDuration, (_) {
      nextStep();
    });
  }

  void stopAutoCycle() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isRunning: false);
  }

  void nextStep() {
    if (state.isCompleted) return;

    final next = (state.currentPage + 1) % state.steps.length;
    state = state.copyWith(currentPage: next);
  }

  void previousStep() {
    if (state.isCompleted) return;

    final prev = (state.currentPage - 1 + state.steps.length) % state.steps.length;
    state = state.copyWith(currentPage: prev);
  }

  void goToStep(int index) {
    if (state.isCompleted) return;
    if (index < 0 || index >= state.steps.length) return;

    state = state.copyWith(currentPage: index);
  }

  void reset() {
    _timer?.cancel();
    _timer = null;

    state = state.copyWith(
      currentPage: 0,
      isRunning: false,
      isCompleted: false,
    );
  }

  void setSteps(List<String> steps) {
    if (steps.isEmpty) return;

    state = state.copyWith(
      steps: steps,
      currentPage: 0,
    );
  }

  void setStepDuration(Duration duration) {
    if (duration.inMilliseconds <= 0) return;

    final wasRunning = state.isRunning;
    _timer?.cancel();
    _timer = null;

    state = state.copyWith(
      stepDuration: duration,
      isRunning: false,
    );

    if (wasRunning && !state.isCompleted) {
      startAutoCycle();
    }
  }

  void complete() {
    _timer?.cancel();
    _timer = null;

    state = state.copyWith(
      isRunning: false,
      isCompleted: true,
    );
  }
}