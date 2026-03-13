import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const double _guessChoiceCardMinHeight = 120;
const EdgeInsetsGeometry _guessChoiceCardPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.xl,
  vertical: AppSpacing.xl,
);

class StudySessionGuessChoiceCard extends StatelessWidget {
  const StudySessionGuessChoiceCard({
    required this.label,
    required this.onPressed,
    this.isInteractive = true,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isInteractive;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return LumosCard(
      margin: EdgeInsets.zero,
      onTap: isInteractive ? onPressed : null,
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: _guessChoiceCardMinHeight),
        child: Padding(
          padding: _guessChoiceCardPadding,
          child: Center(
            child: LumosInlineText(
              label,
              align: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
