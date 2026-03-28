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

class LumosSpacing extends StatelessWidget {
  static const double none = 0;
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
  static const double section = 24;
  static const double page = 20;
  static const double canvas = 96;

  const LumosSpacing({
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
