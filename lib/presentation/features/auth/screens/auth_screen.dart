import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../providers/auth_session_provider.dart';

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
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: LumosCard(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const LumosText(
                            'Lumos',
                            style: LumosTextStyle.displaySmall,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          const LumosText(
                            'Authenticate first, then resume study from canonical backend state.',
                            style: LumosTextStyle.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          SegmentedButton<AuthScreenModeState>(
                            segments:
                                const <ButtonSegment<AuthScreenModeState>>[
                                  ButtonSegment<AuthScreenModeState>(
                                    value: AuthScreenModeState.login,
                                    label: LumosText('Login'),
                                  ),
                                  ButtonSegment<AuthScreenModeState>(
                                    value: AuthScreenModeState.register,
                                    label: LumosText('Register'),
                                  ),
                                ],
                            selected: <AuthScreenModeState>{mode},
                            onSelectionChanged:
                                (Set<AuthScreenModeState> nextValue) {
                                  ref
                                      .read(
                                        authScreenModeControllerProvider
                                            .notifier,
                                      )
                                      .setMode(nextValue.first);
                                },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          ..._buildFields(
                            mode: mode,
                            passwordObscured: passwordObscured,
                          ),
                          if (authState.errorMessage
                              case final String errorMessage) ...<Widget>[
                            const SizedBox(height: AppSpacing.md),
                            LumosText(
                              errorMessage,
                              style: LumosTextStyle.bodySmall,
                            ),
                          ],
                          const SizedBox(height: AppSpacing.lg),
                          LumosPrimaryButton(
                            onPressed: authState.isBusy
                                ? null
                                : () => _submit(mode: mode),
                            label: mode == AuthScreenModeState.login
                                ? 'Sign in'
                                : 'Create account',
                            icon: mode == AuthScreenModeState.login
                                ? Icons.login_rounded
                                : Icons.person_add_alt_1_rounded,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildFields({
    required AuthScreenModeState mode,
    required bool passwordObscured,
  }) {
    if (mode == AuthScreenModeState.register) {
      return <Widget>[
        LumosTextField(controller: _usernameController, label: 'Username'),
        const SizedBox(height: AppSpacing.md),
        LumosTextField(controller: _emailController, label: 'Email'),
        const SizedBox(height: AppSpacing.md),
        LumosTextField(
          controller: _passwordController,
          obscureText: passwordObscured,
          label: 'Password',
          suffixIcon: _buildPasswordToggle(),
        ),
      ];
    }
    return <Widget>[
      LumosTextField(
        controller: _identifierController,
        label: 'Username or email',
      ),
      const SizedBox(height: AppSpacing.md),
      LumosTextField(
        controller: _passwordController,
        obscureText: passwordObscured,
        label: 'Password',
        suffixIcon: _buildPasswordToggle(),
      ),
    ];
  }

  Widget _buildPasswordToggle() {
    final bool passwordObscured = ref.watch(
      authPasswordVisibilityControllerProvider,
    );
    return LumosIconButton(
      onPressed: () {
        ref.read(authPasswordVisibilityControllerProvider.notifier).toggle();
      },
      icon: Icons.visibility_rounded,
      selectedIcon: Icons.visibility_off_rounded,
      selected: !passwordObscured,
      tooltip: passwordObscured ? 'Show password' : 'Hide password',
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
