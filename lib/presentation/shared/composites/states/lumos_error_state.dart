import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_label.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_title_text.dart';

class LumosErrorState extends StatelessWidget {
  const LumosErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message,
    this.errorMessage,
    this.details,
    this.icon,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.onRetry,
    this.retryLabel,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.maxWidth,
  });

  final String title;
  final String? message;
  final String? errorMessage;
  final String? details;
  final Widget? icon;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[
      if (secondaryActionLabel != null)
        LumosOutlineButton(
          text: secondaryActionLabel!,
          onPressed: onSecondaryAction,
        ),
      if ((primaryActionLabel ?? retryLabel) != null)
        LumosPrimaryButton(
          text: primaryActionLabel ?? retryLabel!,
          onPressed: onPrimaryAction ?? onRetry,
        ),
    ];

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 560),
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon ?? const LumosIcon(Icons.error_outline_rounded),
              SizedBox(height: context.spacing.md),
              LumosTitleText(text: title, textAlign: TextAlign.center),
              if ((message ?? errorMessage) != null) ...[
                SizedBox(height: context.spacing.xs),
                LumosBodyText(
                  text: message ?? errorMessage!,
                  textAlign: TextAlign.center,
                ),
              ],
              if (details != null) ...[
                SizedBox(height: context.spacing.xs),
                LumosLabel(text: details!, textAlign: TextAlign.center),
              ],
              if (actions.isNotEmpty) ...[
                SizedBox(height: context.spacing.md),
                Wrap(
                  spacing: context.spacing.sm,
                  runSpacing: context.spacing.sm,
                  alignment: WrapAlignment.center,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
