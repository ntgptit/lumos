import 'package:flutter/material.dart';

import '../../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

const double _reviewPromptIconSize = IconSizes.iconMedium;
const double _reviewPromptLineHeight =
    AppTypographyConst.titleLargeLineHeight /
    AppTypographyConst.titleLargeFontSize;
const EdgeInsetsGeometry _reviewPromptCardPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.xl,
  vertical: AppSpacing.xl,
);
const EdgeInsetsGeometry _reviewPromptTopIconPadding = EdgeInsets.only(
  top: AppSpacing.lg,
  right: AppSpacing.lg,
);

class StudySessionReviewPromptCard extends StatelessWidget {
  const StudySessionReviewPromptCard({required this.content, super.key});

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
      child: Stack(
        children: <Widget>[
          const Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: _reviewPromptTopIconPadding,
              child: LumosIcon(
                Icons.edit_outlined,
                size: _reviewPromptIconSize,
              ),
            ),
          ),
          Padding(
            padding: _reviewPromptCardPadding,
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
        ],
      ),
    );
  }
}
