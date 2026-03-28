import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/app/app_route_data.dart';
import 'package:lumos/core/theme/app_foundation.dart';
import '../../auth/providers/auth_session_provider.dart';
import '../providers/home_provider.dart';
import 'widgets/blocks/content/shell/home_navigation_scaffold.dart';

export '../constants/home_contract.dart'
    show HomeScreenKeys, HomeScreenSemantics;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(homeControllerProvider);
    final AsyncValue<AuthViewState> authAsync = ref.watch(
      authSessionControllerProvider,
    );
    return authAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: LumosLoadingIndicator())),
      error: (Object error, StackTrace stackTrace) {
        return const Scaffold(body: Center(child: LumosLoadingIndicator()));
      },
      data: (AuthViewState state) {
        if (!state.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) {
              return;
            }
            const AuthRouteData().go(context);
          });
        }
        return HomeNavigationScaffold(
          deviceType: context.deviceType,
          useNavigationRail: context.deviceType != DeviceType.mobile,
        );
      },
    );
  }
}

