import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/app/app_route_data.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/layouts/lumos_scaffold.dart';
import 'package:lumos/presentation/shared/screens/lumos_splash_screen.dart';
import '../providers/auth_session_provider.dart';

class LaunchScreen extends ConsumerWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authSessionControllerProvider);

    return authAsync.when(
      loading: () => const LumosSplashScreen(),
      error: (Object error, StackTrace stackTrace) {
        return LumosScaffold(
          bodyPadding: EdgeInsets.zero,
          body: LumosErrorState(
            message: error.toString(),
            primaryActionLabel: context.l10n.commonRetry,
            onPrimaryAction: () {
              ref.invalidate(authSessionControllerProvider);
            },
          ),
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
        return const LumosSplashScreen();
      },
    );
  }
}
