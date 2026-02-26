// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Lumos';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonCreate => 'Tạo';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonDelete => 'Xóa';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get commonRename => 'Đổi tên';

  @override
  String get folderNewFolder => 'Thư mục mới';

  @override
  String get folderCreateTitle => 'Tạo thư mục';

  @override
  String get folderRenameTitle => 'Đổi tên thư mục';

  @override
  String get folderDeleteTitle => 'Xóa thư mục';

  @override
  String get folderNameLabel => 'Tên thư mục';

  @override
  String get folderManagerTitle => 'Quản lý thư mục';

  @override
  String get folderManagerSubtitle => 'Duyệt cây thư mục, tạo, đổi tên và xóa mềm thư mục.';

  @override
  String get folderRoot => 'Gốc';

  @override
  String get folderEmptyTitle => 'Chưa có thư mục nào.';

  @override
  String get folderEmptySubtitle => 'Hãy tạo một thư mục để bắt đầu sắp xếp nội dung.';

  @override
  String folderDeleteConfirm(Object name) {
    return 'Xóa \"$name\" và toàn bộ thư mục con?';
  }

  @override
  String folderDepth(int depth) {
    return 'Độ sâu $depth';
  }
}
