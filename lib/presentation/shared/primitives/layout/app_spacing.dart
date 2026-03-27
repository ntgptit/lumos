import 'package:flutter/material.dart';
import 'package:lumos/core/theme/extensions/theme_context_ext.dart';

enum AppSpacingSize {
  xxs,
  xs,
  sm,
  md,
  lg,
  xl,
  xxl,
  xxxl,
  section,
  gutter,
  gridGap,
}

class AppSpacing extends StatelessWidget {
  const AppSpacing({
    super.key,
    this.size = AppSpacingSize.md,
    this.axis = Axis.vertical,
  });

  final AppSpacingSize size;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final spacing = switch (size) {
      AppSpacingSize.xxs => context.spacing.xxs,
      AppSpacingSize.xs => context.spacing.xs,
      AppSpacingSize.sm => context.spacing.sm,
      AppSpacingSize.md => context.spacing.md,
      AppSpacingSize.lg => context.spacing.lg,
      AppSpacingSize.xl => context.spacing.xl,
      AppSpacingSize.xxl => context.spacing.xxl,
      AppSpacingSize.xxxl => context.spacing.xxxl,
      AppSpacingSize.section => context.spacing.section,
      AppSpacingSize.gutter => context.spacing.gutter,
      AppSpacingSize.gridGap => context.spacing.gridGap,
    };
    return axis == Axis.horizontal
        ? SizedBox(width: spacing)
        : SizedBox(height: spacing);
  }
}
