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

  @override
  String get homeGreeting => 'Chào buổi tối, người học';

  @override
  String get homeGoalProgress => 'Bạn đã hoàn thành 78% mục tiêu tuần này.';

  @override
  String get homeHeroTitle => 'Xây dựng độ trôi chảy với đà tiến bộ';

  @override
  String get homeHeroBody => 'Các phiên học hằng ngày, luyện tập tập trung và theo dõi tiến độ trực quan trong một không gian hiện đại.';

  @override
  String get homeAiLearningPath => 'Lộ trình học bằng AI';

  @override
  String get homePrimaryAction => 'Bắt đầu phiên học';

  @override
  String get homeSecondaryAction => 'Ôn bộ thẻ';

  @override
  String get homeStreakLabel => 'Chuỗi ngày';

  @override
  String get homeAccuracyLabel => 'Độ chính xác';

  @override
  String get homeXpLabel => 'XP tuần';

  @override
  String get homeStatStreakValue => '12 ngày';

  @override
  String get homeStatAccuracyValue => '94%';

  @override
  String get homeStatXpValue => '2.460';

  @override
  String get homeFocusTitle => 'Trọng tâm hôm nay';

  @override
  String get homeTaskShadowListeningTitle => 'Nghe nhại - 15 phút';

  @override
  String get homeTaskVocabularyTitle => 'Tăng tốc từ vựng - 20 từ';

  @override
  String get homeTaskPronunciationTitle => 'Luyện phát âm - 10 phút';

  @override
  String get homeActivityTitle => 'Hoạt động gần đây';

  @override
  String get homeActivitySpanishTitle => 'Gói du lịch tiếng Tây Ban Nha';

  @override
  String get homeActivitySpanishSubtitle => 'Hoàn thành 18 thẻ';

  @override
  String get homeActivitySpanishTrailing => '+120 XP';

  @override
  String get homeActivityGrammarTitle => 'Ngữ pháp: Hiện tại hoàn thành';

  @override
  String get homeActivityGrammarSubtitle => 'Đạt 9/10';

  @override
  String get homeActivityGrammarTrailing => '+60 XP';

  @override
  String get homeActivitySpeakingTitle => 'Thử thách nói';

  @override
  String get homeActivitySpeakingSubtitle => 'Chuỗi tốt nhất mới: 5';

  @override
  String get homeActivitySpeakingTrailing => 'Huy hiệu';

  @override
  String get homeTabHome => 'Trang chủ';

  @override
  String get homeTabLibrary => 'Thư viện';

  @override
  String get homeTabFolders => 'Thư mục';

  @override
  String get homeTabProgress => 'Tiến độ';

  @override
  String get homeTabProfile => 'Hồ sơ';

  @override
  String get homeLibrarySubtitle => 'Bộ thẻ, bài học và gói học đã tuyển chọn của bạn.';

  @override
  String get homeProgressSubtitle => 'Theo dõi chuỗi ngày, xu hướng XP và kỹ năng còn yếu.';

  @override
  String get homeProfileSubtitle => 'Quản lý mục tiêu và tùy chọn học tập của bạn.';

  @override
  String get profileThemeSectionTitle => 'Giao diện';

  @override
  String get profileThemeSectionSubtitle => 'Chọn cách hiển thị chủ đề của ứng dụng.';

  @override
  String get profileThemeSystem => 'Theo hệ thống';

  @override
  String get profileThemeLight => 'Sáng';

  @override
  String get profileThemeDark => 'Tối';

  @override
  String get profileThemeToggleToLight => 'Chuyển nhanh sang chế độ sáng';

  @override
  String get profileThemeToggleToDark => 'Chuyển nhanh sang chế độ tối';
}
