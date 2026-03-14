import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../core/themes/semantic/app_color_tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../cards/lumos_card.dart';
import '../feedback/lumos_progress_bar.dart';
import '../typography/lumos_text.dart';

class LumosXPBadge extends StatelessWidget {
  const LumosXPBadge({
    required this.currentXP,
    required this.xpToNextLevel,
    required this.level,
    super.key,
    this.size,
  });

  final int currentXP;
  final int xpToNextLevel;
  final int level;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double badgeSize = size ?? IconSizes.iconXLarge;
    final double progress = _buildProgress();
    return LumosCard(
      child: Row(
        children: <Widget>[
          Icon(Icons.bolt_rounded, size: badgeSize),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosText(
                  l10n.gamificationLevelLabel(level),
                  style: LumosTextStyle.titleMedium,
                ),
                LumosText(
                  l10n.gamificationXpLabel(currentXP),
                  style: LumosTextStyle.bodySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                LumosProgressBar(value: progress),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _buildProgress() {
    if (xpToNextLevel <= 0) {
      return ResponsiveDimensions.minPercentage;
    }
    return currentXP / xpToNextLevel;
  }
}

class LumosStreakCounter extends StatelessWidget {
  const LumosStreakCounter({
    required this.streakDays,
    required this.isTodayCompleted,
    super.key,
    this.lastLearningDate,
  });

  final int streakDays;
  final bool isTodayCompleted;
  final DateTime? lastLearningDate;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens appColors = context.appColors;
    final ColorScheme colorScheme = context.colorScheme;
    final Color color = isTodayCompleted
        ? appColors.warning
        : colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.local_fire_department,
          color: color,
          size: IconSizes.iconMedium,
        ),
        const SizedBox(width: AppSpacing.xs),
        LumosText('$streakDays', style: LumosTextStyle.labelLarge),
      ],
    );
  }
}

class LumosHeartMeter extends StatelessWidget {
  const LumosHeartMeter({
    required this.heartsRemaining,
    super.key,
    this.maxHearts = 5,
    this.refillTime,
  });

  final int heartsRemaining;
  final int maxHearts;
  final Duration? refillTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ...List<Widget>.generate(
          maxHearts,
          (int index) => Icon(
            index < heartsRemaining ? Icons.favorite : Icons.favorite_border,
            size: IconSizes.iconSmall,
            color: context.colorScheme.error,
          ),
        ),
        ..._buildRefillLabel(),
      ],
    );
  }

  List<Widget> _buildRefillLabel() {
    if (refillTime == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(width: AppSpacing.sm),
      LumosText('${refillTime!.inMinutes}m', style: LumosTextStyle.labelSmall),
    ];
  }
}

class LumosAchievementBadge extends StatelessWidget {
  const LumosAchievementBadge({
    required this.title,
    required this.icon,
    required this.isUnlocked,
    super.key,
    this.progress,
  });

  final String title;
  final IconData icon;
  final bool isUnlocked;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final AppColorTokens appColors = context.appColors;
    final ColorScheme colorScheme = context.colorScheme;
    final Color color = isUnlocked
        ? appColors.success
        : colorScheme.onSurfaceVariant;
    return LumosCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: IconSizes.iconLarge, color: color),
          const SizedBox(height: AppSpacing.sm),
          LumosText(
            title,
            style: LumosTextStyle.labelLarge,
            align: TextAlign.center,
          ),
          ..._buildProgress(),
        ],
      ),
    );
  }

  List<Widget> _buildProgress() {
    if (progress == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: AppSpacing.sm),
      LumosProgressBar(value: progress!),
    ];
  }
}

class LumosDailyGoal extends StatelessWidget {
  const LumosDailyGoal({
    required this.current,
    required this.goal,
    required this.unit,
    super.key,
  });

  final int current;
  final int goal;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double progress = _buildProgress();
    return LumosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LumosText(
            l10n.gamificationDailyGoalTitle,
            style: LumosTextStyle.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          LumosText(
            l10n.gamificationDailyGoalProgress(current, goal, unit),
            style: LumosTextStyle.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          LumosProgressBar(value: progress),
        ],
      ),
    );
  }

  double _buildProgress() {
    if (goal <= 0) {
      return ResponsiveDimensions.minPercentage;
    }
    return current / goal;
  }
}
