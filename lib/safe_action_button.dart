/// A production-ready Flutter package that provides a highly configurable
/// SafeActionButton system. Prevents duplicate taps, duplicate async API calls,
/// and accidental multiple executions.
///
/// ## Features
/// - Prevents multiple rapid taps (debounce / cooldown)
/// - Supports async callbacks with loading state management
/// - Multiple button variants: filled, outlined, text, and custom
/// - Fully customizable styling and loading widgets
/// - Controller API for programmatic control
/// - Optional haptic feedback
/// - Accessibility / semantics support
/// - Zero external dependencies
library safe_action_button;

export 'src/controllers/safe_action_button_controller.dart';
export 'src/enums/button_type.dart';
export 'src/enums/cooldown_mode.dart';
export 'src/enums/loader_position.dart';
export 'src/models/safe_button_style.dart';
export 'src/styles/safe_button_theme.dart';
export 'src/utils/debounce_timer.dart';
export 'src/utils/throttle_timer.dart';
export 'src/widgets/safe_action_button.dart';
export 'src/widgets/safe_button_loader.dart';
