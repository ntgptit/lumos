import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';

class LumosAccessRequiredState extends StatelessWidget {
  const LumosAccessRequiredState({
    super.key,
    this.onActionPressed,
    this.actionLabel,
    this.message,
    this.maxWidth,
  });

  final VoidCallback? onActionPressed;
  final String? actionLabel;
  final String? message;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return LumosErrorState(
      title: context.l10n.accessRequiredTitle,
      message: message ?? context.l10n.signInMessage,
      primaryActionLabel: actionLabel ?? context.l10n.signInLabel,
      onPrimaryAction: onActionPressed,
      maxWidth: maxWidth,
    );
  }
}
