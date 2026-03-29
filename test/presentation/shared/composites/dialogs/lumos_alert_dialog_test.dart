import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/theme/app_theme.dart';
import 'package:lumos/core/theme/responsive/adaptive_layout.dart';
import 'package:lumos/core/theme/responsive/screen_class.dart';
import 'package:lumos/core/theme/responsive/screen_info.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_alert_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog_icon.dart';

void main() {
  testWidgets('renders the provided business icon without a fallback icon', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _DialogTestApp(
        size: const Size(768, 1024),
        child: const Center(
          child: LumosAlertDialog(
            title: 'Create deck',
            icon: LumosDialogIcon(Icons.style_outlined),
            content: Text('Create a deck for this folder.'),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.style_outlined), findsOneWidget);
    expect(find.byIcon(Icons.info_rounded), findsNothing);
  });

  testWidgets(
    'uses the responsive dialog width instead of shrinking to content',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _DialogTestApp(
          size: const Size(768, 1024),
          child: const Center(
            child: LumosAlertDialog(
              title: 'Create folder',
              icon: LumosDialogIcon(Icons.create_new_folder_outlined),
              content: Text('Name'),
            ),
          ),
        ),
      );

      final Size dialogSize = tester.getSize(find.byType(AlertDialog));
      expect(
        dialogSize.width,
        closeTo(
          AdaptiveLayout.fromScreen(ScreenClass.medium).dialogMaxWidth,
          0.01,
        ),
      );
    },
  );
}

class _DialogTestApp extends StatelessWidget {
  const _DialogTestApp({required this.size, required this.child});

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(screenInfo: ScreenInfo.fromSize(size)),
      home: Scaffold(body: child),
    );
  }
}
