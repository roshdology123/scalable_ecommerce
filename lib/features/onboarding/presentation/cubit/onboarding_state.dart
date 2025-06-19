import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState.initial() = _Initial;
  const factory OnboardingState.showing(int currentIndex, int totalPages) = _Showing;
  const factory OnboardingState.completing() = _Completing;
  const factory OnboardingState.completed() = _Completed;
  const factory OnboardingState.error(String message) = _Error;
}