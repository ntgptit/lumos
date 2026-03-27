import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_routes.dart';
import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../shared/widgets/lumos_widgets.dart';
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
    final AsyncValue<AuthViewState> authAsync = ref.watch(
      authSessionControllerProvider,
    );
    final AuthScreenModeState mode = ref.watch(
      authScreenModeControllerProvider,
    );
    final bool passwordObscured = ref.watch(
      authPasswordVisibilityControllerProvider,
    );
    return authAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: LumosLoadingIndicator())),
      error: (Object error, StackTrace stackTrace) {
        return Scaffold(
          body: Center(
            child: LumosErrorState(
              errorMessage: error.toString(),
              onRetry: () {
                ref.invalidate(authSessionControllerProvider);
              },
            ),
          ),
        );
      },
      data: (AuthViewState authState) {
        if (authState.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            context.goNamed(AppRouteName.home);
          });
        }
        final double screenPadding = ResponsiveDimensions.compactValue(
          context: context,
          baseValue: AppSpacing.xl,
          minScale: ResponsiveDimensions.compactLargeInsetScale,
        );
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(screenPadding),
                  child: AuthFormCard(
                    mode: mode,
                    authState: authState,
                    usernameController: _usernameController,
                    emailController: _emailController,
                    identifierController: _identifierController,
                    passwordController: _passwordController,
                    passwordObscured: passwordObscured,
                    onModeChanged: (AuthScreenModeState nextMode) {
                      ref
                          .read(authScreenModeControllerProvider.notifier)
                          .setMode(nextMode);
                    },
                    onSubmit: () {
                      _submit(mode: mode);
                    },
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
    final AuthSessionController controller = ref.read(
      authSessionControllerProvider.notifier,
    );
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
