import 'package:flutter/material.dart';

import '../../../../../../core/constants/dimensions.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardStudyProgressSectionConst {
  FlashcardStudyProgressSectionConst._();

  static const double sectionSpacing = Insets.spacing16;
  static const double itemSpacing = Insets.spacing12;
  static const double progressRingSize = Insets.spacing64;
  static const double progressTextMaxValue = 1;
}

class FlashcardStudyProgressSection extends StatelessWidget {
  const FlashcardStudyProgressSection({
    required this.title,
    required this.description,
    required this.notStartedLabel,
    required this.learningLabel,
    required this.masteredLabel,
    required this.notStartedCount,
    required this.learningCount,
    required this.masteredCount,
    required this.totalCount,
    required this.onNotStartedPressed,
    required this.onLearningPressed,
    required this.onMasteredPressed,
    super.key,
  });

  final String title;
  final String description;
  final String notStartedLabel;
  final String learningLabel;
  final String masteredLabel;
  final int notStartedCount;
  final int learningCount;
  final int masteredCount;
  final int totalCount;
  final VoidCallback onNotStartedPressed;
  final VoidCallback onLearningPressed;
  final VoidCallback onMasteredPressed;

  @override
  Widget build(BuildContext context) {
    final int safeTotalCount = _safeTotalCount();
    final List<_FlashcardStudyProgressItem> items = _buildItems(
      safeTotalCount: safeTotalCount,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LumosText(title, style: LumosTextStyle.headlineSmall),
        const SizedBox(height: FlashcardStudyProgressSectionConst.itemSpacing),
        LumosInlineText(
          description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: FlashcardStudyProgressSectionConst.sectionSpacing,
        ),
        ...items.map(_buildProgressItem),
      ],
    );
  }

  int _safeTotalCount() {
    if (totalCount <= 0) {
      return 1;
    }
    return totalCount;
  }

  List<_FlashcardStudyProgressItem> _buildItems({required int safeTotalCount}) {
    return <_FlashcardStudyProgressItem>[
      _FlashcardStudyProgressItem(
        label: notStartedLabel,
        value: _safeCount(notStartedCount),
        progress: _progress(
          value: _safeCount(notStartedCount),
          total: safeTotalCount,
        ),
        tone: _FlashcardStudyProgressTone.primary,
        onPressed: onNotStartedPressed,
      ),
      _FlashcardStudyProgressItem(
        label: learningLabel,
        value: _safeCount(learningCount),
        progress: _progress(
          value: _safeCount(learningCount),
          total: safeTotalCount,
        ),
        tone: _FlashcardStudyProgressTone.warning,
        onPressed: onLearningPressed,
      ),
      _FlashcardStudyProgressItem(
        label: masteredLabel,
        value: _safeCount(masteredCount),
        progress: _progress(
          value: _safeCount(masteredCount),
          total: safeTotalCount,
        ),
        tone: _FlashcardStudyProgressTone.success,
        onPressed: onMasteredPressed,
      ),
    ];
  }

  int _safeCount(int value) {
    if (value < 0) {
      return 0;
    }
    return value;
  }

  double _progress({required int value, required int total}) {
    if (total <= 0) {
      return 0;
    }
    final double raw = value / total;
    if (raw < 0) {
      return 0;
    }
    if (raw > FlashcardStudyProgressSectionConst.progressTextMaxValue) {
      return FlashcardStudyProgressSectionConst.progressTextMaxValue;
    }
    return raw;
  }

  Widget _buildProgressItem(_FlashcardStudyProgressItem item) {
    return Builder(
      builder: (BuildContext context) {
        final ThemeData theme = Theme.of(context);
        final Color ringColor = _resolveRingColor(
          theme: theme,
          tone: item.tone,
        );
        final Color textColor = _resolveLabelColor(
          theme: theme,
          tone: item.tone,
          value: item.value,
        );
        return Padding(
          padding: const EdgeInsets.only(
            bottom: FlashcardStudyProgressSectionConst.itemSpacing,
          ),
          child: LumosCard(
            variant: LumosCardVariant.filled,
            onTap: item.onPressed,
            child: Row(
              children: <Widget>[
                Theme(
                  data: theme.copyWith(
                    progressIndicatorTheme: ProgressIndicatorThemeData(
                      color: ringColor,
                    ),
                  ),
                  child: LumosProgressRing(
                    progress: item.progress,
                    size: FlashcardStudyProgressSectionConst.progressRingSize,
                    centerChild: LumosInlineText(
                      '${item.value}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Insets.spacing16),
                Expanded(
                  child: LumosInlineText(
                    item.label,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(width: Insets.spacing16),
                IconTheme(
                  data: IconThemeData(color: textColor),
                  child: const LumosIcon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _resolveRingColor({
    required ThemeData theme,
    required _FlashcardStudyProgressTone tone,
  }) {
    final ColorScheme colorScheme = theme.colorScheme;
    if (tone == _FlashcardStudyProgressTone.primary) {
      return colorScheme.primary;
    }
    if (tone == _FlashcardStudyProgressTone.warning) {
      return colorScheme.tertiary;
    }
    return colorScheme.secondary;
  }

  Color _resolveLabelColor({
    required ThemeData theme,
    required _FlashcardStudyProgressTone tone,
    required int value,
  }) {
    final ColorScheme colorScheme = theme.colorScheme;
    final Color enabledColor = _resolveRingColor(theme: theme, tone: tone);
    if (value > 0) {
      return enabledColor;
    }
    return colorScheme.onSurfaceVariant.withValues(
      alpha: WidgetOpacities.lowEmphasis,
    );
  }
}

enum _FlashcardStudyProgressTone { primary, warning, success }

class _FlashcardStudyProgressItem {
  const _FlashcardStudyProgressItem({
    required this.label,
    required this.value,
    required this.progress,
    required this.tone,
    required this.onPressed,
  });

  final String label;
  final int value;
  final double progress;
  final _FlashcardStudyProgressTone tone;
  final VoidCallback onPressed;
}
