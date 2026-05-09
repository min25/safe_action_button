/// Defines how the button cooldown duration is determined.
enum CooldownMode {
  /// A fixed cooldown duration specified via [SafeActionButton.cooldownDuration].
  staticDuration,

  /// The cooldown duration is returned dynamically by the [onTap] callback as
  /// a [Duration?]. If the callback returns `null`, no cooldown is applied.
  dynamic,

  /// Cooldown is controlled entirely by a [SafeActionButtonController] — the
  /// button re-enables only when [controller.resetCooldown()] is called.
  manual,
}
