import 'package:flutter/widgets.dart';

class AppLifecycleHandler extends StatefulWidget {
  const AppLifecycleHandler({
    required this.child,
    this.onDetached,
    this.onHidden,
    this.onInactive,
    this.onPaused,
    this.onResumed,
    this.onStateChanged,
    super.key,
  });

  final Widget child;
  final VoidCallback? onDetached;
  final VoidCallback? onHidden;
  final VoidCallback? onInactive;
  final VoidCallback? onPaused;
  final VoidCallback? onResumed;
  final ValueChanged<AppLifecycleState>? onStateChanged;

  @override
  State<AppLifecycleHandler> createState() {
    return _AppLifecycleHandlerState();
  }
}

class _AppLifecycleHandlerState extends State<AppLifecycleHandler>
    with WidgetsBindingObserver {
  AppLifecycleState? _lastLifecycleState;

  bool get _shouldObserveLifecycle {
    return widget.onStateChanged != null ||
        widget.onDetached != null ||
        widget.onHidden != null ||
        widget.onInactive != null ||
        widget.onPaused != null ||
        widget.onResumed != null;
  }

  @override
  void initState() {
    super.initState();
    if (!_shouldObserveLifecycle) {
      return;
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(covariant AppLifecycleHandler oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool shouldObservePrevious =
        oldWidget.onStateChanged != null ||
        oldWidget.onDetached != null ||
        oldWidget.onHidden != null ||
        oldWidget.onInactive != null ||
        oldWidget.onPaused != null ||
        oldWidget.onResumed != null;
    if (shouldObservePrevious == _shouldObserveLifecycle) {
      return;
    }
    if (_shouldObserveLifecycle) {
      WidgetsBinding.instance.addObserver(this);
      return;
    }
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_lastLifecycleState == state) {
      return;
    }
    _lastLifecycleState = state;
    widget.onStateChanged?.call(state);

    switch (state) {
      case AppLifecycleState.detached:
        widget.onDetached?.call();
        return;
      case AppLifecycleState.hidden:
        widget.onHidden?.call();
        return;
      case AppLifecycleState.inactive:
        widget.onInactive?.call();
        return;
      case AppLifecycleState.paused:
        widget.onPaused?.call();
        return;
      case AppLifecycleState.resumed:
        widget.onResumed?.call();
        return;
    }
  }

  @override
  void dispose() {
    if (_shouldObserveLifecycle) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
