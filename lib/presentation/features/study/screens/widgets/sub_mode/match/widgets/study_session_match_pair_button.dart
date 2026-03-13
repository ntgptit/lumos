import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const double _matchCardMinHeight = WidgetSizes.minTouchTarget * 3.5;
const int _matchMeaningMaxLines = 6;
const int _matchWordMaxLines = 2;

class StudySessionMatchPairButton extends StatelessWidget {
  const StudySessionMatchPairButton({
    required this.label,
    required this.isMatched,
    required this.isSelected,
    required this.isMeaningCard,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool isMatched;
  final bool isSelected;
  final bool isMeaningCard;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color textColor = isMatched
        ? colorScheme.primary
        : isMeaningCard
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurface;
    final TextStyle? textStyle =
        (isMeaningCard
                ? theme.textTheme.titleMedium
                : theme.textTheme.headlineSmall)
            ?.copyWith(
              color: textColor,
              fontWeight: isMeaningCard ? FontWeight.w500 : FontWeight.w600,
              height: isMeaningCard ? 1.3 : 1.15,
            );
    return LumosCard(
      onTap: isMatched ? null : onPressed,
      isSelected: isSelected || isMatched,
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _matchCardMinHeight),
        child: Center(
          child: LumosInlineText(
            label,
            align: TextAlign.center,
            maxLines: isMeaningCard
                ? _matchMeaningMaxLines
                : _matchWordMaxLines,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
