import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/presentation/shared/widgets/lumos_widgets.dart';

void main() {
  testWidgets('LumosButton shows loader and disables press while loading', (
    WidgetTester tester,
  ) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LumosButton(
            label: 'Submit',
            isLoading: true,
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(LumosButton));
    await tester.pump();
    expect(tapped, isFalse);
  });

  testWidgets('LumosCard handles tap callback', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LumosCard(
            onTap: () {
              tapped = true;
            },
            child: const Text('Card'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Card'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('LumosEmptyState renders action button when callback exists', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LumosEmptyState(
            title: 'Empty',
            message: 'No data',
            buttonLabel: 'Reload',
            onButtonPressed: _noop,
          ),
        ),
      ),
    );

    expect(find.text('Empty'), findsOneWidget);
    expect(find.text('No data'), findsOneWidget);
    expect(find.text('Reload'), findsOneWidget);
  });

  testWidgets('LumosErrorState renders default title and retry label', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LumosErrorState(errorMessage: 'Request failed', onRetry: _noop),
        ),
      ),
    );

    expect(find.text(LumosErrorStateConst.defaultTitle), findsOneWidget);
    expect(find.text(LumosErrorStateConst.defaultRetryLabel), findsOneWidget);
  });

  testWidgets('LumosProgressBar clamps value into valid range', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: LumosProgressBar(value: 2))),
    );

    final LinearProgressIndicator progressIndicator = tester.widget(
      find.byType(LinearProgressIndicator),
    );
    expect(progressIndicator.value, 1);
  });

  testWidgets('LumosText resolves style from text theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LumosText('Headline', style: LumosTextStyle.headlineSmall),
        ),
      ),
    );

    final Text textWidget = tester.widget(find.text('Headline'));
    expect(textWidget.style, isNotNull);
  });
}

void _noop() {}
