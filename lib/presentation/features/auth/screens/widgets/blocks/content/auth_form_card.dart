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
    final double cardPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.xl,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double sectionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double titleGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.xl,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    return LumosCard(
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LumosText(l10n.authTitle, style: LumosTextStyle.displaySmall),
            const SizedBox(height: AppSpacing.sm),
            LumosText(l10n.authSubtitle, style: LumosTextStyle.bodyMedium),
            SizedBox(height: titleGap),
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
            SizedBox(height: sectionGap),
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
            SizedBox(height: sectionGap),
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
