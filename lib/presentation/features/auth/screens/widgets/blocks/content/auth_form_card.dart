import 'package:flutter/material.dart';

import 'package:lumos/core/enums/snackbar_type.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_banner.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_title_text.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';
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

    return LumosCard(
      padding: EdgeInsets.all(context.spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LumosTitleText(text: l10n.authTitle),
          SizedBox(height: context.spacing.xs),
          LumosBodyText(text: l10n.authSubtitle, isSecondary: true),
          SizedBox(height: context.spacing.xl),
          SegmentedButton<AuthScreenModeState>(
            segments: <ButtonSegment<AuthScreenModeState>>[
              ButtonSegment<AuthScreenModeState>(
                value: AuthScreenModeState.login,
                label: LumosText(text: l10n.authLoginTab),
              ),
              ButtonSegment<AuthScreenModeState>(
                value: AuthScreenModeState.register,
                label: LumosText(text: l10n.authRegisterTab),
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
            LumosBanner(
              message: errorMessage,
              type: SnackbarType.error,
              dense: true,
            ),
          ],
          SizedBox(height: context.spacing.lg),
          LumosButton.primary(
            onPressed: onSubmit,
            isLoading: authState.isBusy,
            text: mode == AuthScreenModeState.login
                ? l10n.authSignInAction
                : l10n.authCreateAccountAction,
            expand: true,
            leading: LumosIcon(
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
