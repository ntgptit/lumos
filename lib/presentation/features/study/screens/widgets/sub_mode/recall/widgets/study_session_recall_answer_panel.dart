import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const double _recallAnswerLineHeight =
    AppTypographyConst.titleLargeLineHeight /
    AppTypographyConst.titleLargeFontSize;
const EdgeInsetsGeometry _recallAnswerCardPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.xl,
  vertical: AppSpacing.xl,
);
const double _recallHiddenAnswerWidth = 88;
const double _recallHiddenAnswerHeight = 18;
const double _recallHiddenAnswerBlurRadius = 28;
const double _recallHiddenAnswerSpreadRadius = 6;

class StudySessionRecallAnswerPanel extends StatelessWidget {
  const StudySessionRecallAnswerPanel({
    required this.content,
    required this.isRevealed,
    super.key,
  });

  final String content;
  final bool isRevealed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Widget panelContent = isRevealed
        ? Padding(
            key: const ValueKey<String>('revealed-answer'),
            padding: _recallAnswerCardPadding,
            child: Center(
              child: SingleChildScrollView(
                child: LumosInlineText(
                  content,
                  align: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                    height: _recallAnswerLineHeight,
                  ),
                ),
              ),
            ),
          )
        : Center(
            key: const ValueKey<String>('hidden-answer'),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(
                  alpha: AppOpacity.stateHover,
                ),
                borderRadius: BorderRadii.pill,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colorScheme.onSurface.withValues(
                      alpha: AppOpacity.scrimLight,
                    ),
                    blurRadius: _recallHiddenAnswerBlurRadius,
                    spreadRadius: _recallHiddenAnswerSpreadRadius,
                  ),
                ],
              ),
              child: const SizedBox(
                width: _recallHiddenAnswerWidth,
                height: _recallHiddenAnswerHeight,
              ),
            ),
          );
    return LumosCard(
      margin: EdgeInsets.zero,
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: SizedBox.expand(
        child: AnimatedSwitcher(
          duration: AppDurations.medium,
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: panelContent,
        ),
      ),
    );
  }
}
