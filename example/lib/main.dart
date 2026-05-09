import 'package:flutter/material.dart';
import 'package:safe_action_button/safe_action_button.dart';

void main() => runApp(const SafeActionButtonExampleApp());

class SafeActionButtonExampleApp extends StatelessWidget {
  const SafeActionButtonExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'safe_action_button Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const DemoHomePage(),
    );
  }
}

class DemoHomePage extends StatelessWidget {
  const DemoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('safe_action_button'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _SectionCard(title: '1 · Filled Button', child: _FilledDemo()),
          _SectionCard(title: '2 · Outlined Button', child: _OutlinedDemo()),
          _SectionCard(title: '3 · Text Button + Cooldown Timer', child: _TextDemo()),
          _SectionCard(title: '4 · Custom Loader Widget', child: _CustomLoaderDemo()),
          _SectionCard(title: '5 · API Simulation', child: _ApiSimDemo()),
          _SectionCard(title: '6 · Dynamic Cooldown', child: _DynamicCooldownDemo()),
          _SectionCard(title: '7 · Controller — Manual Reset', child: _ControllerDemo()),
          _SectionCard(title: '8 · Disabled State', child: _DisabledDemo()),
          _SectionCard(title: '9 · Error Handling', child: _ErrorDemo()),
          _SectionCard(title: '10 · Debounce Mode', child: _DebounceDemo()),
          _SectionCard(title: '11 · Throttle Mode', child: _ThrottleDemo()),
          _SectionCard(title: '12 · Icon + Label', child: _IconLabelDemo()),
          _SectionCard(title: '13 · Custom Container', child: _CustomContainerDemo()),
          _SectionCard(title: '14 · Loader Positions', child: _LoaderPositionDemo()),
        ],
      ),
    );
  }
}

// ─── Shared helpers ────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _Status extends StatelessWidget {
  const _Status(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(text,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.grey.shade600)),
    );
  }
}

// ─── 1. Filled ─────────────────────────────────────────────────────────────

class _FilledDemo extends StatefulWidget {
  const _FilledDemo();
  @override
  State<_FilledDemo> createState() => _FilledDemoState();
}

class _FilledDemoState extends State<_FilledDemo> {
  String _status = 'Idle';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SafeActionButton.filled(
        label: 'Save Changes',
        cooldownDuration: const Duration(seconds: 3),
        onTap: () async {
          setState(() => _status = 'Saving…');
          await Future.delayed(const Duration(seconds: 2));
          setState(() => _status = 'Saved! (3 s cooldown active)');
          return null;
        },
        onCooldownEnd: () => setState(() => _status = 'Ready'),
        onCompleted: () {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Completed!'), backgroundColor: Colors.green.shade700),
          );
        },
      ),
      _Status(_status),
    ]);
  }
}

// ─── 2. Outlined ───────────────────────────────────────────────────────────

class _OutlinedDemo extends StatefulWidget {
  const _OutlinedDemo();
  @override
  State<_OutlinedDemo> createState() => _OutlinedDemoState();
}

class _OutlinedDemoState extends State<_OutlinedDemo> {
  String _status = 'Idle';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SafeActionButton.outlined(
        label: 'Subscribe',
        cooldownDuration: const Duration(seconds: 2),
        onTap: () async {
          setState(() => _status = 'Subscribing…');
          await Future.delayed(const Duration(milliseconds: 1500));
          setState(() => _status = 'Subscribed ✓');
          return null;
        },
      ),
      _Status(_status),
    ]);
  }
}

// ─── 3. Text + Cooldown Timer ──────────────────────────────────────────────

class _TextDemo extends StatefulWidget {
  const _TextDemo();
  @override
  State<_TextDemo> createState() => _TextDemoState();
}

class _TextDemoState extends State<_TextDemo> {
  String _status = 'Idle';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SafeActionButton.text(
        label: 'Resend Email',
        cooldownDuration: const Duration(seconds: 5),
        showCooldownTimer: true,
        onTap: () async {
          setState(() => _status = 'Sending…');
          await Future.delayed(const Duration(seconds: 1));
          setState(() => _status = 'Sent! (5 s cooldown)');
          return null;
        },
        onCooldownEnd: () => setState(() => _status = 'Idle'),
      ),
      _Status(_status),
    ]);
  }
}

// ─── 4. Custom Loader ─────────────────────────────────────────────────────

class _CustomLoaderDemo extends StatelessWidget {
  const _CustomLoaderDemo();

