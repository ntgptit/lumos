import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/presentation/features/study/screens/widgets/sub_mode/fill/widgets/study_session_fill_answer_panel.dart';

void main() {
  testWidgets('wrong fill answer highlights the mismatched suffix', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StudySessionFillAnswerPanel(
            content: '안녕하세요',
            submittedAnswer: '안녕히',
            mismatchStartIndex: 2,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('안녕하세요'), findsOneWidget);

    final Finder answerTextFinder = find.byWidgetPredicate((Widget widget) {
      if (widget is! RichText) {
        return false;
      }
      return widget.text.toPlainText() == '안녕히';
    });

    final RichText richText = tester.widget<RichText>(answerTextFinder);
    final TextSpan textSpan = richText.text as TextSpan;
    final List<TextSpan> spans = _flattenTextSpans(textSpan);
    final List<String> texts = spans
        .map((TextSpan span) => span.text ?? '')
        .where((String text) => text.isNotEmpty)
        .toList(growable: false);

    expect(texts, contains('안녕'));
    expect(texts, contains('히'));
  });

  testWidgets(
    'help-style reveal shows correct answer above and full error below',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StudySessionFillAnswerPanel(
              content: '안녕하세요',
              submittedAnswer: '',
              mismatchStartIndex: 0,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('안녕하세요'), findsNWidgets(2));
    },
  );
}

List<TextSpan> _flattenTextSpans(TextSpan span) {
  final List<TextSpan> spans = <TextSpan>[span];
  final List<InlineSpan> children = span.children ?? const <InlineSpan>[];
  for (final InlineSpan child in children) {
    if (child is! TextSpan) {
      continue;
    }
    spans.addAll(_flattenTextSpans(child));
  }
  return spans;
}
