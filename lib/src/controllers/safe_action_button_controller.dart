import 'dart:async';
import 'package:flutter/foundation.dart';

/// A controller that provides programmatic control over a [SafeActionButton].
///
/// Attach this controller to a button via the `controller` parameter. You can
/// then call [enable], [disable], [startLoading], [stopLoading],
/// [triggerCooldown], and [resetCooldown] from anywhere in your widget tree.
///
/// Remember to call [dispose] when the controller is no longer needed to
/// release the cooldown timer resource.
///
/// ### Example
/// ```dart
/// final _controller = SafeActionButtonController();
///
/// SafeActionButton.filled(
///   controller: _controller,
///   label: 'Submit',
///   onTap: () async { ... },
/// );
///
/// // Programmatically trigger a 5-second cooldown:
/// _controller.triggerCooldown(duration: const Duration(seconds: 5));
/// ```
class SafeActionButtonController extends ChangeNotifier {
  bool _isLoading = false;
  bool _isDisabled = false;
  bool _isInCooldown = false;
  Duration? _remainingCooldown;
  Timer? _cooldownTimer;
  Timer? _cooldownTickTimer;

  // ── Public state getters ─────────────────────────────────────────────────

  /// Whether the button is currently showing a loading indicator.
  bool get isLoading => _isLoading;

  /// Whether the button has been manually disabled via [disable].
  bool get isDisabled => _isDisabled;

  /// Whether the button is currently in a cooldown period.
  bool get isInCooldown => _isInCooldown;

  /// The remaining cooldown [Duration], updated every second during cooldown.
  /// Returns `null` if the button is not in cooldown.
  Duration? get remainingCooldown => _remainingCooldown;

  // ── Loading control ──────────────────────────────────────────────────────

  /// Puts the button into the loading state and shows the loading indicator.
  void startLoading() {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
  }

  /// Removes the loading state from the button.
  void stopLoading() {
    if (!_isLoading) return;
    _isLoading = false;
    notifyListeners();
  }

  // ── Enable / Disable control ─────────────────────────────────────────────

  /// Enables the button (clears the manual-disabled flag).
  void enable() {
    if (!_isDisabled) return;
    _isDisabled = false;
    notifyListeners();
  }

  /// Disables the button so taps are ignored until [enable] is called.
  void disable() {
    if (_isDisabled) return;
    _isDisabled = true;
    notifyListeners();
  }

  // ── Cooldown control ─────────────────────────────────────────────────────

  /// Starts a cooldown period of the given [duration].
  ///
  /// During cooldown the button is non-interactive. The cooldown ends
  /// automatically after [duration] elapses, or immediately when
  /// [resetCooldown] is called.
  void triggerCooldown({required Duration duration}) {
    _cancelCooldown();
    _isInCooldown = true;
    _remainingCooldown = duration;
    notifyListeners();

    // Tick every second to update [remainingCooldown].
    _cooldownTickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final current = _remainingCooldown;
      if (current == null || current.inSeconds <= 1) {
        _cancelCooldown();
        notifyListeners();
        return;
      }
      _remainingCooldown = current - const Duration(seconds: 1);
      notifyListeners();
    });

    // Master timer to end cooldown when duration expires.
    _cooldownTimer = Timer(duration, () {
      _cancelCooldown();
      notifyListeners();
    });
  }

  /// Immediately ends any active cooldown period and re-enables the button.
  void resetCooldown() {
    if (!_isInCooldown) return;
    _cancelCooldown();
    notifyListeners();
  }

  // ── Internal helpers ─────────────────────────────────────────────────────

  void _cancelCooldown() {
    _cooldownTimer?.cancel();
    _cooldownTimer = null;
    _cooldownTickTimer?.cancel();
    _cooldownTickTimer = null;
    _isInCooldown = false;
    _remainingCooldown = null;
  }

  /// Whether the button should accept taps.
  bool get isInteractable => !_isLoading && !_isDisabled && !_isInCooldown;

  @override
  void dispose() {
    _cancelCooldown();
    super.dispose();
  }
}
