import 'package:flutter/material.dart';
import '../styles/safe_button_theme.dart';

/// A default animated loading widget used inside [SafeActionButton].
///
/// Displays a [CircularProgressIndicator] with configurable size, stroke
/// width, and colour. The widget animates in/out with a fade transition.
///
/// You can replace this entirely by passing a custom [Widget] to the
/// `loadingWidget` parameter of [SafeActionButton].
class SafeButtonLoader extends StatelessWidget {
  /// Creates a [SafeButtonLoader].
  const SafeButtonLoader({
    super.key,
    this.color,
    this.size = SafeButtonTheme.kDefaultLoaderSize,
    this.strokeWidth = SafeButtonTheme.kDefaultLoaderStrokeWidth,
  });

  /// Colour of the circular indicator. Falls back to the button's
  /// [SafeButtonStyle.loadingColor] if not provided.
  final Color? color;

  /// Diameter of the circular indicator in logical pixels.
  final double size;

  /// Stroke width of the circular indicator arc.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final effectiveColor =
        color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
        strokeCap: StrokeCap.round,
      ),
    );
  }
}
