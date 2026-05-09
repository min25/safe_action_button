import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/safe_action_button_controller.dart';
import '../enums/button_type.dart';
import '../enums/cooldown_mode.dart';
import '../enums/loader_position.dart';
import '../models/safe_button_style.dart';
import '../styles/safe_button_theme.dart';
import '../utils/debounce_timer.dart';
import '../utils/throttle_timer.dart';
import 'safe_button_loader.dart';

/// A highly configurable button widget that prevents duplicate taps,
/// duplicate async API executions, and accidental multiple activations.
///
/// ## Quick start
/// ```dart
/// SafeActionButton.filled(
///   label: 'Save',
///   onTap: () async {
///     await myApiCall();
///   },
/// )
/// ```
///
/// ## Named constructors
/// | Constructor | Description |
/// |---|---|
/// | [SafeActionButton.filled] | Solid background (default) |
/// | [SafeActionButton.outlined] | Transparent + border |
/// | [SafeActionButton.text] | Text only, no border/background |
/// | [SafeActionButton.custom] | Fully custom child widget |
///
/// ## Cooldown modes
/// Set [cooldownMode] to control how the post-tap lockout duration is
/// determined:
/// - [CooldownMode.staticDuration] — use [cooldownDuration] (default 2 s)
/// - [CooldownMode.dynamic] — [onTap] returns a [Duration?]
/// - [CooldownMode.manual] — cleared only via [controller.resetCooldown]
class SafeActionButton extends StatefulWidget {
  // ── Base constructor ─────────────────────────────────────────────────────

  /// Creates a [SafeActionButton] with the given [buttonType].
  ///
  /// Prefer the named constructors ([filled], [outlined], [text], [custom])
  /// for cleaner call sites.
  // ignore: always_put_required_named_parameters_first
  const SafeActionButton({
    super.key,
    required this.buttonType,
    this.label,
    this.child,
    this.icon,
    this.onTap,
    this.onError,
    this.onCompleted,
    this.onCooldownStart,
    this.onCooldownEnd,
    this.style,
    this.controller,
    this.cooldownMode = CooldownMode.staticDuration,
    this.cooldownDuration = SafeButtonTheme.kDefaultCooldownDuration,
    this.debounceMode = false,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.throttleMode = false,
    this.throttleDuration = const Duration(milliseconds: 500),
    this.loadingWidget,
    this.isEnabled = true,
    this.semanticLabel,
    this.hapticFeedback = false,
    this.showCooldownTimer = false,
    this.tooltip,
  });

  // ── Named constructors ───────────────────────────────────────────────────

  /// Creates a filled (solid background) [SafeActionButton].
  ///
  /// ```dart
  /// SafeActionButton.filled(
  ///   label: 'Submit',
  ///   onTap: () async { await submit(); },
  /// )
  /// ```
  const SafeActionButton.filled({
    Key? key,
    String? label,
    Widget? child,
    Widget? icon,
    Future<Duration?> Function()? onTap,
    void Function(Object error, StackTrace? stack)? onError,
    void Function()? onCompleted,
    void Function()? onCooldownStart,
    void Function()? onCooldownEnd,
    SafeButtonStyle? style,
    SafeActionButtonController? controller,
    CooldownMode cooldownMode = CooldownMode.staticDuration,
    Duration cooldownDuration = SafeButtonTheme.kDefaultCooldownDuration,
    bool debounceMode = false,
    Duration debounceDuration = const Duration(milliseconds: 300),
    bool throttleMode = false,
    Duration throttleDuration = const Duration(milliseconds: 500),
    Widget? loadingWidget,
    bool isEnabled = true,
    String? semanticLabel,
    bool hapticFeedback = false,
    bool showCooldownTimer = false,
    String? tooltip,
  }) : this(
          key: key,
          buttonType: SafeButtonType.filled,
          label: label,
          child: child,
          icon: icon,
          onTap: onTap,
          onError: onError,
          onCompleted: onCompleted,
          onCooldownStart: onCooldownStart,
          onCooldownEnd: onCooldownEnd,
          style: style,
          controller: controller,
          cooldownMode: cooldownMode,
          cooldownDuration: cooldownDuration,
          debounceMode: debounceMode,
          debounceDuration: debounceDuration,
          throttleMode: throttleMode,
          throttleDuration: throttleDuration,
          loadingWidget: loadingWidget,
          isEnabled: isEnabled,
          semanticLabel: semanticLabel,
          hapticFeedback: hapticFeedback,
          showCooldownTimer: showCooldownTimer,
          tooltip: tooltip,
        );

