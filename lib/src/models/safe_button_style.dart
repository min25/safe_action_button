import 'package:flutter/material.dart';
import '../enums/loader_position.dart';

/// Encapsulates all visual styling properties for a [SafeActionButton].
///
/// Pass a [SafeButtonStyle] to [SafeActionButton.style] to customise the
/// button's appearance without affecting its behaviour.
class SafeButtonStyle {
  /// Creates a [SafeButtonStyle].
  const SafeButtonStyle({
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    this.borderRadius,
    this.borderColor,
    this.borderWidth,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledColor,
    this.loadingColor,
    this.shadows,
    this.elevation,
    this.textStyle,
    this.fontSize,
    this.fontWeight,
    this.iconSpacing,
    this.loaderPosition = LoaderPosition.center,
    this.splashFactory,
    this.animationDuration,
  });

  /// Optional fixed width. If `null`, the button sizes to its content.
  final double? width;

  /// Optional fixed height. Defaults to the theme's button height.
  final double? height;

  /// Inner padding of the button content.
  final EdgeInsetsGeometry? padding;

  /// Outer margin around the button.
  final EdgeInsetsGeometry? margin;

  /// Alignment of the content inside the button.
  final AlignmentGeometry? alignment;

  /// Corner radius for the button shape.
  final BorderRadius? borderRadius;

  /// Border colour (used for [SafeButtonType.outlined]).
  final Color? borderColor;

  /// Border width (used for [SafeButtonType.outlined]).
  final double? borderWidth;

  /// Background fill colour.
  final Color? backgroundColor;

  /// Text / icon colour.
  final Color? foregroundColor;

  /// Background colour when the button is disabled.
  final Color? disabledColor;

  /// Colour of the default circular progress indicator while loading.
  final Color? loadingColor;

  /// List of box shadows applied to the button container.
  final List<BoxShadow>? shadows;

  /// Material elevation for filled buttons.
  final double? elevation;

  /// Custom text style for the label. [fontSize] and [fontWeight] are applied
  /// on top of this if they are also provided.
  final TextStyle? textStyle;

  /// Shorthand for setting the label font size.
  final double? fontSize;

  /// Shorthand for setting the label font weight.
  final FontWeight? fontWeight;

  /// Spacing between the icon and the label text.
  final double? iconSpacing;

  /// Where the loading indicator is displayed relative to the label.
  final LoaderPosition loaderPosition;

  /// Custom splash / ripple factory.
  final InteractiveInkFeatureFactory? splashFactory;

  /// Duration of the animated state transitions (loading / cooldown fade).
  final Duration? animationDuration;

  /// Creates a copy of this style with the given fields replaced.
  SafeButtonStyle copyWith({
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    BorderRadius? borderRadius,
    Color? borderColor,
    double? borderWidth,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? disabledColor,
    Color? loadingColor,
    List<BoxShadow>? shadows,
    double? elevation,
    TextStyle? textStyle,
    double? fontSize,
    FontWeight? fontWeight,
    double? iconSpacing,
    LoaderPosition? loaderPosition,
    InteractiveInkFeatureFactory? splashFactory,
    Duration? animationDuration,
  }) {
    return SafeButtonStyle(
      width: width ?? this.width,
      height: height ?? this.height,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      alignment: alignment ?? this.alignment,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      disabledColor: disabledColor ?? this.disabledColor,
      loadingColor: loadingColor ?? this.loadingColor,
      shadows: shadows ?? this.shadows,
      elevation: elevation ?? this.elevation,
      textStyle: textStyle ?? this.textStyle,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      iconSpacing: iconSpacing ?? this.iconSpacing,
      loaderPosition: loaderPosition ?? this.loaderPosition,
      splashFactory: splashFactory ?? this.splashFactory,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SafeButtonStyle &&
        other.width == width &&
        other.height == height &&
        other.padding == padding &&
        other.margin == margin &&
        other.alignment == alignment &&
        other.borderRadius == borderRadius &&
        other.borderColor == borderColor &&
        other.borderWidth == borderWidth &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.disabledColor == disabledColor &&
        other.loadingColor == loadingColor &&
        other.elevation == elevation &&
        other.textStyle == textStyle &&
        other.fontSize == fontSize &&
        other.fontWeight == fontWeight &&
        other.iconSpacing == iconSpacing &&
        other.loaderPosition == loaderPosition &&
        other.splashFactory == splashFactory &&
        other.animationDuration == animationDuration;
  }

  @override
  int get hashCode => Object.hashAll([
        width,
        height,
        padding,
        margin,
        alignment,
        borderRadius,
        borderColor,
        borderWidth,
        backgroundColor,
        foregroundColor,
        disabledColor,
        loadingColor,
        elevation,
        textStyle,
        fontSize,
        fontWeight,
        iconSpacing,
        loaderPosition,
        splashFactory,
        animationDuration,
      ]);
}
