import 'dart:async';

/// A lightweight debounce utility used internally by [SafeActionButton].
///
/// Ensures that rapid consecutive calls to [run] only execute [action] after
/// [delay] has elapsed with no further calls. This is distinct from the
/// cooldown system — debounce collapses trailing calls, whereas cooldown
/// blocks subsequent calls after the first execution.
class DebounceTimer {
  /// Creates a [DebounceTimer] with the given [delay].
  DebounceTimer({required this.delay});

  /// Duration to wait after the last call before executing the action.
  final Duration delay;

  Timer? _timer;

  /// Whether a pending debounced action is waiting to execute.
  bool get isPending => _timer?.isActive ?? false;

  /// Schedules [action] to run after [delay].
  ///
  /// If called again before [delay] elapses, the previous schedule is
  /// cancelled and the timer restarts.
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancels any pending action without executing it.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Cancels the timer and releases resources.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
