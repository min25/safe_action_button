import 'package:flutter/material.dart';

import '../enums/button_type.dart';
import '../models/safe_button_style.dart';

/// Default styling values for each [SafeButtonType].
///
/// These serve as sensible fallbacks when no explicit [SafeButtonStyle] or
/// individual property overrides are provided on a [SafeActionButton].
class SafeButtonTheme {
  SafeButtonTheme._();

  // ── Shared defaults ──────────────────────────────────────────────────────

  static const Duration kDefaultAnimationDuration =
      Duration(milliseconds: 250);
  static const Duration kDefaultCooldownDuration = Duration(seconds: 2);
  static const BorderRadius kDefaultBorderRadius =
      BorderRadius.all(Radius.circular(12));
  static const EdgeInsets kDefaultPadding =
      EdgeInsets.symmetric(horizontal: 24, vertical: 14);
  static const double kDefaultBorderWidth = 1.5;
  static const double kDefaultIconSpacing = 8.0;
  static const double kDefaultFontSize = 15.0;
  static const double kDefaultLoaderSize = 18.0;
  static const double kDefaultLoaderStrokeWidth = 2.0;

  // ── Per-type style factories ─────────────────────────────────────────────

  /// Default [SafeButtonStyle] for [SafeButtonType.filled].
  static SafeButtonStyle filledStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeButtonStyle(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      disabledColor: colorScheme.onSurface.withAlpha(30),
      loadingColor: colorScheme.onPrimary,
      borderRadius: kDefaultBorderRadius,
      padding: kDefaultPadding,
      animationDuration: kDefaultAnimationDuration,
      fontSize: kDefaultFontSize,
      fontWeight: FontWeight.w600,
    );
  }

  /// Default [SafeButtonStyle] for [SafeButtonType.outlined].
  static SafeButtonStyle outlinedStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeButtonStyle(
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.primary,
      disabledColor: colorScheme.onSurface.withAlpha(30),
      loadingColor: colorScheme.primary,
      borderColor: colorScheme.primary,
      borderWidth: kDefaultBorderWidth,
      borderRadius: kDefaultBorderRadius,
      padding: kDefaultPadding,
      animationDuration: kDefaultAnimationDuration,
      fontSize: kDefaultFontSize,
      fontWeight: FontWeight.w600,
    );
  }

  /// Default [SafeButtonStyle] for [SafeButtonType.text].
  static SafeButtonStyle textStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeButtonStyle(
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.primary,
      disabledColor: colorScheme.onSurface.withAlpha(30),
      loadingColor: colorScheme.primary,
      padding: kDefaultPadding,
      animationDuration: kDefaultAnimationDuration,
      fontSize: kDefaultFontSize,
      fontWeight: FontWeight.w600,
    );
  }

  /// Resolves the default [SafeButtonStyle] for the given [buttonType].
  static SafeButtonStyle defaultStyleFor(
    SafeButtonType buttonType,
    BuildContext context,
  ) {
    switch (buttonType) {
      case SafeButtonType.filled:
        return filledStyle(context);
      case SafeButtonType.outlined:
        return outlinedStyle(context);
      case SafeButtonType.text:
        return textStyle(context);
      case SafeButtonType.custom:
        return const SafeButtonStyle();
    }
  }

  /// Merges [user] style on top of [defaults], with user values taking
  /// precedence. Null user values fall back to the theme defaults.
  static SafeButtonStyle merge(SafeButtonStyle defaults, SafeButtonStyle user) {
    return SafeButtonStyle(
      width: user.width ?? defaults.width,
      height: user.height ?? defaults.height,
      padding: user.padding ?? defaults.padding,
      margin: user.margin ?? defaults.margin,
      alignment: user.alignment ?? defaults.alignment,
      borderRadius: user.borderRadius ?? defaults.borderRadius,
      borderColor: user.borderColor ?? defaults.borderColor,
      borderWidth: user.borderWidth ?? defaults.borderWidth,
      backgroundColor: user.backgroundColor ?? defaults.backgroundColor,
      foregroundColor: user.foregroundColor ?? defaults.foregroundColor,
      disabledColor: user.disabledColor ?? defaults.disabledColor,
      loadingColor: user.loadingColor ?? defaults.loadingColor,
      shadows: user.shadows ?? defaults.shadows,
      elevation: user.elevation ?? defaults.elevation,
      textStyle: user.textStyle ?? defaults.textStyle,
      fontSize: user.fontSize ?? defaults.fontSize,
      fontWeight: user.fontWeight ?? defaults.fontWeight,
      iconSpacing: user.iconSpacing ?? defaults.iconSpacing,
      loaderPosition: user.loaderPosition,
      splashFactory: user.splashFactory ?? defaults.splashFactory,
      animationDuration:
          user.animationDuration ?? defaults.animationDuration,
    );
  }
}
