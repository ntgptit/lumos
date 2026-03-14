import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../widgets/study_session_content_card.dart';
import '../../widgets/study_session_layout_metrics.dart';

const double _reviewPromptIconSize = IconSizes.iconMedium;
const double _reviewPromptLineHeight =
    AppTypographyConst.titleLargeLineHeight /
    AppTypographyConst.titleLargeFontSize;

class StudySessionReviewPromptCard extends StatelessWidget {
  const StudySessionReviewPromptCard({required this.content, super.key});

  final String content;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final double iconSize = StudySessionLayoutMetrics.compactIcon(
      context,
      baseValue: _reviewPromptIconSize,
    );
    final EdgeInsets cardPadding = StudySessionLayoutMetrics.cardPadding(
      context,
      horizontal: AppSpacing.xl,
      vertical: AppSpacing.xl,
    );
    final EdgeInsets topTrailingPadding =
        StudySessionLayoutMetrics.topTrailingPadding(context);
    return StudySessionContentCard(
      variant: LumosCardVariant.filled,
      topTrailing: LumosIcon(Icons.edit_outlined, size: iconSize),
      topTrailingPadding: topTrailingPadding,
      child: Padding(
        padding: cardPadding,
        child: Center(
          child: SingleChildScrollView(
            child: LumosInlineText(
              content,
              align: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
                height: _reviewPromptLineHeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
