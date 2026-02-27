import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
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
    final double badgeSize = size ?? IconSizes.iconXLarge;
    final double progress = _buildProgress();
    return LumosCard(
      child: Row(
        children: <Widget>[
          Icon(Icons.bolt_rounded, size: badgeSize),
          const SizedBox(width: Insets.spacing8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosText('Level $level', style: LumosTextStyle.titleMedium),
                LumosText('$currentXP XP', style: LumosTextStyle.bodySmall),
                const SizedBox(height: Insets.spacing4),
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color color = isTodayCompleted
        ? colorScheme.tertiary
        : colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.local_fire_department,
          color: color,
          size: IconSizes.iconMedium,
        ),
        const SizedBox(width: Insets.spacing4),
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
            color: Theme.of(context).colorScheme.error,
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
      const SizedBox(width: Insets.spacing8),
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
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color color = isUnlocked
        ? colorScheme.tertiary
        : colorScheme.onSurfaceVariant;
    return LumosCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: IconSizes.iconLarge, color: color),
          const SizedBox(height: Insets.spacing8),
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
      const SizedBox(height: Insets.spacing8),
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
    final double progress = _buildProgress();
    return LumosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const LumosText('Daily Goal', style: LumosTextStyle.titleMedium),
          const SizedBox(height: Insets.spacing8),
          LumosText('$current/$goal $unit', style: LumosTextStyle.bodyMedium),
          const SizedBox(height: Insets.spacing8),
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
