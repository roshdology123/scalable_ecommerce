import 'dart:async';

/// A utility class for debouncing function calls
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  /// Debounce a function call
  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel any pending debounced calls
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Check if there's a pending debounced call
  bool get isActive => _timer?.isActive ?? false;

  /// Dispose the debouncer
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

/// A specialized debouncer for search functionality
class SearchDebouncer extends Debouncer {
  SearchDebouncer() : super(delay: const Duration(milliseconds: 500));

  void search(String query, void Function(String) onSearch) {
    call(() => onSearch(query));
  }
}

/// A specialized debouncer for API calls
class ApiDebouncer extends Debouncer {
  ApiDebouncer() : super(delay: const Duration(milliseconds: 300));

  void apiCall(Future<void> Function() action) {
    call(() => action());
  }
}

/// A throttle utility for limiting function call frequency
class Throttler {
  final Duration duration;
  DateTime? _lastCallTime;

  Throttler({required this.duration});

  /// Throttle a function call
  bool call(void Function() action) {
    final now = DateTime.now();

    if (_lastCallTime == null ||
        now.difference(_lastCallTime!) >= duration) {
      _lastCallTime = now;
      action();
      return true;
    }

    return false;
  }

  /// Reset the throttler
  void reset() {
    _lastCallTime = null;
  }

  /// Check if the throttler is ready for the next call
  bool get isReady {
    if (_lastCallTime == null) return true;
    return DateTime.now().difference(_lastCallTime!) >= duration;
  }

  /// Get remaining time until next call is allowed
  Duration get remainingTime {
    if (_lastCallTime == null) return Duration.zero;

    final elapsed = DateTime.now().difference(_lastCallTime!);
    final remaining = duration - elapsed;

    return remaining.isNegative ? Duration.zero : remaining;
  }
}

/// A rate limiter utility
class RateLimiter {
  final int maxCalls;
  final Duration timeWindow;
  final List<DateTime> _callTimes = [];

  RateLimiter({
    required this.maxCalls,
    required this.timeWindow,
  });

  /// Check if a call is allowed and execute it if so
  bool call(void Function() action) {
    final now = DateTime.now();

    // Remove old calls outside the time window
    _callTimes.removeWhere((time) =>
    now.difference(time) > timeWindow);

    // Check if we can make another call
    if (_callTimes.length < maxCalls) {
      _callTimes.add(now);
      action();
      return true;
    }

    return false;
  }

  /// Get the number of remaining calls in the current window
  int get remainingCalls {
    final now = DateTime.now();
    _callTimes.removeWhere((time) =>
    now.difference(time) > timeWindow);
    return maxCalls - _callTimes.length;
  }

  /// Get the time until the next call is allowed
  Duration get timeUntilNextCall {
    if (_callTimes.isEmpty) return Duration.zero;

    final oldestCall = _callTimes.first;
    final timeSinceOldest = DateTime.now().difference(oldestCall);
    final remaining = timeWindow - timeSinceOldest;

    return remaining.isNegative ? Duration.zero : remaining;
  }

  /// Reset the rate limiter
  void reset() {
    _callTimes.clear();
  }
}

/// A utility class for debouncing form field validation
class ValidationDebouncer {
  final Map<String, Debouncer> _debouncers = {};

  void validateField(
      String fieldName,
      String value,
      String? Function(String?) validator,
      void Function(String?) onValidationResult,
      ) {
    _debouncers[fieldName] ??= Debouncer(
      delay: const Duration(milliseconds: 300),
    );

    _debouncers[fieldName]!.call(() {
      final result = validator(value);
      onValidationResult(result);
    });
  }

  void dispose() {
    for (final debouncer in _debouncers.values) {
      debouncer.dispose();
    }
    _debouncers.clear();
  }
}