import 'package:flutter/material.dart';
import 'package:lumos/l10n/l10n.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';

class LumosNoResultState extends StatelessWidget {
  const LumosNoResultState({
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
    return LumosEmptyState(
      title: context.l10n.noResultsTitle,
      message: message ?? context.l10n.noResultsMessage,
      icon: const LumosIcon(Icons.search_off_rounded),
      maxWidth: maxWidth,
      actions: [
        if (actionLabel != null && onActionPressed != null)
          LumosPrimaryButton(text: actionLabel!, onPressed: onActionPressed),
      ],
    );
  }
}
