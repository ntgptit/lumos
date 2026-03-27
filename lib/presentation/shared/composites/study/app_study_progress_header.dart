import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/displays/app_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/layout/app_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/app_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/app_title_text.dart';

class AppStudyProgressHeader extends StatelessWidget {
  const AppStudyProgressHeader({
    super.key,
    required this.title,
    required this.progress,
    this.subtitle,
    this.progressLabel,
    this.leading,
    this.trailing,
    this.showProgressBar = true,
  });

  final String title;
  final double progress;
  final String? subtitle;
  final String? progressLabel;
  final Widget? leading;
  final Widget? trailing;
  final bool showProgressBar;

  @override
  Widget build(BuildContext context) {
    final resolvedProgress = progress.clamp(0.0, 1.0);
    final resolvedProgressLabel =
        progressLabel ?? '${(resolvedProgress * 100).round()}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) ...[
              leading!,
              const AppSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTitleText(text: title),
                  if (subtitle != null) ...[
                    const AppSpacing(size: AppSpacingSize.xxs),
                    AppBodyText(
                      text: subtitle!,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const AppSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
              trailing!,
            ],
          ],
        ),
        if (showProgressBar) ...[
          const AppSpacing(size: AppSpacingSize.sm),
          Row(
            children: [
              Expanded(child: AppProgressBar(value: resolvedProgress)),
              const AppSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
              AppBodyText(
                text: resolvedProgressLabel,
                color: context.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
