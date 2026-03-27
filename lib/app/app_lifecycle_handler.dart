import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/app/app_providers.dart';
import 'package:lumos/core/utils/logger.dart';

class AppLifecycleHandler extends ConsumerStatefulWidget {
  const AppLifecycleHandler({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLifecycleHandler> createState() {
    return _AppLifecycleHandlerState();
  }
}

class _AppLifecycleHandlerState extends ConsumerState<AppLifecycleHandler>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final initialState = WidgetsBinding.instance.lifecycleState;
    if (initialState != null) {
      ref
          .read(lifecycleStateControllerProvider.notifier)
          .setLifecycle(initialState);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Logger.debug('Observed lifecycle state: $state');
    ref.read(lifecycleStateControllerProvider.notifier).setLifecycle(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
