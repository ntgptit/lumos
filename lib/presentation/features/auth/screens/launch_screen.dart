import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/app/app_route_data.dart';
import 'package:lumos/presentation/shared/composites/states/app_error_state.dart';
import 'package:lumos/presentation/shared/primitives/feedback/app_circular_loader.dart';
import '../providers/auth_session_provider.dart';

class LaunchScreen extends ConsumerWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authSessionControllerProvider);

    return authAsync.when(
      loading: () => const Scaffold(body: Center(child: AppCircularLoader())),
      error: (Object error, StackTrace stackTrace) {
        return Scaffold(
          body: AppErrorState(message: error.toString()),
        );
      },
      data: (AuthViewState state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          if (state.isAuthenticated) {
            const DashboardRouteData().go(context);
            return;
          }
          const LoginRouteData().go(context);
        });
        return const Scaffold(body: Center(child: AppCircularLoader()));
      },
    );
  }
}
