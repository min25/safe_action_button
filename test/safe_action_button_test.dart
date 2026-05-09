import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_action_button/safe_action_button.dart';

void main() {
  // ── Controller tests ─────────────────────────────────────────────────────
  group('SafeActionButtonController', () {
    test('initial state is interactable', () {
      final ctrl = SafeActionButtonController();
      expect(ctrl.isLoading, isFalse);
      expect(ctrl.isDisabled, isFalse);
      expect(ctrl.isInCooldown, isFalse);
      expect(ctrl.isInteractable, isTrue);
      ctrl.dispose();
    });

    test('startLoading / stopLoading toggle isLoading', () {
      final ctrl = SafeActionButtonController();
      ctrl.startLoading();
      expect(ctrl.isLoading, isTrue);
      expect(ctrl.isInteractable, isFalse);
      ctrl.stopLoading();
      expect(ctrl.isLoading, isFalse);
      expect(ctrl.isInteractable, isTrue);
      ctrl.dispose();
    });

    test('disable / enable toggle isDisabled', () {
      final ctrl = SafeActionButtonController();
      ctrl.disable();
      expect(ctrl.isDisabled, isTrue);
      expect(ctrl.isInteractable, isFalse);
      ctrl.enable();
      expect(ctrl.isDisabled, isFalse);
      expect(ctrl.isInteractable, isTrue);
      ctrl.dispose();
    });

    test('triggerCooldown sets isInCooldown and remainingCooldown', () {
      final ctrl = SafeActionButtonController();
      ctrl.triggerCooldown(duration: const Duration(seconds: 5));
      expect(ctrl.isInCooldown, isTrue);
      expect(ctrl.remainingCooldown, const Duration(seconds: 5));
      expect(ctrl.isInteractable, isFalse);
      ctrl.dispose();
    });

    test('resetCooldown immediately clears cooldown', () {
      final ctrl = SafeActionButtonController();
      ctrl.triggerCooldown(duration: const Duration(seconds: 10));
      ctrl.resetCooldown();
      expect(ctrl.isInCooldown, isFalse);
      expect(ctrl.remainingCooldown, isNull);
      expect(ctrl.isInteractable, isTrue);
      ctrl.dispose();
    });

    test('notifyListeners fires on state changes', () {
      final ctrl = SafeActionButtonController();
      int callCount = 0;
      ctrl.addListener(() => callCount++);

      ctrl.startLoading();
      expect(callCount, 1);
      ctrl.stopLoading();
      expect(callCount, 2);
      ctrl.disable();
      expect(callCount, 3);
      ctrl.enable();
      expect(callCount, 4);

      ctrl.dispose();
    });

    test('double startLoading is idempotent', () {
      final ctrl = SafeActionButtonController();
      int callCount = 0;
      ctrl.addListener(() => callCount++);
      ctrl.startLoading();
      ctrl.startLoading(); // should be no-op
      expect(callCount, 1);
      ctrl.dispose();
    });
  });

  // ── Widget tests ─────────────────────────────────────────────────────────
  group('SafeActionButton widget', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SafeActionButton.filled(
            label: 'Tap Me',
            onTap: () async { return null; },
          ),
        ),
      ));
      expect(find.text('Tap Me'), findsOneWidget);
    });

    testWidgets('shows loader on tap', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SafeActionButton.filled(
            label: 'Loading Test',
            cooldownDuration: Duration.zero,
            onTap: () async {
              await Future.delayed(const Duration(milliseconds: 500));
              return null;
            },
          ),
        ),
      ));

      await tester.tap(find.byType(SafeActionButton));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('ignores second tap while loading', (tester) async {
      int tapCount = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SafeActionButton.filled(
            label: 'Tap',
            cooldownDuration: Duration.zero,
            onTap: () async {
              tapCount++;
              await Future.delayed(const Duration(milliseconds: 300));
              return null;
            },
          ),
        ),
      ));

      await tester.tap(find.byType(SafeActionButton));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byType(SafeActionButton)); // should be ignored
      await tester.pumpAndSettle();
      expect(tapCount, 1);
    });

    testWidgets('does not fire onTap when disabled', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SafeActionButton.filled(
            label: 'Disabled',
            isEnabled: false,
            onTap: () async { tapped = true; return null; },
          ),
        ),
      ));

      await tester.tap(find.byType(SafeActionButton), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(tapped, isFalse);
    });

    testWidgets('calls onError when onTap throws', (tester) async {
      Object? caughtError;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SafeActionButton.filled(
            label: 'Error',
            cooldownDuration: Duration.zero,
            onTap: () async => throw Exception('test error'),
            onError: (e, _) => caughtError = e,
          ),
        ),
      ));

      await tester.tap(find.byType(SafeActionButton));
      await tester.pumpAndSettle();
      expect(caughtError, isA<Exception>());
    });

    testWidgets('calls onCompleted after success', (tester) async {
      bool completed = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SafeActionButton.filled(
            label: 'Complete',
            cooldownDuration: Duration.zero,
            onTap: () async { return null; },
            onCompleted: () => completed = true,
          ),
        ),
      ));

      await tester.tap(find.byType(SafeActionButton));
      await tester.pumpAndSettle();
      expect(completed, isTrue);
    });

    testWidgets('outlined button renders with border', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SafeActionButton.outlined(
            label: 'Outlined',
            onTap: () async { return null; },
          ),
        ),
      ));
      expect(find.text('Outlined'), findsOneWidget);
    });

    testWidgets('text button renders', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SafeActionButton.text(
            label: 'Text',
            onTap: () async { return null; },
          ),
        ),
      ));
      expect(find.text('Text'), findsOneWidget);
    });

    testWidgets('custom button renders child', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SafeActionButton.custom(
            onTap: () async { return null; },
            child: const Text('Custom Child'),
          ),
        ),
      ));
      expect(find.text('Custom Child'), findsOneWidget);
    });

    testWidgets('custom loadingWidget is shown while loading', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SafeActionButton.filled(
            label: 'Upload',
            cooldownDuration: Duration.zero,
            loadingWidget: const Text('custom_loader'),
            onTap: () async => Future.delayed(const Duration(milliseconds: 300)),
          ),
        ),
      ));

      await tester.tap(find.byType(SafeActionButton));
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('custom_loader'), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });

  // ── Utility tests ─────────────────────────────────────────────────────────
  group('DebounceTimer', () {
    test('executes action after delay', () async {
      bool executed = false;
      final debounce = DebounceTimer(delay: const Duration(milliseconds: 100));
      debounce.run(() => executed = true);
      expect(executed, isFalse);
      await Future.delayed(const Duration(milliseconds: 150));
      expect(executed, isTrue);
      debounce.dispose();
    });

    test('cancels previous call on rapid calls', () async {
      int count = 0;
      final debounce = DebounceTimer(delay: const Duration(milliseconds: 100));
      debounce.run(() => count++);
      debounce.run(() => count++);
      debounce.run(() => count++);
      await Future.delayed(const Duration(milliseconds: 200));
      expect(count, 1);
      debounce.dispose();
    });
  });

  group('ThrottleTimer', () {
    test('executes first call immediately', () {
      bool executed = false;
      final throttle = ThrottleTimer(interval: const Duration(seconds: 1));
      throttle.run(() => executed = true);
      expect(executed, isTrue);
      throttle.dispose();
    });

    test('drops rapid subsequent calls', () {
      int count = 0;
      final throttle = ThrottleTimer(interval: const Duration(seconds: 1));
      throttle.run(() => count++);
      throttle.run(() => count++);
      throttle.run(() => count++);
      expect(count, 1);
      throttle.dispose();
    });
  });
}
