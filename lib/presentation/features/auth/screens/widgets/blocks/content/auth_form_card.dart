import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../providers/auth_session_provider.dart';
import 'auth_form_fields.dart';

class AuthFormCard extends StatelessWidget {
  const AuthFormCard({
    required this.mode,
    required this.authState,
    required this.usernameController,
    required this.emailController,
    required this.identifierController,
    required this.passwordController,
    required this.passwordObscured,
    required this.onModeChanged,
    required this.onSubmit,
    super.key,
  });

  final AuthScreenModeState mode;
  final AuthViewState authState;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final bool passwordObscured;
  final ValueChanged<AuthScreenModeState> onModeChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return LumosCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LumosText(l10n.authTitle, style: LumosTextStyle.displaySmall),
            const SizedBox(height: AppSpacing.sm),
            LumosText(l10n.authSubtitle, style: LumosTextStyle.bodyMedium),
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
              onSelectionChanged: (Set<AuthScreenModeState> nextValue) {
                onModeChanged(nextValue.first);
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            AuthFormFields(
              mode: mode,
              usernameController: usernameController,
              emailController: emailController,
              identifierController: identifierController,
              passwordController: passwordController,
              passwordObscured: passwordObscured,
            ),
            if (authState.errorMessage
                case final String errorMessage) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              LumosText(errorMessage, style: LumosTextStyle.bodySmall),
            ],
            const SizedBox(height: AppSpacing.lg),
            LumosPrimaryButton(
              onPressed: authState.isBusy ? null : onSubmit,
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
    );
  }
}
