import 'package:flutter/material.dart';

import 'package:lumos/core/enums/snackbar_type.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_card.dart';
import 'package:lumos/presentation/shared/primitives/feedback/app_banner.dart';
import 'package:lumos/presentation/shared/primitives/text/app_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/app_title_text.dart';
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
  final ValueChanged<AuthScreenModeState> onModeChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCard(
      padding: EdgeInsets.all(context.spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppTitleText(text: l10n.authTitle),
          SizedBox(height: context.spacing.xs),
          AppBodyText(text: l10n.authSubtitle, isSecondary: true),
          SizedBox(height: context.spacing.xl),
          SegmentedButton<AuthScreenModeState>(
            segments: <ButtonSegment<AuthScreenModeState>>[
              ButtonSegment<AuthScreenModeState>(
                value: AuthScreenModeState.login,
                label: Text(l10n.authLoginTab),
              ),
              ButtonSegment<AuthScreenModeState>(
                value: AuthScreenModeState.register,
                label: Text(l10n.authRegisterTab),
              ),
            ],
            selected: <AuthScreenModeState>{mode},
            onSelectionChanged: (Set<AuthScreenModeState> nextValue) {
              onModeChanged(nextValue.first);
            },
          ),
          SizedBox(height: context.spacing.lg),
          AuthFormFields(
            mode: mode,
            usernameController: usernameController,
            emailController: emailController,
            identifierController: identifierController,
            passwordController: passwordController,
          ),
          if (authState.errorMessage case final String errorMessage) ...<Widget>[
            SizedBox(height: context.spacing.md),
            AppBanner(
              message: errorMessage,
              type: SnackbarType.error,
              dense: true,
            ),
          ],
          SizedBox(height: context.spacing.lg),
          AppPrimaryButton(
            onPressed: onSubmit,
            isLoading: authState.isBusy,
            text: mode == AuthScreenModeState.login
                ? l10n.authSignInAction
                : l10n.authCreateAccountAction,
            expand: true,
            leading: Icon(
              mode == AuthScreenModeState.login
                  ? Icons.login_rounded
                  : Icons.person_add_alt_1_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