  /// Creates an outlined [SafeActionButton].
  const SafeActionButton.outlined({
    Key? key,
    String? label,
    Widget? child,
    Widget? icon,
    Future<Duration?> Function()? onTap,
    void Function(Object error, StackTrace? stack)? onError,
    void Function()? onCompleted,
    void Function()? onCooldownStart,
    void Function()? onCooldownEnd,
    SafeButtonStyle? style,
    SafeActionButtonController? controller,
    CooldownMode cooldownMode = CooldownMode.staticDuration,
    Duration cooldownDuration = SafeButtonTheme.kDefaultCooldownDuration,
    bool debounceMode = false,
    Duration debounceDuration = const Duration(milliseconds: 300),
    bool throttleMode = false,
    Duration throttleDuration = const Duration(milliseconds: 500),
    Widget? loadingWidget,
    bool isEnabled = true,
    String? semanticLabel,
    bool hapticFeedback = false,
    bool showCooldownTimer = false,
    String? tooltip,
  }) : this(
          key: key,
          buttonType: SafeButtonType.outlined,
          label: label,
          child: child,
          icon: icon,
          onTap: onTap,
          onError: onError,
          onCompleted: onCompleted,
          onCooldownStart: onCooldownStart,
          onCooldownEnd: onCooldownEnd,
          style: style,
          controller: controller,
          cooldownMode: cooldownMode,
          cooldownDuration: cooldownDuration,
          debounceMode: debounceMode,
          debounceDuration: debounceDuration,
          throttleMode: throttleMode,
          throttleDuration: throttleDuration,
          loadingWidget: loadingWidget,
          isEnabled: isEnabled,
          semanticLabel: semanticLabel,
          hapticFeedback: hapticFeedback,
          showCooldownTimer: showCooldownTimer,
          tooltip: tooltip,
        );

  /// Creates a text-only [SafeActionButton] with no border or background.
  const SafeActionButton.text({
    Key? key,
    String? label,
    Widget? child,
    Widget? icon,
    Future<Duration?> Function()? onTap,
    void Function(Object error, StackTrace? stack)? onError,
    void Function()? onCompleted,
    void Function()? onCooldownStart,
    void Function()? onCooldownEnd,
    SafeButtonStyle? style,
    SafeActionButtonController? controller,
    CooldownMode cooldownMode = CooldownMode.staticDuration,
    Duration cooldownDuration = SafeButtonTheme.kDefaultCooldownDuration,
    bool debounceMode = false,
    Duration debounceDuration = const Duration(milliseconds: 300),
    bool throttleMode = false,
    Duration throttleDuration = const Duration(milliseconds: 500),
    Widget? loadingWidget,
    bool isEnabled = true,
    String? semanticLabel,
    bool hapticFeedback = false,
    bool showCooldownTimer = false,
    String? tooltip,
  }) : this(
          key: key,
          buttonType: SafeButtonType.text,
          label: label,
          child: child,
          icon: icon,
          onTap: onTap,
          onError: onError,
          onCompleted: onCompleted,
          onCooldownStart: onCooldownStart,
          onCooldownEnd: onCooldownEnd,
          style: style,
          controller: controller,
          cooldownMode: cooldownMode,
          cooldownDuration: cooldownDuration,
          debounceMode: debounceMode,
          debounceDuration: debounceDuration,
          throttleMode: throttleMode,
          throttleDuration: throttleDuration,
          loadingWidget: loadingWidget,
          isEnabled: isEnabled,
          semanticLabel: semanticLabel,
          hapticFeedback: hapticFeedback,
          showCooldownTimer: showCooldownTimer,
          tooltip: tooltip,
        );

