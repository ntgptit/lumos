import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../providers/auth_session_provider.dart';

class LaunchScreen extends ConsumerWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AuthViewState> authAsync = ref.watch(
      authSessionControllerProvider,
    );
    return authAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: LumosLoadingIndicator())),
      error: (Object error, StackTrace stackTrace) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: LumosText(
                error.toString(),
                style: LumosTextStyle.bodySmall,
              ),
            ),
          ),
        );
      },
      data: (AuthViewState state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) {
            return;
          }
          if (state.isAuthenticated) {
            context.goNamed(AppRouteName.home);
            return;
          }
          context.goNamed(AppRouteName.auth);
        });
        return const Scaffold(body: Center(child: LumosLoadingIndicator()));
      },
    );
  }
}
