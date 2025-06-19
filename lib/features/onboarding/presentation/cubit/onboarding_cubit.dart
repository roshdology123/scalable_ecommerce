import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/storage/storage_service.dart';
import '../../../../core/utils/app_logger.dart';
import 'onboarding_state.dart';

@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final StorageService _storageService;
  final AppLogger _logger = AppLogger();

  OnboardingCubit(this._storageService) : super(const OnboardingState.initial());

  void nextPage() {
    state.maybeWhen(
      showing: (currentIndex, totalPages) {
        _logger.logUserAction('onboarding_next_page', {
          'current_page': currentIndex,
          'total_pages': totalPages,
          'user': 'roshdology123',
          'timestamp': '2025-06-19 06:14:38',
        });

        if (currentIndex < totalPages - 1) {
          emit(OnboardingState.showing(currentIndex + 1, totalPages));
        } else {
          _completeOnboarding();
        }
      },
      orElse: () {},
    );
  }

  void previousPage() {
    state.maybeWhen(
      showing: (currentIndex, totalPages) {
        _logger.logUserAction('onboarding_previous_page', {
          'current_page': currentIndex,
          'total_pages': totalPages,
          'user': 'roshdology123',
          'timestamp': '2025-06-19 06:14:38',
        });

        if (currentIndex > 0) {
          emit(OnboardingState.showing(currentIndex - 1, totalPages));
        }
      },
      orElse: () {},
    );
  }

  void skipOnboarding() {
    _logger.logUserAction('onboarding_skipped', {
      'user': 'roshdology123',
      'timestamp': '2025-06-19 06:14:38',
    });
    _completeOnboarding();
  }

  void startOnboarding(int totalPages) {
    _logger.logUserAction('onboarding_started', {
      'total_pages': totalPages,
      'user': 'roshdology123',
      'timestamp': '2025-06-19 06:14:38',
    });
    emit(OnboardingState.showing(0, totalPages));
  }

  Future<void> _completeOnboarding() async {
    try {
      emit(const OnboardingState.completing());

      await _storageService.saveOnboardingCompleted(true);

      _logger.logUserAction('onboarding_completed', {
        'user': 'roshdology123',
        'timestamp': '2025-06-19 06:14:38',
      });

      emit(const OnboardingState.completed());
    } catch (e) {
      _logger.logErrorWithContext(
        'OnboardingCubit._completeOnboarding',
        e,
        StackTrace.current,
        {
          'user': 'roshdology123',
          'timestamp': '2025-06-19 06:14:38',
        },
      );
      emit(OnboardingState.error(e.toString()));
    }
  }

  Future<bool> hasSeenOnboarding() async {
    try {
      final hasCompleted = _storageService.getOnboardingCompleted();

      _logger.logBusinessLogic(
        'onboarding_status_checked',
        'storage_operation',
        {
          'has_completed': hasCompleted,
          'user': 'roshdology123',
          'timestamp': '2025-06-19 06:14:38',
        },
      );

      return hasCompleted;
    } catch (e) {
      _logger.logErrorWithContext(
        'OnboardingCubit.hasSeenOnboarding',
        e,
        StackTrace.current,
        {
          'user': 'roshdology123',
          'timestamp': '2025-06-19 06:14:38',
        },
      );
      return false;
    }
  }
}