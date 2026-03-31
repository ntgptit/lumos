import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../widgets/study_session_layout_metrics.dart';

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
        final EdgeInsets cardPadding = context.compactInsets(
          baseInsets: EdgeInsets.fromLTRB(
            constraints.maxHeight <
                    StudySessionLayoutMetrics.compactPanelHeightBreakpoint
                ? context.spacing.lg
                : context.spacing.xl,
            context.spacing.lg,
            constraints.maxHeight <
                    StudySessionLayoutMetrics.compactPanelHeightBreakpoint
                ? context.spacing.lg
                : context.spacing.xl,
            constraints.maxHeight <
                    StudySessionLayoutMetrics.compactPanelHeightBreakpoint
                ? context.spacing.lg
                : context.spacing.xl,
          ),
        );
        final double horizontalInset = context.compactValue(
          baseValue: constraints.maxWidth <
                  StudySessionLayoutMetrics.narrowContentWidthBreakpoint
              ? context.spacing.sm
              : context.spacing.md,
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
