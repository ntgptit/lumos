import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_card.dart';
import 'package:lumos/presentation/shared/primitives/text/app_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/app_title_text.dart';

class AppRetryPanel extends StatelessWidget {
  const AppRetryPanel({
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
    return AppCard(
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
          AppTitleText(text: title),
          SizedBox(height: context.spacing.xxs),
          AppBodyText(text: message),
          SizedBox(height: context.spacing.md),
          AppOutlineButton(text: retryLabel, onPressed: onRetry),
        ],
      ),
    );
  }
}
