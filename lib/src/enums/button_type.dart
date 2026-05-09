/// Defines the visual style variant of a [SafeActionButton].
enum SafeButtonType {
  /// A filled/elevated button (solid background colour).
  filled,

  /// A button with a visible border and transparent background.
  outlined,

  /// A text-only button with no border or background.
  text,

  /// A fully custom button — the [child] widget is rendered as-is inside a
  /// [GestureDetector]. All default styling is bypassed.
  custom,
}
