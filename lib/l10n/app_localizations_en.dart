// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lumos';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonRename => 'Rename';

  @override
  String get folderNewFolder => 'New Folder';

  @override
  String get folderCreateTitle => 'Create folder';

  @override
  String get folderRenameTitle => 'Rename folder';

  @override
  String get folderDeleteTitle => 'Delete folder';

  @override
  String get folderNameLabel => 'Folder name';

  @override
  String get folderManagerTitle => 'Folder Manager';

  @override
  String get folderManagerSubtitle => 'Browse tree, create, rename, and soft-delete folders.';

  @override
  String get folderRoot => 'Root';

  @override
  String get folderEmptyTitle => 'No folders here yet.';

  @override
  String get folderEmptySubtitle => 'Create one to start organizing content.';

  @override
  String folderDeleteConfirm(Object name) {
    return 'Delete \"$name\" and all subfolders?';
  }

  @override
  String folderDepth(int depth) {
    return 'Depth $depth';
  }
}