  /// Creates a custom [SafeActionButton] where [child] is rendered as-is.
  ///
  /// All default theming is bypassed; wrap your child in whatever decoration
  /// you need and the button will handle tap guarding around it.
  const SafeActionButton.custom({
    Key? key,
    required Widget child,
    Future<Duration?> Function()? onTap,
    // ignore: always_put_required_named_parameters_first — required in redirecting ctor
    void Function(Object error, StackTrace? stack)? onError,
    void Function()? onCompleted,
    void Function()? onCooldownStart,
    void Function()? onCooldownEnd,
    SafeActionButtonController? controller,
    CooldownMode cooldownMode = CooldownMode.staticDuration,
    Duration cooldownDuration = SafeButtonTheme.kDefaultCooldownDuration,
    bool debounceMode = false,
    Duration debounceDuration = const Duration(milliseconds: 300),
    bool throttleMode = false,
    Duration throttleDuration = const Duration(milliseconds: 500),
    bool isEnabled = true,
    String? semanticLabel,
    bool hapticFeedback = false,
    String? tooltip,
  }) : this(
          key: key,
          buttonType: SafeButtonType.custom,
          child: child,
          onTap: onTap,
          onError: onError,
          onCompleted: onCompleted,
          onCooldownStart: onCooldownStart,
          onCooldownEnd: onCooldownEnd,
          controller: controller,
          cooldownMode: cooldownMode,
          cooldownDuration: cooldownDuration,
          debounceMode: debounceMode,
          debounceDuration: debounceDuration,
          throttleMode: throttleMode,
          throttleDuration: throttleDuration,
          isEnabled: isEnabled,
          semanticLabel: semanticLabel,
          hapticFeedback: hapticFeedback,
        );

  // ── Properties ───────────────────────────────────────────────────────────

  /// Visual style variant of the button.
  final SafeButtonType buttonType;

  /// Text label rendered inside the button. Ignored when [child] is provided.
  final String? label;

  /// Completely custom child widget. When set, [label] and [icon] are ignored
  /// (except for [SafeButtonType.custom]).
  final Widget? child;

  /// Optional leading icon widget displayed before [label].
  final Widget? icon;

  /// Async callback invoked when the button is tapped.
  ///
  /// The return value is used as the cooldown duration when
  /// [cooldownMode] is [CooldownMode.dynamic]. Return `null` for no cooldown.
  ///
  /// If this is `null`, the button renders in a visually disabled state.
  final Future<Duration?> Function()? onTap;

  /// Called when [onTap] throws an exception.
  ///
  /// Receives the caught error and optional stack trace. The button exits the
  /// loading state before this callback is called, so you can show a snackbar
  /// or update UI safely.
  final void Function(Object error, StackTrace? stack)? onError;

  /// Called after [onTap] completes successfully (before cooldown starts).
  final void Function()? onCompleted;

  /// Called when a cooldown period begins.
  final void Function()? onCooldownStart;

  /// Called when a cooldown period ends.
  final void Function()? onCooldownEnd;

  /// Visual styling overrides. Merged on top of the type's default theme.
  final SafeButtonStyle? style;

  /// Optional controller for programmatic state management.
  final SafeActionButtonController? controller;

  /// Determines how the post-tap cooldown duration is calculated.
  final CooldownMode cooldownMode;

  /// Cooldown duration used when [cooldownMode] is [CooldownMode.staticDuration].
  final Duration cooldownDuration;

  /// When `true`, taps are debounced: rapid taps reset the timer and only
  /// the last tap (after [debounceDuration] of silence) fires [onTap].
  final bool debounceMode;

  /// Debounce interval. Only relevant when [debounceMode] is `true`.
  final Duration debounceDuration;

  /// When `true`, only the first tap within [throttleDuration] fires [onTap];
  /// subsequent taps within the interval are silently dropped.
  final bool throttleMode;

  /// Throttle interval. Only relevant when [throttleMode] is `true`.
  final Duration throttleDuration;

  /// Custom widget to display in place of the default [SafeButtonLoader]
  /// while the button is in the loading state.
  final Widget? loadingWidget;

  /// When `false`, the button is rendered and behaves as disabled regardless
  /// of the controller state.
  final bool isEnabled;

  /// Accessibility label used by screen readers.
  final String? semanticLabel;

  /// When `true`, a light haptic tap is triggered on each valid tap.
  final bool hapticFeedback;

  /// When `true` and [cooldownMode] is not [CooldownMode.manual], a countdown
  /// timer (e.g. "3s") is shown inside the button during cooldown.
  final bool showCooldownTimer;

  /// Optional tooltip text shown on long-press.
  final String? tooltip;

  @override
  State<SafeActionButton> createState() => _SafeActionButtonState();
}

// ── State ──────────────────────────────────────────────────────────────────

