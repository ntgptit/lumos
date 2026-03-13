import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../mode/study_fill_answer_comparison.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import 'study_session_fill_panel_style.dart';

const double _fillComparisonSpacing = AppSpacing.canvas;

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
              const SizedBox(height: _fillComparisonSpacing),
              Text.rich(
                TextSpan(
                  style: resolvedBaseStyle,
                  children: <InlineSpan>[
                    if (comparison.prefix.isNotEmpty)
                      TextSpan(text: comparison.prefix),
                    if (comparison.errorSuffix.isNotEmpty)
                      TextSpan(text: comparison.errorSuffix, style: errorStyle),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
    return LumosCard(
      margin: EdgeInsets.zero,
      variant: LumosCardVariant.filled,
      borderRadius: BorderRadii.xLarge,
      padding: EdgeInsets.zero,
      child: SizedBox.expand(
        child: Center(child: SingleChildScrollView(child: answerContent)),
      ),
    );
  }
}
