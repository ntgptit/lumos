import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:lumos/presentation/shared/composites/states/app_empty_state.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_icon.dart';

class AppNoResultState extends StatelessWidget {
  const AppNoResultState({
    super.key,
    this.message,
    this.actionLabel,
    this.onActionPressed,
    this.maxWidth,
  });

  final String? message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: context.l10n.noResultsTitle,
      message: message ?? context.l10n.noResultsMessage,
      icon: const AppIcon(Icons.search_off_rounded),
      maxWidth: maxWidth,
      actions: [
        if (actionLabel != null && onActionPressed != null)
          AppPrimaryButton(text: actionLabel!, onPressed: onActionPressed),
      ],
    );
  }
}
