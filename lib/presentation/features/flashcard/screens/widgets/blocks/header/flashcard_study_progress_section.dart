import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

abstract final class FlashcardStudyProgressSectionConst {
  FlashcardStudyProgressSectionConst._();

  static const double sectionSpacing = LumosSpacing.lg;
  static const double itemSpacing = LumosSpacing.md;
  static const double progressRingSize = WidgetSizes.avatarMedium;
  static const double actionIconSize = IconSizes.iconSmall;
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
    final double sectionSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyProgressSectionConst.sectionSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double itemSpacing = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyProgressSectionConst.itemSpacing,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double ringSize = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: FlashcardStudyProgressSectionConst.progressRingSize,
      minScale: ResponsiveDimensions.compactLargeInsetScale,
    );
    final double rowGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final int safeTotalCount = _safeTotalCount();
    final List<_FlashcardStudyProgressItem> items = _buildItems(
      safeTotalCount: safeTotalCount,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LumosText(title, style: LumosTextStyle.titleMedium),
        SizedBox(height: itemSpacing),
        LumosInlineText(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: sectionSpacing),
        ...items.map((_FlashcardStudyProgressItem item) {
          final ThemeData theme = Theme.of(context);
          final Color ringColor = _resolveFlashcardRingColor(
            theme: theme,
            tone: item.tone,
          );
          final Color textColor = _resolveFlashcardLabelColor(
            theme: theme,
            tone: item.tone,
            value: item.value,
          );
          return Padding(
            padding: EdgeInsets.only(bottom: itemSpacing),
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
                      size: ringSize,
                      centerChild: LumosInlineText(
                        '${item.value}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: rowGap),
                  Expanded(
                    child: LumosInlineText(
                      item.label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: textColor,
                      ),
                    ),
                  ),
                  SizedBox(width: rowGap),
                  IconTheme(
                    data: IconThemeData(color: textColor),
                    child: const LumosIcon(
                      Icons.arrow_forward_rounded,
                      size: FlashcardStudyProgressSectionConst.actionIconSize,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
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
}

Color _resolveFlashcardRingColor({
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

Color _resolveFlashcardLabelColor({
  required ThemeData theme,
  required _FlashcardStudyProgressTone tone,
  required int value,
}) {
  final ColorScheme colorScheme = theme.colorScheme;
  final Color enabledColor = _resolveFlashcardRingColor(
    theme: theme,
    tone: tone,
  );
  if (value > 0) {
    return enabledColor;
  }
  return colorScheme.onSurfaceVariant.withValues(alpha: AppOpacity.lowEmphasis);
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
