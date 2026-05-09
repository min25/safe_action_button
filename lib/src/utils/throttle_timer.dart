import 'dart:async';

/// A lightweight throttle utility used internally by [SafeActionButton].
///
/// Ensures that [action] can be called at most once within [interval].
/// The *first* call within an interval executes immediately; subsequent
/// calls within the same interval are silently dropped (leading-edge throttle).
class ThrottleTimer {
  /// Creates a [ThrottleTimer] with the given [interval].
  ThrottleTimer({required this.interval});

  /// Minimum time between successive executions.
  final Duration interval;

  Timer? _timer;
  bool _isThrottled = false;

  /// Whether calls are currently being throttled (i.e. within an active interval).
  bool get isThrottled => _isThrottled;

  /// Executes [action] if not currently throttled; otherwise drops the call.
  ///
  /// Returns `true` if [action] was executed, `false` if it was dropped.
  bool run(void Function() action) {
    if (_isThrottled) return false;
    action();
    _isThrottled = true;
    _timer = Timer(interval, () {
      _isThrottled = false;
    });
    return true;
  }

  /// Resets the throttle immediately, allowing the next call to execute.
  void reset() {
    _timer?.cancel();
    _timer = null;
    _isThrottled = false;
  }

  /// Cancels the timer and releases resources.
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _isThrottled = false;
  }
}
