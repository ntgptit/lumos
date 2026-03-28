import 'package:flutter/material.dart';

import 'package:lumos/core/enums/snackbar_type.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/cards/lumos_info_card.dart';
import 'package:lumos/presentation/shared/composites/feedback/lumos_message_banner.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_primary_submit_bar.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/primitives/selections/lumos_segmented_control.dart';
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

    return LumosInfoCard(
      title: l10n.authTitle,
      subtitle: l10n.authSubtitle,
      padding: EdgeInsets.all(context.spacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LumosSegmentedControl<AuthScreenModeState>(
            segments: <ButtonSegment<AuthScreenModeState>>[
              ButtonSegment<AuthScreenModeState>(
                value: AuthScreenModeState.login,
                label: LumosInlineText(l10n.authLoginTab),
              ),
              ButtonSegment<AuthScreenModeState>(
                value: AuthScreenModeState.register,
                label: LumosInlineText(l10n.authRegisterTab),
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
          if (authState.errorMessage
              case final String errorMessage) ...<Widget>[
            SizedBox(height: context.spacing.md),
            LumosMessageBanner(
              message: errorMessage,
              type: SnackbarType.error,
              dense: true,
            ),
          ],
          SizedBox(height: context.spacing.lg),
          LumosPrimarySubmitBar(
            onPressed: onSubmit,
            isLoading: authState.isBusy,
            label: mode == AuthScreenModeState.login
                ? l10n.authSignInAction
                : l10n.authCreateAccountAction,
          ),
        ],
      ),
    );
  }
}
