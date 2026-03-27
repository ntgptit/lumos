import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_label.dart';
import 'package:lumos/presentation/shared/primitives/text/app_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/app_title_text.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.message,
    this.details,
    this.icon,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.maxWidth,
  });

  final String title;
  final String? message;
  final String? details;
  final Widget? icon;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final double? maxWidth;

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[
      if (secondaryActionLabel != null)
        AppOutlineButton(
          text: secondaryActionLabel!,
          onPressed: onSecondaryAction,
        ),
      if (primaryActionLabel != null)
        AppPrimaryButton(text: primaryActionLabel!, onPressed: onPrimaryAction),
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
              icon ?? const AppIcon(Icons.error_outline_rounded),
              SizedBox(height: context.spacing.md),
              AppTitleText(text: title, textAlign: TextAlign.center),
              if (message != null) ...[
                SizedBox(height: context.spacing.xs),
                AppBodyText(text: message!, textAlign: TextAlign.center),
              ],
              if (details != null) ...[
                SizedBox(height: context.spacing.xs),
                AppLabel(text: details!, textAlign: TextAlign.center),
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
