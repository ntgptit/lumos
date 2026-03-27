import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
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
    final EdgeInsets errorPadding = ResponsiveDimensions.compactInsets(
      context: context,
      baseInsets: const EdgeInsets.all(AppSpacing.lg),
    );
    return authAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: LumosLoadingIndicator())),
      error: (Object error, StackTrace stackTrace) {
        return Scaffold(
          body: Center(
            child: Padding(
              padding: errorPadding,
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
