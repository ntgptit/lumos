import 'package:flutter/material.dart';

import '../../../../core/constants/dimensions.dart';
import '../buttons/lumos_button.dart';
import '../lumos_models.dart';
import '../typography/lumos_text.dart';

class LumosSnackbar extends SnackBar {
  LumosSnackbar({
    required BuildContext context,
    required String message,
    super.key,
    super.duration = MotionDurations.snackbar,
    LumosSnackbarType type = LumosSnackbarType.info,
  }) : super(
         behavior: SnackBarBehavior.floating,
         content: LumosText(
           message,
           style: LumosTextStyle.bodyMedium,
           color: Theme.of(context).colorScheme.onInverseSurface,
         ),
         backgroundColor: _resolveBackgroundColor(
           type: type,
           colorScheme: Theme.of(context).colorScheme,
         ),
       );

  static Color _resolveBackgroundColor({
    required LumosSnackbarType type,
    required ColorScheme colorScheme,
  }) {
    if (type == LumosSnackbarType.success) {
      return colorScheme.tertiary;
    }
    if (type == LumosSnackbarType.warning) {
      return colorScheme.secondary;
    }
    if (type == LumosSnackbarType.error) {
      return colorScheme.error;
    }
    return colorScheme.inverseSurface;
  }
}

class LumosCelebration extends StatelessWidget {
  const LumosCelebration({
    required this.isActive,
    super.key,
    this.type = LumosCelebrationType.confetti,
    this.onComplete,
  });

  final bool isActive;
  final LumosCelebrationType type;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    if (!isActive) {
      return const SizedBox.shrink();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (onComplete != null) {
        onComplete!.call();
      }
    });
    return Container(
      padding: const EdgeInsets.all(Insets.spacing16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.tertiary.withValues(alpha: WidgetSizes.inputFillOpacity),
        borderRadius: BorderRadii.large,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(_resolveIcon(), size: IconSizes.iconLarge),
          const SizedBox(width: Insets.spacing8),
          const LumosText('Great job!', style: LumosTextStyle.titleMedium),
        ],
      ),
    );
  }

  IconData _resolveIcon() {
    if (type == LumosCelebrationType.fireworks) {
      return Icons.auto_awesome;
    }
    if (type == LumosCelebrationType.sparkles) {
      return Icons.stars_rounded;
    }
    return Icons.celebration_rounded;
  }
}

class LumosResultSummary extends StatelessWidget {
  const LumosResultSummary({
    required this.correctCount,
    required this.totalCount,
    required this.xpEarned,
    required this.onContinue,
    super.key,
    this.streakBonus,
    this.weakWords,
  });

  final int correctCount;
  final int totalCount;
  final int xpEarned;
  final int? streakBonus;
  final List<String>? weakWords;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LumosText(
          '$correctCount / $totalCount correct',
          style: LumosTextStyle.headlineSmall,
          align: TextAlign.center,
        ),
        const SizedBox(height: Insets.gapBetweenItems),
        LumosText(
          'XP earned: $xpEarned',
          style: LumosTextStyle.bodyLarge,
          align: TextAlign.center,
        ),
        ..._buildStreakBonus(),
        ..._buildWeakWords(),
        const SizedBox(height: Insets.gapBetweenSections),
        LumosButton(label: 'Continue', onPressed: onContinue, expanded: true),
      ],
    );
  }

  List<Widget> _buildStreakBonus() {
    if (streakBonus == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.spacing8),
      LumosText(
        'Streak bonus: +$streakBonus XP',
        style: LumosTextStyle.labelLarge,
        align: TextAlign.center,
      ),
    ];
  }

  List<Widget> _buildWeakWords() {
    if (weakWords == null) {
      return const <Widget>[];
    }
    if (weakWords!.isEmpty) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.gapBetweenItems),
      Wrap(
        spacing: Insets.spacing8,
        runSpacing: Insets.spacing8,
        children: weakWords!
            .map(
              (String word) =>
                  Chip(label: Text(word, overflow: TextOverflow.ellipsis)),
            )
            .toList(),
      ),
    ];
  }
}

class LumosTipMessage extends StatelessWidget {
  const LumosTipMessage({
    required this.message,
    super.key,
    this.type = LumosTipType.tip,
    this.displayDuration = MotionDurations.tip,
  });

  final String message;
  final LumosTipType type;
  final Duration displayDuration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.spacing12),
      decoration: BoxDecoration(
        color: _resolveColor(
          context,
        ).withValues(alpha: WidgetSizes.inputFillOpacity),
        borderRadius: BorderRadii.medium,
      ),
      child: Row(
        children: <Widget>[
          Icon(_resolveIcon(), size: IconSizes.iconMedium),
          const SizedBox(width: Insets.spacing8),
          Expanded(
            child: LumosText(
              message,
              style: LumosTextStyle.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _resolveIcon() {
    if (type == LumosTipType.encouragement) {
      return Icons.favorite_outline;
    }
    if (type == LumosTipType.fact) {
      return Icons.lightbulb_outline_rounded;
    }
    return Icons.tips_and_updates_outlined;
  }

  Color _resolveColor(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    if (type == LumosTipType.encouragement) {
      return colorScheme.tertiary;
    }
    if (type == LumosTipType.fact) {
      return colorScheme.secondary;
    }
    return colorScheme.primary;
  }
}
