import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/route_names.dart';
import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../l10n/app_localizations.dart';
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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
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
                          LumosText(
                            l10n.authTitle,
                            style: LumosTextStyle.displaySmall,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          LumosText(
                            l10n.authSubtitle,
                            style: LumosTextStyle.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          SegmentedButton<AuthScreenModeState>(
                            segments: <ButtonSegment<AuthScreenModeState>>[
                              ButtonSegment<AuthScreenModeState>(
                                value: AuthScreenModeState.login,
                                label: LumosText(l10n.authLoginTab),
                              ),
                              ButtonSegment<AuthScreenModeState>(
                                value: AuthScreenModeState.register,
                                label: LumosText(l10n.authRegisterTab),
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
                            context: context,
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
                                ? l10n.authSignInAction
                                : l10n.authCreateAccountAction,
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
    required BuildContext context,
    required AuthScreenModeState mode,
    required bool passwordObscured,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (mode == AuthScreenModeState.register) {
      return <Widget>[
        LumosTextField(
          controller: _usernameController,
          label: l10n.authUsernameLabel,
        ),
        const SizedBox(height: AppSpacing.md),
        LumosTextField(controller: _emailController, label: l10n.authEmailLabel),
        const SizedBox(height: AppSpacing.md),
        LumosTextField(
          controller: _passwordController,
          obscureText: passwordObscured,
          label: l10n.authPasswordLabel,
          suffixIcon: _buildPasswordToggle(context),
        ),
      ];
    }
    return <Widget>[
      LumosTextField(
        controller: _identifierController,
        label: l10n.authUsernameOrEmailLabel,
      ),
      const SizedBox(height: AppSpacing.md),
      LumosTextField(
        controller: _passwordController,
        obscureText: passwordObscured,
        label: l10n.authPasswordLabel,
        suffixIcon: _buildPasswordToggle(context),
      ),
    ];
  }

  Widget _buildPasswordToggle(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
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
      tooltip: passwordObscured
          ? l10n.authShowPasswordTooltip
          : l10n.authHidePasswordTooltip,
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