class _SafeActionButtonState extends State<SafeActionButton>
    with SingleTickerProviderStateMixin {
  // Internal controller used when the user doesn't provide one.
  late SafeActionButtonController _internalController;
  SafeActionButtonController get _ctrl =>
      widget.controller ?? _internalController;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  DebounceTimer? _debounceTimer;
  ThrottleTimer? _throttleTimer;

  @override
  void initState() {
    super.initState();
    _internalController = SafeActionButtonController();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );

    if (widget.debounceMode) {
      _debounceTimer = DebounceTimer(delay: widget.debounceDuration);
    }
    if (widget.throttleMode) {
      _throttleTimer = ThrottleTimer(interval: widget.throttleDuration);
    }

    _ctrl.addListener(_onControllerChange);
  }

  @override
  void didUpdateWidget(covariant SafeActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChange);
      _ctrl.addListener(_onControllerChange);
    }
  }

  void _onControllerChange() {
    if (!mounted) return;
    if (_ctrl.isLoading) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onControllerChange);
    _internalController.dispose();
    _animController.dispose();
    _debounceTimer?.dispose();
    _throttleTimer?.dispose();
    super.dispose();
  }

  // ── Tap handling ─────────────────────────────────────────────────────────

  Future<void> _handleTap() async {
    if (!widget.isEnabled) return;
    if (!_ctrl.isInteractable) return;
    if (widget.onTap == null) return;

    // Throttle mode: drop rapid consecutive taps.
    if (widget.throttleMode && _throttleTimer != null) {
      final executed = _throttleTimer!.run(_doTap);
      if (!executed) return;
      return;
    }

    // Debounce mode: delay execution until taps stop.
    if (widget.debounceMode && _debounceTimer != null) {
      _debounceTimer!.run(_doTap);
      return;
    }

    await _doTap();
  }

  Future<void> _doTap() async {
    if (!mounted) return;
    if (!_ctrl.isInteractable) return;

    if (widget.hapticFeedback) {
      await HapticFeedback.lightImpact();
    }

    _ctrl.startLoading();
    unawaited(_animController.forward());

    Duration? cooldown;

    try {
      cooldown = await widget.onTap!();
      if (!mounted) return;
      widget.onCompleted?.call();
    } catch (error, stack) {
      if (!mounted) return;
      _ctrl.stopLoading();
      unawaited(_animController.reverse());
      widget.onError?.call(error, stack);
      return;
    }

    if (!mounted) return;
    _ctrl.stopLoading();
    unawaited(_animController.reverse());

    // Apply cooldown based on mode.
    switch (widget.cooldownMode) {
      case CooldownMode.staticDuration:
        _startCooldown(widget.cooldownDuration);
        break;
      case CooldownMode.dynamic:
        if (cooldown != null && cooldown > Duration.zero) {
          _startCooldown(cooldown);
        }
        break;
      case CooldownMode.manual:
        _startManualCooldown();
        break;
    }
  }

  void _startCooldown(Duration duration) {
    widget.onCooldownStart?.call();
    _ctrl.triggerCooldown(duration: duration);

    // Listen for cooldown end so we can fire onCooldownEnd callback.
    void listener() {
      if (!_ctrl.isInCooldown) {
        if (mounted) widget.onCooldownEnd?.call();
        _ctrl.removeListener(listener);
      }
    }

    _ctrl.addListener(listener);
  }

  void _startManualCooldown() {
    widget.onCooldownStart?.call();
    // Put the button into cooldown; the controller's resetCooldown() must be
    // called externally to re-enable the button.
    _ctrl.triggerCooldown(duration: const Duration(days: 365));
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (widget.buttonType == SafeButtonType.custom) {
      return _buildCustomButton(context);
    }

    final defaults =
        SafeButtonTheme.defaultStyleFor(widget.buttonType, context);
    final resolved = widget.style != null
        ? SafeButtonTheme.merge(defaults, widget.style!)
        : defaults;

    final bool isInteractable =
        widget.isEnabled && _ctrl.isInteractable && widget.onTap != null;

    Widget button = _buildStyledButton(context, resolved, isInteractable);

    if (widget.style?.margin != null) {
      button = Padding(padding: widget.style!.margin!, child: button);
    }

    if (widget.tooltip != null) {
      button = Tooltip(message: widget.tooltip!, child: button);
    }

    return Semantics(
      button: true,
      enabled: isInteractable,
      label: widget.semanticLabel ?? widget.label,
      child: button,
    );
  }

  Widget _buildStyledButton(
    BuildContext context,
    SafeButtonStyle style,
    bool isInteractable,
  ) {
    final Color bgColor = isInteractable
        ? (style.backgroundColor ?? Colors.transparent)
        : (style.disabledColor ?? Colors.grey.shade300);

    final Color fgColor = isInteractable
        ? (style.foregroundColor ?? Theme.of(context).colorScheme.onSurface)
        : Colors.grey.shade500;

    final TextStyle effectiveTextStyle = (style.textStyle ?? const TextStyle())
        .copyWith(
          fontSize: style.fontSize ?? SafeButtonTheme.kDefaultFontSize,
          fontWeight: style.fontWeight ?? FontWeight.w600,
          color: fgColor,
        );

    final BorderRadius borderRadius =
        style.borderRadius ?? SafeButtonTheme.kDefaultBorderRadius;

    final Widget content = _buildContent(style, effectiveTextStyle, fgColor);

    final Widget inkWell = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isInteractable ? _handleTap : null,
        borderRadius: borderRadius,
        splashFactory: style.splashFactory,
        child: AnimatedContainer(
          duration:
              style.animationDuration ?? SafeButtonTheme.kDefaultAnimationDuration,
          width: style.width,
          height: style.height,
          padding: style.padding ?? SafeButtonTheme.kDefaultPadding,
          alignment: style.alignment ?? Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius,
            border: widget.buttonType == SafeButtonType.outlined
                ? Border.all(
                    color: isInteractable
                        ? (style.borderColor ??
                            Theme.of(context).colorScheme.primary)
                        : Colors.grey.shade400,
                    width:
                        style.borderWidth ?? SafeButtonTheme.kDefaultBorderWidth,
                  )
                : null,
            boxShadow: style.shadows,
          ),
          child: content,
        ),
      ),
    );

    return ClipRRect(
      borderRadius: borderRadius,
      child: inkWell,
    );
  }

  Widget _buildContent(
    SafeButtonStyle style,
    TextStyle textStyle,
    Color fgColor,
  ) {
    final bool isLoading = _ctrl.isLoading;
    final bool isInCooldown = _ctrl.isInCooldown;
    final LoaderPosition loaderPos = style.loaderPosition;

    // ── Loading state ────────────────────────────────────────────────────
    if (isLoading) {
      final Widget loader = widget.loadingWidget ??
          SafeButtonLoader(color: style.loadingColor ?? fgColor);

      if (loaderPos == LoaderPosition.center) {
        return FadeTransition(opacity: _fadeAnimation, child: loader);
      }

      final label = _buildLabelRow(style, textStyle, fgColor);
      final spacing = SizedBox(
          width: style.iconSpacing ?? SafeButtonTheme.kDefaultIconSpacing);

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: loaderPos == LoaderPosition.left
            ? [loader, spacing, label]
            : [label, spacing, loader],
      );
    }

    // ── Cooldown state (show countdown timer) ────────────────────────────
    if (isInCooldown && widget.showCooldownTimer) {
      final remaining = _ctrl.remainingCooldown;
      final seconds =
          remaining != null ? remaining.inSeconds.clamp(0, 9999) : 0;
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Text(
          '${seconds}s',
          key: ValueKey(seconds),
          style: textStyle,
        ),
      );
    }

    // ── Idle / cooldown state ─────────────────────────────────────────────
    if (widget.child != null && widget.buttonType != SafeButtonType.custom) {
      return widget.child!;
    }
    return _buildLabelRow(style, textStyle, fgColor);
  }

  Widget _buildLabelRow(
    SafeButtonStyle style,
    TextStyle textStyle,
    Color fgColor,
  ) {
    if (widget.icon == null && widget.label == null) {
      return const SizedBox.shrink();
    }
    if (widget.icon != null && widget.label != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconTheme(
            data: IconThemeData(color: fgColor, size: 20),
            child: widget.icon!,
          ),
          SizedBox(width: style.iconSpacing ?? SafeButtonTheme.kDefaultIconSpacing),
          Text(widget.label!, style: textStyle),
        ],
      );
    }
    if (widget.icon != null) {
      return IconTheme(
        data: IconThemeData(color: fgColor, size: 20),
        child: widget.icon!,
      );
    }
    return Text(widget.label ?? '', style: textStyle);
  }

  Widget _buildCustomButton(BuildContext context) {
    final bool isInteractable =
        widget.isEnabled && _ctrl.isInteractable && widget.onTap != null;

    Widget body = GestureDetector(
      onTap: isInteractable ? _handleTap : null,
      behavior: HitTestBehavior.opaque,
      child: widget.child ?? const SizedBox.shrink(),
    );

    if (widget.tooltip != null) {
      body = Tooltip(message: widget.tooltip!, child: body);
    }

    return Semantics(
      button: true,
      enabled: isInteractable,
      label: widget.semanticLabel,
      child: body,
    );
  }
}
