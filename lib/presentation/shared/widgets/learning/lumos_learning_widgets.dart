import 'package:flutter/material.dart';

import '../../../../core/themes/constants/dimensions.dart';
import '../buttons/lumos_button.dart';
import '../cards/lumos_card.dart';
import '../feedback/lumos_progress_bar.dart';
import '../lumos_models.dart';
import '../typography/lumos_text.dart';

class LumosReviewProgress extends StatelessWidget {
  const LumosReviewProgress({
    required this.completed,
    required this.total,
    super.key,
    this.estimatedTime,
  });

  final int completed;
  final int total;
  final Duration? estimatedTime;

  @override
  Widget build(BuildContext context) {
    final double progress = _buildProgress();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LumosProgressBar(value: progress),
        const SizedBox(height: Insets.spacing8),
        LumosText(
          '$completed / $total reviewed',
          style: LumosTextStyle.labelLarge,
        ),
        ..._buildEstimate(),
      ],
    );
  }

  double _buildProgress() {
    if (total <= 0) {
      return ResponsiveDimensions.minPercentage;
    }
    return completed / total;
  }

  List<Widget> _buildEstimate() {
    if (estimatedTime == null) {
      return const <Widget>[];
    }
    final int minutes = estimatedTime!.inMinutes;
    return <Widget>[
      const SizedBox(height: Insets.spacing4),
      LumosText('$minutes min left', style: LumosTextStyle.labelSmall),
    ];
  }
}

class LumosRatingButtons extends StatelessWidget {
  const LumosRatingButtons({
    required this.onRate,
    super.key,
    this.enabled = true,
  });

  final ValueChanged<ReviewRating> onRate;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: _buildButton(ReviewRating.again)),
        const SizedBox(width: Insets.spacing8),
        Expanded(child: _buildButton(ReviewRating.hard)),
        const SizedBox(width: Insets.spacing8),
        Expanded(child: _buildButton(ReviewRating.good)),
        const SizedBox(width: Insets.spacing8),
        Expanded(child: _buildButton(ReviewRating.easy)),
      ],
    );
  }

  Widget _buildButton(ReviewRating rating) {
    return LumosButton(
      label: rating.name,
      onPressed: _resolveAction(rating),
      size: LumosButtonSize.small,
      type: LumosButtonType.outline,
    );
  }

  VoidCallback? _resolveAction(ReviewRating rating) {
    if (!enabled) {
      return null;
    }
    return () {
      onRate(rating);
    };
  }
}

class LumosSessionProgress extends StatelessWidget {
  const LumosSessionProgress({
    required this.completed,
    required this.total,
    super.key,
    this.heartsRemaining,
  });

  final int completed;
  final int total;
  final int? heartsRemaining;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: LumosReviewProgress(completed: completed, total: total),
        ),
        ..._buildHearts(context),
      ],
    );
  }

  List<Widget> _buildHearts(BuildContext context) {
    if (heartsRemaining == null) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(width: Insets.gapBetweenItems),
      Row(
        children: <Widget>[
          Icon(
            Icons.favorite,
            size: IconSizes.iconSmall,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(width: Insets.spacing4),
          LumosText('$heartsRemaining', style: LumosTextStyle.labelLarge),
        ],
      ),
    ];
  }
}

class LumosStatsCard extends StatelessWidget {
  const LumosStatsCard({
    required this.totalCards,
    required this.mastered,
    required this.learning,
    required this.due,
    required this.retentionRate,
    super.key,
  });

  final int totalCards;
  final int mastered;
  final int learning;
  final int due;
  final double retentionRate;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const LumosText('Statistics', style: LumosTextStyle.titleLarge),
          const SizedBox(height: Insets.gapBetweenItems),
          LumosText('Total: $totalCards', style: LumosTextStyle.bodyMedium),
          LumosText('Mastered: $mastered', style: LumosTextStyle.bodyMedium),
          LumosText('Learning: $learning', style: LumosTextStyle.bodyMedium),
          LumosText('Due: $due', style: LumosTextStyle.bodyMedium),
          const SizedBox(height: Insets.gapBetweenItems),
          LumosProgressBar(value: retentionRate / 100),
        ],
      ),
    );
  }
}

class LumosReviewQueue extends StatelessWidget {
  const LumosReviewQueue({
    required this.dueCount,
    required this.totalForReview,
    required this.onStartReview,
    super.key,
    this.previewCards,
  });

  final int dueCount;
  final int totalForReview;
  final List<DueCardPreview>? previewCards;
  final VoidCallback onStartReview;

  @override
  Widget build(BuildContext context) {
    return LumosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LumosText('Due today: $dueCount', style: LumosTextStyle.titleMedium),
          const SizedBox(height: Insets.spacing8),
          LumosText(
            'Queue size: $totalForReview',
            style: LumosTextStyle.bodySmall,
          ),
          ..._buildPreview(),
          const SizedBox(height: Insets.gapBetweenItems),
          LumosButton(
            label: 'Start review',
            onPressed: onStartReview,
            expanded: true,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPreview() {
    if (previewCards == null) {
      return const <Widget>[];
    }
    if (previewCards!.isEmpty) {
      return const <Widget>[];
    }
    return <Widget>[
      const SizedBox(height: Insets.gapBetweenItems),
      Wrap(
        spacing: Insets.spacing8,
        runSpacing: Insets.spacing8,
        children: previewCards!
            .map(
              (DueCardPreview item) => Chip(
                label: Text(item.title, overflow: TextOverflow.ellipsis),
              ),
            )
            .toList(),
      ),
    ];
  }
}

class LumosDifficultyRating extends StatelessWidget {
  const LumosDifficultyRating({
    required this.onRate,
    super.key,
    this.enabled = true,
  });

  final ValueChanged<ReviewRating> onRate;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return LumosRatingButtons(onRate: onRate, enabled: enabled);
  }
}

class LumosNextReviewBadge extends StatelessWidget {
  const LumosNextReviewBadge({
    required this.nextReviewDate,
    super.key,
    this.isCompact = false,
  });

  final DateTime nextReviewDate;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final String label = _buildRelativeLabel();
    if (isCompact) {
      return Chip(
        label: Text(label, overflow: TextOverflow.ellipsis),
        avatar: const Icon(Icons.schedule, size: IconSizes.iconSmall),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.schedule, size: IconSizes.iconSmall),
        const SizedBox(width: Insets.spacing4),
        LumosText(label, style: LumosTextStyle.labelMedium),
      ],
    );
  }

  String _buildRelativeLabel() {
    final Duration duration = nextReviewDate.difference(DateTime.now());
    if (duration.inHours < 1) {
      return '${duration.inMinutes}m';
    }
    if (duration.inDays < 1) {
      return '${duration.inHours}h';
    }
    return '${duration.inDays}d';
  }
}
