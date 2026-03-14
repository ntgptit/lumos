import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../providers/auth_session_provider.dart';

class AuthFormFields extends ConsumerWidget {
  const AuthFormFields({
    required this.mode,
    required this.usernameController,
    required this.emailController,
    required this.identifierController,
    required this.passwordController,
    required this.passwordObscured,
    super.key,
  });

  final AuthScreenModeState mode;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController identifierController;
  final TextEditingController passwordController;
  final bool passwordObscured;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Widget passwordToggle = LumosIconButton(
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
    if (mode == AuthScreenModeState.register) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          LumosTextField(
            controller: usernameController,
            label: l10n.authUsernameLabel,
          ),
          const SizedBox(height: AppSpacing.md),
          LumosTextField(
            controller: emailController,
            label: l10n.authEmailLabel,
          ),
          const SizedBox(height: AppSpacing.md),
          LumosTextField(
            controller: passwordController,
            obscureText: passwordObscured,
            label: l10n.authPasswordLabel,
            suffixIcon: passwordToggle,
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
        const SizedBox(height: AppSpacing.md),
        LumosTextField(
          controller: passwordController,
          obscureText: passwordObscured,
          label: l10n.authPasswordLabel,
          suffixIcon: passwordToggle,
        ),
      ],
    );
  }
}