  @override
  Widget build(BuildContext context) {
    return SafeActionButton.filled(
      label: 'Upload File',
      loadingWidget: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          ),
          SizedBox(width: 8),
          Text('Uploading…', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
      onTap: () async {
        await Future.delayed(const Duration(seconds: 3));
        return null;
      },
    );
  }
}

// ─── 5. API Simulation ────────────────────────────────────────────────────

class _ApiSimDemo extends StatefulWidget {
  const _ApiSimDemo();
  @override
  State<_ApiSimDemo> createState() => _ApiSimDemoState();
}

class _ApiSimDemoState extends State<_ApiSimDemo> {
  String _status = 'Ready';
  int _calls = 0;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SafeActionButton.filled(
        label: 'Call API',
        cooldownDuration: const Duration(seconds: 4),
        showCooldownTimer: true,
        onTap: () async {
          setState(() => _status = 'Calling API…');
          await Future.delayed(const Duration(seconds: 2));
          if (!mounted) return null;
          setState(() { _calls++; _status = 'Call #$_calls completed'; });
          return null;
        },
        onCooldownEnd: () => setState(() => _status = 'Ready'),
      ),
      _Status('$_status  |  Total calls: $_calls'),
    ]);
  }
}

// ─── 6. Dynamic Cooldown ──────────────────────────────────────────────────

class _DynamicCooldownDemo extends StatefulWidget {
  const _DynamicCooldownDemo();
  @override
  State<_DynamicCooldownDemo> createState() => _DynamicCooldownDemoState();
}

class _DynamicCooldownDemoState extends State<_DynamicCooldownDemo> {
  String _status = 'Idle';

  Future<Duration?> _apiWithRetryAfter() async {
    setState(() => _status = 'Calling API…');
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _status = 'Server says: retry after 6 s');
    return const Duration(seconds: 6);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SafeActionButton.filled(
        label: 'Submit (Dynamic Cooldown)',
        cooldownMode: CooldownMode.dynamic,
        showCooldownTimer: true,
        onTap: _apiWithRetryAfter,
        onCooldownEnd: () => setState(() => _status = 'Idle'),
      ),
      _Status(_status),
    ]);
  }
}

// ─── 7. Controller Demo ───────────────────────────────────────────────────

class _ControllerDemo extends StatefulWidget {
  const _ControllerDemo();
  @override
  State<_ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<_ControllerDemo> {
  final _ctrl = SafeActionButtonController();
  String _status = 'Idle';

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SafeActionButton.filled(
        label: 'Submit (Manual Cooldown)',
        controller: _ctrl,
        cooldownMode: CooldownMode.manual,
        onTap: () async {
          setState(() => _status = 'Processing…');
          await Future.delayed(const Duration(seconds: 2));
          setState(() => _status = 'Done — tap Reset to re-enable');
          return null;
        },
      ),
      const SizedBox(height: 12),
      Row(children: [
        Expanded(child: OutlinedButton(
          onPressed: () { _ctrl.resetCooldown(); setState(() => _status = 'Reset!'); },
          child: const Text('Reset'),
        )),
        const SizedBox(width: 8),
        Expanded(child: OutlinedButton(
          onPressed: () { _ctrl.disable(); setState(() => _status = 'Disabled'); },
          child: const Text('Disable'),
        )),
        const SizedBox(width: 8),
        Expanded(child: OutlinedButton(
          onPressed: () { _ctrl.enable(); setState(() => _status = 'Enabled'); },
          child: const Text('Enable'),
        )),
      ]),
      _Status(_status),
    ]);
  }
}

// ─── 8. Disabled State ────────────────────────────────────────────────────

class _DisabledDemo extends StatefulWidget {
  const _DisabledDemo();
  @override
  State<_DisabledDemo> createState() => _DisabledDemoState();
}

class _DisabledDemoState extends State<_DisabledDemo> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SafeActionButton.filled(
        label: _enabled ? 'Tap Me!' : 'I am Disabled',
        isEnabled: _enabled,
        onTap: () async {
          await Future.delayed(const Duration(seconds: 1));
          return null;
        },
      ),
      const SizedBox(height: 12),
      Switch.adaptive(value: _enabled, onChanged: (v) => setState(() => _enabled = v)),
      _Status(_enabled ? 'Enabled' : 'Disabled'),
    ]);
  }
}

// ─── 9. Error Handling ────────────────────────────────────────────────────

class _ErrorDemo extends StatefulWidget {
  const _ErrorDemo();
  @override
  State<_ErrorDemo> createState() => _ErrorDemoState();
}

