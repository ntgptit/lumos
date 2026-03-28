import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../mode/study_fill_answer_comparison.dart';
import '../../widgets/study_session_content_card.dart';
import '../../widgets/study_session_layout_metrics.dart';
import 'study_session_fill_panel_style.dart';

const double _fillComparisonSpacing = LumosSpacing.canvas;

class StudySessionFillAnswerPanel extends StatelessWidget {
  const StudySessionFillAnswerPanel({
    required this.content,
    this.submittedAnswer,
    this.mismatchStartIndex,
    super.key,
  });

  final String content;
  final String? submittedAnswer;
  final int? mismatchStartIndex;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextStyle resolvedBaseStyle =
        StudySessionFillPanelStyle.termTextStyle(
          theme: theme,
          colorScheme: colorScheme,
        ) ??
        theme.textTheme.headlineLarge ??
        const TextStyle();
    final StudyFillAnswerComparison? comparison =
        StudyFillAnswerComparison.resolve(
          content: content,
          submittedAnswer: submittedAnswer,
          mismatchStartIndex: mismatchStartIndex,
        );
    final TextStyle errorStyle = resolvedBaseStyle.copyWith(
      color: colorScheme.error,
      decoration: TextDecoration.underline,
      decorationColor: colorScheme.error,
    );
    final Widget answerContent = comparison == null
        ? LumosInlineText(
            content,
            align: TextAlign.center,
            style: resolvedBaseStyle,
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LumosInlineText(
                comparison.correctAnswer,
                align: TextAlign.center,
                style: resolvedBaseStyle,
              ),
            ],
          );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactHeight = constraints.maxHeight < 260;
        final double comparisonSpacing =
            StudySessionLayoutMetrics.actionSpacing(
              context,
              baseValue: compactHeight
                  ? LumosSpacing.xxxl
                  : _fillComparisonSpacing,
            );
        final double horizontalInset = ResponsiveDimensions.compactValue(
          context: context,
          baseValue: compactHeight ? LumosSpacing.md : LumosSpacing.lg,
          minScale: ResponsiveDimensions.compactInsetScale,
        );
        final Widget resolvedContent = comparison == null
            ? answerContent
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  answerContent,
                  SizedBox(height: comparisonSpacing),
                  Text.rich(
                    TextSpan(
                      style: resolvedBaseStyle,
                      children: <InlineSpan>[
                        if (comparison.prefix.isNotEmpty)
                          TextSpan(text: comparison.prefix),
                        if (comparison.errorSuffix.isNotEmpty)
                          TextSpan(
                            text: comparison.errorSuffix,
                            style: errorStyle,
                          ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
        return StudySessionContentCard(
          variant: LumosCardVariant.filled,
          child: SizedBox.expand(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: horizontalInset),
                child: resolvedContent,
              ),
            ),
          ),
        );
      },
    );
  }
}

