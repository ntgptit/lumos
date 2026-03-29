import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/theme/app_theme.dart';
import 'package:lumos/core/theme/responsive/screen_info.dart';
import 'package:lumos/domain/entities/folder_models.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/features/folder/screens/widgets/blocks/content/folder_list_tile.dart';

void main() {
  testWidgets('shows subfolder and deck counts without depth metadata', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _FolderTileTestApp(
        child: FolderListTile(
          item: const FolderNode(
            id: 1,
            name: 'Folder A',
            description: '',
            parentId: null,
            depth: 2,
            childFolderCount: 1,
            deckCount: 0,
          ),
          onOpen: _noop,
          onRename: _noop,
          onDelete: _noop,
        ),
      ),
    );

    expect(find.text('Folder A'), findsOneWidget);
    expect(find.text('1 subfolder • 0 decks'), findsOneWidget);
    expect(find.textContaining('Depth'), findsNothing);
  });
}

class _FolderTileTestApp extends StatelessWidget {
  const _FolderTileTestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.light(
        screenInfo: ScreenInfo.fromSize(const Size(390, 844)),
      ),
      home: Scaffold(body: child),
    );
  }
}

void _noop() {}