class _ErrorDemoState extends State<_ErrorDemo> {
  String _status = 'Idle';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SafeActionButton.outlined(
        label: 'Trigger Error',
        onTap: () async {
          setState(() => _status = 'Calling…');
          await Future.delayed(const Duration(seconds: 1));
          throw Exception('Network unavailable');
        },
        onError: (error, _) {
          setState(() => _status = '❌ $error');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error'), backgroundColor: Colors.red.shade700),
          );
        },
      ),
      _Status(_status),
    ]);
  }
}

// ─── 10. Debounce Mode ────────────────────────────────────────────────────

class _DebounceDemo extends StatefulWidget {
  const _DebounceDemo();
  @override
  State<_DebounceDemo> createState() => _DebounceDemoState();
}

class _DebounceDemoState extends State<_DebounceDemo> {
  int _execs = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SafeActionButton.filled(
        label: 'Debounced (600 ms)',
        debounceMode: true,
        debounceDuration: const Duration(milliseconds: 600),
        cooldownDuration: Duration.zero,
        onTap: () async { setState(() => _execs++); return null; },
      ),
      _Status('Executions: $_execs (tap rapidly — only last fires)'),
    ]);
  }
}

// ─── 11. Throttle Mode ────────────────────────────────────────────────────

class _ThrottleDemo extends StatefulWidget {
  const _ThrottleDemo();
  @override
  State<_ThrottleDemo> createState() => _ThrottleDemoState();
}

class _ThrottleDemoState extends State<_ThrottleDemo> {
  int _execs = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SafeActionButton.filled(
        label: 'Throttled (1 per 3 s)',
        throttleMode: true,
        throttleDuration: const Duration(seconds: 3),
        cooldownDuration: Duration.zero,
        onTap: () async { setState(() => _execs++); return null; },
      ),
      _Status('Executions: $_execs (tap rapidly to test)'),
    ]);
  }
}

// ─── 12. Icon + Label ─────────────────────────────────────────────────────

class _IconLabelDemo extends StatelessWidget {
  const _IconLabelDemo();

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 12, runSpacing: 12, children: [
      SafeActionButton.filled(
        label: 'Download',
        icon: const Icon(Icons.download_rounded),
        onTap: () async { await Future.delayed(const Duration(seconds: 2)); return null; },
      ),
      SafeActionButton.outlined(
        label: 'Share',
        icon: const Icon(Icons.share_rounded),
        onTap: () async { await Future.delayed(const Duration(seconds: 1)); return null; },
      ),
      SafeActionButton.text(
        label: 'Delete',
        icon: const Icon(Icons.delete_outline_rounded),
        style: const SafeButtonStyle(foregroundColor: Colors.red),
        onTap: () async { await Future.delayed(const Duration(seconds: 1)); return null; },
      ),
    ]);
  }
}

// ─── 13. Custom Container ─────────────────────────────────────────────────

class _CustomContainerDemo extends StatefulWidget {
  const _CustomContainerDemo();
  @override
  State<_CustomContainerDemo> createState() => _CustomContainerDemoState();
}

class _CustomContainerDemoState extends State<_CustomContainerDemo> {
  String _status = 'Idle';

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SafeActionButton.custom(
        cooldownDuration: const Duration(seconds: 2),
        onTap: () async {
          setState(() => _status = 'Tapped!');
          await Future.delayed(const Duration(seconds: 1));
          setState(() => _status = 'Done — cooldown active');
          return null;
        },
        onCooldownEnd: () => setState(() => _status = 'Idle'),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.tertiary,
            ]),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withAlpha(80),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Text('✨ Custom Gradient Button',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
      _Status(_status),
    ]);
  }
}

// ─── 14. Loader Positions ─────────────────────────────────────────────────

class _LoaderPositionDemo extends StatelessWidget {
  const _LoaderPositionDemo();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      SafeActionButton.filled(
        label: 'Loader Left',
        hapticFeedback: true,
        style: const SafeButtonStyle(loaderPosition: LoaderPosition.left),
        onTap: () async { await Future.delayed(const Duration(seconds: 2)); return null; },
      ),
      const SizedBox(height: 12),
      SafeActionButton.filled(
        label: 'Loader Right',
        hapticFeedback: true,
        style: const SafeButtonStyle(loaderPosition: LoaderPosition.right),
        onTap: () async { await Future.delayed(const Duration(seconds: 2)); return null; },
      ),
      const SizedBox(height: 12),
      SafeActionButton.filled(
        label: 'Loader Center',
        hapticFeedback: true,
        onTap: () async { await Future.delayed(const Duration(seconds: 2)); return null; },
      ),
    ]);
  }
}
