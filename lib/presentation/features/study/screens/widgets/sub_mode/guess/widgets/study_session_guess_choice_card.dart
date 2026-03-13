import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const double _guessChoiceCardMinHeight = 72;
const double _guessChoiceLineHeight =
    AppTypographyConst.titleMediumLineHeight /
    AppTypographyConst.titleMediumFontSize;
const int _guessChoiceMaxLines = 3;
const EdgeInsetsGeometry _guessChoiceCardPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.xl,
  vertical: AppSpacing.xs,
);

class StudySessionGuessChoiceCard extends StatelessWidget {
  const StudySessionGuessChoiceCard({
    required this.label,
    required this.onPressed,
    this.isSelected = false,
    this.isSuccessFeedback = false,
    this.isErrorFeedback = false,
    this.isInteractive = true,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isSelected;
  final bool isSuccessFeedback;
  final bool isErrorFeedback;
  final bool isInteractive;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color backgroundColor = isSuccessFeedback
        ? context.appColors.successContainer
        : isErrorFeedback
        ? colorScheme.errorContainer
        : colorScheme.surfaceContainerHighest;
    final Color textColor = isSuccessFeedback
        ? context.appColors.onSuccessContainer
        : isErrorFeedback
        ? colorScheme.onErrorContainer
        : colorScheme.onSurfaceVariant;
    return LumosCard(
      margin: EdgeInsets.zero,
      onTap: isInteractive ? onPressed : null,
      isSelected: isSelected && !isSuccessFeedback && !isErrorFeedback,
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: AnimatedContainer(
        duration: AppDurations.medium,
        curve: Curves.easeInOutCubic,
        decoration: BoxDecoration(
          color: isSuccessFeedback || isErrorFeedback
              ? backgroundColor
              : colorScheme.surface.withValues(alpha: AppOpacity.transparent),
          borderRadius: BorderRadii.xLarge,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: _guessChoiceCardMinHeight,
          ),
          child: Padding(
            padding: _guessChoiceCardPadding,
            child: Center(
              child: LumosInlineText(
                label,
                align: TextAlign.center,
                maxLines: _guessChoiceMaxLines,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  height: _guessChoiceLineHeight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
