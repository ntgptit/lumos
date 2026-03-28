import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_body_text.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_title_text.dart';

class LumosStudyProgressHeader extends StatelessWidget {
  const LumosStudyProgressHeader({
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
              const LumosSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LumosTitleText(text: title),
                  if (subtitle != null) ...[
                    const LumosSpacing(size: AppSpacingSize.xxs),
                    LumosBodyText(
                      text: subtitle!,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              const LumosSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
              trailing!,
            ],
          ],
        ),
        if (showProgressBar) ...[
          const LumosSpacing(size: AppSpacingSize.sm),
          Row(
            children: [
              Expanded(child: LumosProgressBar(value: resolvedProgress)),
              const LumosSpacing(size: AppSpacingSize.sm, axis: Axis.horizontal),
              LumosBodyText(
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
