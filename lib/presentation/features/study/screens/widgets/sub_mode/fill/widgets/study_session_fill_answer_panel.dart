import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const double _fillAnswerLineHeight =
    AppTypographyConst.titleLargeLineHeight /
    AppTypographyConst.titleLargeFontSize;
const EdgeInsetsGeometry _fillAnswerCardPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.xl,
  vertical: AppSpacing.xl,
);

class StudySessionFillAnswerPanel extends StatelessWidget {
  const StudySessionFillAnswerPanel({
    required this.content,
    super.key,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return LumosCard(
      margin: EdgeInsets.zero,
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: SizedBox.expand(
        child: Padding(
          padding: _fillAnswerCardPadding,
          child: Center(
            child: SingleChildScrollView(
              child: LumosInlineText(
                content,
                align: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                  height: _fillAnswerLineHeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
