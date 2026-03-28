import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/app/app_route_data.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/states/app_error_state.dart';
import 'package:lumos/presentation/shared/primitives/feedback/app_circular_loader.dart';
import '../providers/auth_session_provider.dart';
import 'widgets/blocks/content/auth_form_card.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authSessionControllerProvider);
    final mode = ref.watch(authScreenModeControllerProvider);

    return authAsync.when(
      loading: () => const Scaffold(body: Center(child: AppCircularLoader())),
      error: (Object error, StackTrace stackTrace) {
        return Scaffold(
          body: AppErrorState(
            message: error.toString(),
            primaryActionLabel: context.l10n.commonRetry,
            onPrimaryAction: () {
              ref.invalidate(authSessionControllerProvider);
            },
          ),
        );
      },
      data: (AuthViewState authState) {
        if (authState.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            const DashboardRouteData().go(context);
          });
        }
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(context.spacing.xl),
                  child: AuthFormCard(
                    mode: mode,
                    authState: authState,
                    usernameController: _usernameController,
                    emailController: _emailController,
                    identifierController: _identifierController,
                    passwordController: _passwordController,
                    onModeChanged: (AuthScreenModeState nextMode) {
                      ref
                          .read(authScreenModeControllerProvider.notifier)
                          .setMode(nextMode);
                    },
                    onSubmit: () => _submit(mode: mode),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submit({required AuthScreenModeState mode}) async {
    final controller = ref.read(authSessionControllerProvider.notifier);
    if (mode == AuthScreenModeState.login) {
      await controller.login(
        identifier: _identifierController.text,
        password: _passwordController.text,
      );
      return;
    }
    await controller.register(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }
}
