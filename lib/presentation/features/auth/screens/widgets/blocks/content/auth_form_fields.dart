import 'package:flutter/material.dart';

import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_password_field.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import '../../../../providers/auth_session_provider.dart';

class AuthFormFields extends StatelessWidget {
  const AuthFormFields({
    required this.mode,
    required this.usernameController,
    required this.emailController,
    required this.identifierController,
    required this.passwordController,
    super.key,
  });

  final AuthScreenModeState mode;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController identifierController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final fieldSpacing = context.spacing.md;

    if (mode == AuthScreenModeState.register) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LumosTextField(
            controller: usernameController,
            label: l10n.authUsernameLabel,
          ),
          SizedBox(height: fieldSpacing),
          LumosTextField(
            controller: emailController,
            label: l10n.authEmailLabel,
          ),
          SizedBox(height: fieldSpacing),
          LumosPasswordField(
            controller: passwordController,
            label: l10n.authPasswordLabel,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LumosTextField(
          controller: identifierController,
          label: l10n.authUsernameOrEmailLabel,
        ),
        SizedBox(height: fieldSpacing),
        LumosPasswordField(
          controller: passwordController,
          label: l10n.authPasswordLabel,
        ),
      ],
    );
  }
}
