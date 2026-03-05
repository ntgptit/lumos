import 'package:flutter/material.dart';

import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../core/themes/semantic/app_color_tokens.dart';
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
         content: Text(
           message,
           style: context.textTheme.bodyMedium.withResolvedColor(
             _resolveForegroundColor(
               type: type,
               colorScheme: context.colorScheme,
               appColors: context.appColors,
             ),
           ),
         ),
         backgroundColor: _resolveBackgroundColor(
           type: type,
           colorScheme: context.colorScheme,
           appColors: context.appColors,
         ),
       );

  static Color _resolveBackgroundColor({
    required LumosSnackbarType type,
    required ColorScheme colorScheme,
    required AppColorTokens appColors,
  }) {
    if (type == LumosSnackbarType.success) {
      return appColors.success;
    }
    if (type == LumosSnackbarType.warning) {
      return appColors.warning;
    }
    if (type == LumosSnackbarType.error) {
      return colorScheme.error;
    }
    return appColors.info;
  }

  static Color _resolveForegroundColor({
    required LumosSnackbarType type,
    required ColorScheme colorScheme,
    required AppColorTokens appColors,
  }) {
    if (type == LumosSnackbarType.success) {
      return appColors.onSuccess;
    }
    if (type == LumosSnackbarType.warning) {
      return appColors.onWarning;
    }
    if (type == LumosSnackbarType.error) {
      return colorScheme.onError;
    }
    return appColors.onInfo;
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
    final AppColorTokens appColors = context.appColors;
    if (!isActive) {
      return const SizedBox.shrink();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (onComplete != null) {
        onComplete!.call();
      }
    });
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: appColors.successContainer.withValues(
          alpha: AppOpacity.stateHover,
        ),
        borderRadius: BorderRadii.large,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            _resolveIcon(),
            size: IconSizes.iconLarge,
            color: appColors.onSuccessContainer,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'Great job!',
            style: context.textTheme.titleMedium.withResolvedColor(
              appColors.onSuccessContainer,
            ),
          ),
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
        const SizedBox(height: AppSpacing.md),
        LumosText(
          'XP earned: $xpEarned',
          style: LumosTextStyle.bodyLarge,
          align: TextAlign.center,
        ),
        ..._buildStreakBonus(),
        ..._buildWeakWords(),
        const SizedBox(height: AppSpacing.xxl),
        LumosPrimaryButton(
          label: 'Continue',
          onPressed: onContinue,
          expanded: true,
        ),
      ],
    );
  }

  List<Widget> _buildStreakBonus() {
    if (streakBonus == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: AppSpacing.sm),
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
      const SizedBox(height: AppSpacing.md),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
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
    final Color foregroundColor = _resolveForegroundColor(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _resolveBackgroundColor(
          context,
        ).withValues(alpha: AppOpacity.stateHover),
        borderRadius: BorderRadii.medium,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            _resolveIcon(),
            size: IconSizes.iconMedium,
            color: foregroundColor,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: context.textTheme.bodySmall.withResolvedColor(
                foregroundColor,
              ),
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

  Color _resolveBackgroundColor(BuildContext context) {
    final AppColorTokens appColors = context.appColors;
    if (type == LumosTipType.encouragement) {
      return appColors.success;
    }
    if (type == LumosTipType.fact) {
      return appColors.info;
    }
    return appColors.warning;
  }

  Color _resolveForegroundColor(BuildContext context) {
    final AppColorTokens appColors = context.appColors;
    if (type == LumosTipType.encouragement) {
      return appColors.onSuccess;
    }
    if (type == LumosTipType.fact) {
      return appColors.onInfo;
    }
    return appColors.onWarning;
  }
}
