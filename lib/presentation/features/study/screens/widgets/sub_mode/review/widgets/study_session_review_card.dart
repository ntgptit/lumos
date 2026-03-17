import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionReviewCard extends StatelessWidget {
  const StudySessionReviewCard({
    required this.content,
    required this.trailing,
    this.textStyle,
    super.key,
  });

  final String content;
  final Widget trailing;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final EdgeInsets cardPadding = ResponsiveDimensions.compactInsets(
          context: context,
          baseInsets: EdgeInsets.fromLTRB(
            constraints.maxHeight < 260 ? AppSpacing.lg : AppSpacing.xl,
            AppSpacing.lg,
            constraints.maxHeight < 260 ? AppSpacing.lg : AppSpacing.xl,
            constraints.maxHeight < 260 ? AppSpacing.lg : AppSpacing.xl,
          ),
        );
        final double horizontalInset = ResponsiveDimensions.compactValue(
          context: context,
          baseValue: constraints.maxWidth < 360 ? AppSpacing.sm : AppSpacing.md,
          minScale: ResponsiveDimensions.compactInsetScale,
        );
        return LumosCard(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          child: Padding(
            padding: cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Align(alignment: Alignment.topRight, child: trailing),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: horizontalInset,
                        ),
                        child: LumosInlineText(
                          content,
                          align: TextAlign.center,
                          style: textStyle?.copyWith(
                            color: context.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
