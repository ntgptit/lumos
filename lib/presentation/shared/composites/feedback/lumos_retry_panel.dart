import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_title_text.dart';

class LumosRetryPanel extends StatelessWidget {
  const LumosRetryPanel({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.retryLabel = 'Retry',
    this.leading,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;
  final String retryLabel;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          leading ??
              Icon(
                Icons.refresh_rounded,
                size: context.iconSize.xl,
                color: context.colorScheme.primary,
              ),
          SizedBox(height: context.spacing.md),
          LumosTitleText(text: title),
          SizedBox(height: context.spacing.xxs),
          LumosBodyText(text: message),
          SizedBox(height: context.spacing.md),
          LumosOutlineButton(text: retryLabel, onPressed: onRetry),
        ],
      ),
    );
  }
}
