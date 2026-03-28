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
  String get appName => 'Lumos';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonCreate => 'Tạo';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonDelete => 'Xóa';

  @override
  String get commonSortBy => 'Sắp xếp theo';

  @override
  String get commonDirection => 'Thứ tự';

  @override
  String get commonRetry => 'Thử lại';

  @override
  String get commonRename => 'Đổi tên';

  @override
  String get commonConfirm => 'Xác nhận';

  @override
  String get commonShowPassword => 'Hiện mật khẩu';

  @override
  String get commonHidePassword => 'Ẩn mật khẩu';

  @override
  String get commonSomethingWentWrong => 'Đã xảy ra lỗi';

  @override
  String get commonCorrect => 'Đúng';

  @override
  String get commonIncorrect => 'Sai';

  @override
  String get commonResult => 'Kết quả';

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
  String get folderDescriptionLabel => 'Mô tả';

  @override
  String get folderDescriptionHint => 'Nhập mô tả thư mục';

  @override
  String get folderColorLabel => 'Màu sắc';

  @override
  String get folderManagerTitle => 'Quản lý thư mục';

  @override
  String get folderManagerSubtitle => 'Duyệt cây thư mục, tạo, đổi tên và xóa mềm thư mục.';

  @override
  String get deckManagerTitle => 'Quản lý deck';

  @override
  String get deckManagerSubtitle => 'Quản lý các deck trong thư mục hiện tại.';

  @override
  String get folderSearchHint => 'Tìm thư mục';

  @override
  String get folderSearchClearTooltip => 'Xóa tìm kiếm';

  @override
  String get deckSearchHint => 'Tìm deck';

  @override
  String get deckSearchClearTooltip => 'Xóa tìm kiếm deck';

  @override
  String get folderOpenParentTooltip => 'Mở thư mục cha';

  @override
  String get folderSortTitle => 'Sắp xếp thư mục';

  @override
  String get folderSortByName => 'Tên';

  @override
  String get folderSortByCreatedAt => 'Thời gian tạo';

  @override
  String get folderSortNameAscending => 'Tên A-Z';

  @override
  String get folderSortNameDescending => 'Tên Z-A';

  @override
  String get folderSortCreatedNewest => 'Tạo gần đây nhất';

  @override
  String get folderSortCreatedOldest => 'Tạo lâu nhất';

  @override
  String get folderRoot => 'Gốc';

  @override
  String get folderEmptyTitle => 'Chưa có thư mục nào.';

  @override
  String get folderEmptySubtitle => 'Hãy tạo một thư mục để bắt đầu sắp xếp nội dung.';

  @override
  String get folderSearchEmptyTitle => 'Không có thư mục phù hợp.';

  @override
  String get folderSearchEmptySubtitle => 'Hãy thử từ khóa khác.';

  @override
  String get folderNameRequiredValidation => 'Tên thư mục là bắt buộc.';

  @override
  String folderNameMinLengthValidation(int min) {
    return 'Tên thư mục phải có ít nhất $min ký tự.';
  }

  @override
  String folderNameMaxLengthValidation(int max) {
    return 'Tên thư mục tối đa $max ký tự.';
  }

  @override
  String folderDescriptionMaxLengthValidation(int max) {
    return 'Mô tả tối đa $max ký tự.';
  }

  @override
  String get folderColorInvalidValidation => 'Màu thư mục không hợp lệ.';

  @override
  String folderDeleteConfirm(Object name) {
    return 'Xóa \"$name\" và toàn bộ thư mục con?';
  }

  @override
  String folderDepth(int depth) {
    return 'Độ sâu $depth';
  }

  @override
  String get deckNewDeck => 'Deck mới';

  @override
  String get deckCreateTitle => 'Tạo deck';

  @override
  String get deckRenameTitle => 'Đổi tên deck';

  @override
  String get deckDeleteTitle => 'Xóa deck';

  @override
  String get deckSortTitle => 'Sắp xếp deck';

  @override
  String get deckSortByName => 'Tên';

  @override
  String get deckSortNameAscending => 'Tên A-Z';

  @override
  String get deckSortNameDescending => 'Tên Z-A';

  @override
  String get deckNameLabel => 'Tên deck';

  @override
  String get deckDescriptionLabel => 'Mô tả';

  @override
  String get deckDescriptionHint => 'Nhập mô tả deck';

  @override
  String get deckEmptyTitle => 'Chưa có deck nào.';

  @override
  String get deckEmptySubtitle => 'Hãy tạo deck để bắt đầu sắp xếp thẻ.';

  @override
  String get deckSearchEmptyTitle => 'Không có deck phù hợp.';

  @override
  String get deckSearchEmptySubtitle => 'Hãy thử từ khóa khác.';

  @override
  String get deckLibraryEntryTitle => 'Deck nằm trong thư mục.';

  @override
  String get deckLibraryEntryMessage => 'Hãy mở thư mục để tạo, tìm kiếm và quản lý deck theo đúng ngữ cảnh.';

  @override
  String get deckLibraryEntryAction => 'Mở thư mục';

  @override
  String get deckNameRequiredValidation => 'Tên deck là bắt buộc.';

  @override
  String deckNameMinLengthValidation(int min) {
    return 'Tên deck phải có ít nhất $min ký tự.';
  }

  @override
  String deckNameMaxLengthValidation(int max) {
    return 'Tên deck tối đa $max ký tự.';
  }

  @override
  String deckDescriptionMaxLengthValidation(int max) {
    return 'Mô tả tối đa $max ký tự.';
  }

  @override
  String deckDeleteConfirm(Object name) {
    return 'Xóa deck \"$name\"?';
  }

  @override
  String deckFlashcardCount(int count) {
    return '$count thẻ';
  }

  @override
  String deckCount(int count) {
    return '$count deck';
  }

  @override
  String get flashcardTitle => 'Flashcard';

  @override
  String get flashcardCreateButton => 'Thẻ mới';

  @override
  String get flashcardCreateTitle => 'Tạo flashcard';

  @override
  String get flashcardEditTitle => 'Sửa flashcard';

  @override
  String get flashcardDeleteTitle => 'Xóa flashcard';

  @override
  String flashcardDeleteConfirm(Object name) {
    return 'Xóa \"$name\"?';
  }

  @override
  String get flashcardSearchHint => 'Tìm flashcard';

  @override
  String get flashcardSearchClearTooltip => 'Xóa tìm kiếm flashcard';

  @override
  String get flashcardToggleSearchTooltip => 'Bật/tắt tìm kiếm flashcard';

  @override
  String get flashcardSortButtonTooltip => 'Sắp xếp flashcard';

  @override
  String get flashcardSortSheetTitle => 'Sắp xếp flashcard';

  @override
  String get flashcardSortByCreatedAt => 'Thời gian tạo';

  @override
  String get flashcardSortByUpdatedAt => 'Thời gian cập nhật';

  @override
  String get flashcardSortByFrontText => 'Mặt trước';

  @override
  String get flashcardSortDirectionDesc => 'Mới nhất trước';

  @override
  String get flashcardSortDirectionAsc => 'Cũ nhất trước';

  @override
  String get flashcardSortDirectionAz => 'A-Z';

  @override
  String get flashcardSortDirectionZa => 'Z-A';

  @override
  String get flashcardSortSaveButton => 'Áp dụng';

  @override
  String get flashcardCardSectionTitle => 'Danh sách thẻ';

  @override
  String get flashcardEmptyTitle => 'Chưa có flashcard nào.';

  @override
  String get flashcardEmptySubtitle => 'Hãy tạo thẻ đầu tiên để bắt đầu học.';

  @override
  String get flashcardSearchEmptyTitle => 'Không có flashcard phù hợp.';

  @override
  String get flashcardSearchEmptySubtitle => 'Hãy thử từ khóa khác.';

  @override
  String get flashcardFrontLabel => 'Mặt trước';

  @override
  String get flashcardFrontHint => 'Nhập nội dung mặt trước';

  @override
  String get flashcardBackLabel => 'Mặt sau';

  @override
  String get flashcardBackHint => 'Nhập nội dung mặt sau';

  @override
  String get flashcardFrontRequiredValidation => 'Nội dung mặt trước là bắt buộc.';

  @override
  String flashcardFrontMaxLengthValidation(int max) {
    return 'Mặt trước tối đa $max ký tự.';
  }

  @override
  String get flashcardBackRequiredValidation => 'Nội dung mặt sau là bắt buộc.';

  @override
  String flashcardBackMaxLengthValidation(int max) {
    return 'Mặt sau tối đa $max ký tự.';
  }

  @override
  String get flashcardOwnerFallback => 'Người tạo';

  @override
  String get flashcardPlusBadge => 'Plus';

  @override
  String get flashcardUpdatedRecentlyLabel => 'Cập nhật gần đây';

  @override
  String flashcardTotalLabel(int count) {
    return '$count thẻ';
  }

  @override
  String get flashcardExpandPreviewTooltip => 'Mở chế độ học thẻ';

  @override
  String get flashcardPreviewPlaceholder => 'Chưa có nội dung xem trước';

  @override
  String get flashcardReviewActionLabel => 'Thẻ ghi nhớ';

  @override
  String get flashcardFlipActionLabel => 'Lật thẻ';

  @override
  String get flashcardLearnActionLabel => 'Học';

  @override
  String get flashcardQuizActionLabel => 'Kiểm tra';

  @override
  String get flashcardMatchActionLabel => 'Ghép thẻ';

  @override
  String get flashcardBlastActionLabel => 'Blast';

  @override
  String get flashcardProgressTitle => 'Tiến độ của bạn';

  @override
  String get flashcardProgressDescription => 'Tiến độ dựa trên hai lần học gần nhất của bạn ở tất cả chế độ, ngoại trừ trò chơi.';

  @override
  String get flashcardProgressNotStartedLabel => 'Chưa học';

  @override
  String get flashcardProgressLearningLabel => 'Đang học';

  @override
  String get flashcardProgressMasteredLabel => 'Thành thạo';

  @override
  String get flashcardStudyDeckButton => 'Học bộ học phần này';

  @override
  String get flashcardPlayAudioTooltip => 'Phát âm thanh';

  @override
  String get flashcardBookmarkTooltip => 'Đánh dấu';

  @override
  String get flashcardEditTooltip => 'Sửa thẻ';

  @override
  String get flashcardDeleteTooltip => 'Xóa thẻ';

  @override
  String get flashcardShareButtonTooltip => 'Chia sẻ bộ thẻ';

  @override
  String get flashcardMoreButtonTooltip => 'Thêm tùy chọn';

  @override
  String flashcardAudioPlayToast(Object text) {
    return 'Đang phát: $text';
  }

  @override
  String get flashcardBookmarkToast => 'Đã đánh dấu thẻ';

  @override
  String get flashcardUnbookmarkToast => 'Đã bỏ đánh dấu';

  @override
  String get flashcardShareComingSoonToast => 'Tính năng chia sẻ sẽ sớm có.';

  @override
  String get flashcardMoreOptionsComingSoonToast => 'Các tùy chọn bổ sung sẽ sớm có.';

  @override
  String get flashcardStudyUnavailableToast => 'Không có thẻ để học.';

  @override
  String get flashcardStudyCompletedToast => 'Đã hoàn thành phiên học.';

  @override
  String get flashcardLearnSheetTitle => 'Chọn cách học';

  @override
  String get flashcardLearnSheetSubtitle => 'Chọn phiên học bạn muốn bắt đầu cho bộ thẻ này.';

  @override
  String get flashcardLearnContinueOptionTitle => 'Học tiếp từ chưa học/chưa pass';

  @override
  String get flashcardLearnContinueOptionSubtitle => 'Học các từ vựng còn mới hoặc chưa vượt qua.';

  @override
  String get flashcardLearnReviewOptionTitle => 'Review từ đến hạn SRS';

  @override
  String get flashcardLearnReviewOptionSubtitle => 'Ôn tập các từ vựng đã đến hạn theo lịch SRS.';

  @override
  String get flashcardLearnResetOptionTitle => 'Reset chế độ học';

  @override
  String get flashcardLearnResetOptionSubtitle => 'Xóa tiến trình học của bộ thẻ này để bắt đầu lại.';

  @override
  String get flashcardLearnContinueUnavailableToast => 'Hiện không có từ mới hoặc từ chưa pass để học.';

  @override
  String get flashcardLearnReviewUnavailableToast => 'Hiện không có từ vựng nào đến hạn review.';

  @override
  String get flashcardLearnResetConfirmTitle => 'Reset tiến trình học?';

  @override
  String get flashcardLearnResetConfirmMessage => 'Thao tác này sẽ reset toàn bộ tiến trình học của bộ thẻ hiện tại.';

  @override
  String get flashcardLearnResetConfirmAction => 'Reset tiến trình';

  @override
  String get flashcardLearnResetSuccessToast => 'Đã reset tiến trình học.';

  @override
  String get flashcardCloseTooltip => 'Đóng màn hình học';

  @override
  String get flashcardPreviousButton => 'Trước';

  @override
  String get flashcardNextButton => 'Tiếp';

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
  String get homeProfileQuickName => 'Người học';

  @override
  String get homeLibrarySubtitle => 'Bộ thẻ, bài học và gói học đã tuyển chọn của bạn.';

  @override
  String get homeProgressSubtitle => 'Theo dõi chuỗi ngày, xu hướng XP và kỹ năng còn yếu.';

  @override
  String get homeProfileSubtitle => 'Quản lý mục tiêu và tùy chọn học tập của bạn.';

  @override
  String get profileAccountSectionTitle => 'Tài khoản';

  @override
  String get profileAccountSectionSubtitle => 'Xem lại thông tin nhận diện và trạng thái của tài khoản đang đăng nhập.';

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

  @override
  String get commonLogout => 'Đăng xuất';

  @override
  String get commonContinue => 'Tiếp tục';

  @override
  String get commonNext => 'Tiếp theo';

  @override
  String get commonSubmit => 'Gửi';

  @override
  String get commonCheck => 'Kiểm tra';

  @override
  String get commonReplay => 'Phát lại';

  @override
  String get navigationDashboardLabel => 'Trang chủ';

  @override
  String get navigationFoldersLabel => 'Thư mục';

  @override
  String get navigationDecksLabel => 'Thư viện';

  @override
  String get navigationProgressLabel => 'Tiến độ';

  @override
  String get navigationSettingsLabel => 'Hồ sơ';

  @override
  String get loading => 'Đang tải...';

  @override
  String get splashTitle => 'Đang chuẩn bị không gian học tập của bạn';

  @override
  String get clearSelectionTooltip => 'Bỏ chọn';

  @override
  String selectionCountLabel(int count) {
    return 'Đã chọn $count';
  }

  @override
  String get filterTooltip => 'Lọc';

  @override
  String get sortTooltip => 'Sắp xếp';

  @override
  String get noResultsTitle => 'Không tìm thấy kết quả';

  @override
  String get noResultsMessage => 'Hãy thử điều chỉnh bộ lọc hoặc từ khóa tìm kiếm.';

  @override
  String get offlineTitle => 'Bạn đang ngoại tuyến';

  @override
  String get offlineMessage => 'Kiểm tra kết nối Internet rồi thử lại.';

  @override
  String get offlineRetryLabel => 'Thử lại';

  @override
  String get accessRequiredTitle => 'Cần quyền truy cập';

  @override
  String get signInMessage => 'Đăng nhập để tiếp tục.';

  @override
  String get signInLabel => 'Đăng nhập';

  @override
  String get selectDateLabel => 'Chọn ngày';

  @override
  String get clearDateTooltip => 'Xóa ngày';

  @override
  String get requiredFieldMark => ' *';

  @override
  String get searchLabel => 'Tìm kiếm';

  @override
  String get clearSearchTooltip => 'Xóa tìm kiếm';

  @override
  String get selectTimeLabel => 'Chọn giờ';

  @override
  String get clearTimeTooltip => 'Xóa giờ';

  @override
  String get maintenanceTitle => 'Bảo trì';

  @override
  String get maintenanceMessage => 'Hệ thống hiện tạm thời không khả dụng.';

  @override
  String get notFoundTitle => 'Không tìm thấy trang';

  @override
  String get notFoundMessage => 'Trang bạn yêu cầu không tồn tại.';

  @override
  String get authTitle => 'Lumos';

  @override
  String get authSubtitle => 'Xác thực trước, sau đó tiếp tục học theo trạng thái chuẩn từ backend.';

  @override
  String get authLoginTab => 'Đăng nhập';

  @override
  String get authRegisterTab => 'Đăng ký';

  @override
  String get authSignInAction => 'Đăng nhập';

  @override
  String get authCreateAccountAction => 'Tạo tài khoản';

  @override
  String get authUsernameLabel => 'Tên người dùng';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Mật khẩu';

  @override
  String get authUsernameOrEmailLabel => 'Tên người dùng hoặc email';

  @override
  String get authShowPasswordTooltip => 'Hiện mật khẩu';

  @override
  String get authHidePasswordTooltip => 'Ẩn mật khẩu';

  @override
  String get profileSpeechSectionTitle => 'Tùy chọn giọng đọc';

  @override
  String get profileSpeechSectionSubtitle => 'Chọn giọng đọc mặc định cho thiết bị này và nghe thử trước khi vào chế độ học.';

  @override
  String get profileSpeechEnabledLabel => 'Bật giọng đọc tiếng Hàn';

  @override
  String get profileSpeechAutoPlayLabel => 'Tự phát mục hiện tại';

  @override
  String get profileSpeechAdapterLabel => 'Bộ máy đọc';

  @override
  String get profileSpeechAdapterFlutterTtsLabel => 'TTS thiết bị (Flutter TTS)';

  @override
  String get profileSpeechVoiceLabel => 'Giọng đọc';

  @override
  String get profileSpeechVoiceDefaultLabel => 'Giọng mặc định của thiết bị';

  @override
  String get profileSpeechSpeedLabel => 'Tốc độ';

  @override
  String get profileSpeechPitchLabel => 'Độ trầm bổng';

  @override
  String get profileSpeechPreviewTitle => 'Nghe thử giọng đọc';

  @override
  String get profileSpeechPreviewSubtitle => 'Chỉnh nội dung mẫu bên dưới rồi nghe thử với giọng đọc, tốc độ và độ trầm bổng hiện tại.';

  @override
  String get profileSpeechPreviewTextLabel => 'Nội dung nghe thử';

  @override
  String get profileSpeechPreviewPlayLabel => 'Nghe thử';

  @override
  String get profileSpeechPreviewStopLabel => 'Dừng';

  @override
  String get profileSpeechPreviewDefaultText => '안녕하세요. 이 문장은 현재 음성과 속도, 음높이를 테스트하기 위한 예시입니다.';

  @override
  String get profileSpeechPreviewPlaybackError => 'Thiết bị không thể phát đoạn nghe thử.';

  @override
  String get profileStudySectionTitle => 'Tùy chọn phiên học';

  @override
  String get profileStudySectionSubtitle => 'Thiết lập số thẻ mới mà backend được phép nạp cho mỗi phiên FIRST_LEARNING.';

  @override
  String get profileStudyFirstLearningLimitLabel => 'Số thẻ mới mỗi phiên FIRST_LEARNING';

  @override
  String profileStudyFirstLearningLimitValue(int count) {
    return '$count thẻ';
  }

  @override
  String get profileStudyReviewHint => 'Phiên REVIEW luôn lấy toàn bộ thẻ đã đến hạn.';

  @override
  String get studyProgressMomentumTitle => 'Nhịp độ học tập';

  @override
  String studyProgressMomentumSummary(int dueCount, int overdueCount, Object escalationLevel) {
    return 'Đến hạn $dueCount | Quá hạn $overdueCount | Leo thang $escalationLevel';
  }

  @override
  String get studyProgressRecommendedReviewTitle => 'Ôn tập được đề xuất';

  @override
  String studyProgressRecommendedReviewSummary(Object deckName, int dueCount) {
    return '$deckName · $dueCount thẻ đến hạn';
  }

  @override
  String get studyProgressStartReviewAction => 'Bắt đầu ôn tập';

  @override
  String get studyProgressBoxDistributionTitle => 'Phân bố 7 hộp';

  @override
  String studyProgressBoxLabel(int boxIndex) {
    return 'Hộp $boxIndex';
  }

  @override
  String get studyMatchCheckAction => 'Kiểm tra';

  @override
  String studyMatchCompletedItemLabel(Object label) {
    return 'Đã ghép · $label';
  }

  @override
  String studySpeechPanelTitle(Object locale) {
    return 'Chuyển văn bản thành giọng nói · $locale';
  }

  @override
  String studySpeechPanelVoiceSummary(Object voice, Object speed) {
    return 'Giọng: $voice · Tốc độ: ${speed}x';
  }

  @override
  String get studySpeechPlayAction => 'Nghe';

  @override
  String get studySpeechPlayingAction => 'Đang phát';

  @override
  String get studySpeechReplayAction => 'Phát lại';

  @override
  String get studyReviewFirstCardToast => 'Đây là thẻ đầu tiên.';

  @override
  String get studyResetCurrentModeAction => 'Đặt lại chế độ hiện tại';

  @override
  String get studyResetCurrentModeTitle => 'Đặt lại chế độ hiện tại?';

  @override
  String get studyResetCurrentModeMessage => 'Thao tác này sẽ xóa toàn bộ tiến độ trong chế độ học hiện tại và bắt đầu lại từ mục đầu tiên.';

  @override
  String get studyResetCurrentModeConfirm => 'Đặt lại chế độ';

  @override
  String get deckEditTooltip => 'Sửa deck';

  @override
  String get deckDeleteTooltip => 'Xóa deck';

  @override
  String get flashcardAgainAction => 'Học lại';

  @override
  String get flashcardKnownAction => 'Đã biết';

  @override
  String get exerciseMatchPairsTitle => 'Ghép cặp';

  @override
  String get exerciseCompletedLabel => 'Hoàn thành';

  @override
  String get exerciseSubmitMatchesLabel => 'Gửi cặp ghép';

  @override
  String get exerciseReorderWordsTitle => 'Sắp xếp từ';

  @override
  String get exerciseCheckOrderLabel => 'Kiểm tra thứ tự';

  @override
  String get exerciseListeningTitle => 'Bài nghe';

  @override
  String get feedbackGreatJob => 'Làm tốt lắm!';

  @override
  String feedbackResultSummaryCorrect(int correctCount, int totalCount) {
    return '$correctCount / $totalCount câu đúng';
  }

  @override
  String feedbackResultSummaryXpEarned(int xpEarned) {
    return 'XP nhận được: $xpEarned';
  }

  @override
  String feedbackResultSummaryStreakBonus(int streakBonus) {
    return 'Thưởng chuỗi ngày: +$streakBonus XP';
  }

  @override
  String gamificationLevelLabel(int level) {
    return 'Cấp $level';
  }

  @override
  String gamificationXpLabel(int xp) {
    return '$xp XP';
  }

  @override
  String get gamificationDailyGoalTitle => 'Mục tiêu hằng ngày';

  @override
  String gamificationDailyGoalProgress(int current, int goal, Object unit) {
    return '$current/$goal $unit';
  }

  @override
  String learningReviewProgressLabel(int completed, int total) {
    return '$completed / $total đã ôn';
  }

  @override
  String learningEstimateMinutesLeft(int minutes) {
    return 'Còn $minutes phút';
  }

  @override
  String get learningStatisticsTitle => 'Thống kê';

  @override
  String learningStatisticsTotal(int count) {
    return 'Tổng: $count';
  }

  @override
  String learningStatisticsMastered(int count) {
    return 'Đã thành thạo: $count';
  }

  @override
  String learningStatisticsLearning(int count) {
    return 'Đang học: $count';
  }

  @override
  String learningStatisticsDue(int count) {
    return 'Đến hạn: $count';
  }

  @override
  String learningReviewQueueDueToday(int count) {
    return 'Đến hạn hôm nay: $count';
  }

  @override
  String learningReviewQueueSize(int count) {
    return 'Kích thước hàng đợi: $count';
  }

  @override
  String get learningStartReviewAction => 'Bắt đầu ôn tập';

  @override
  String get onboardingPlacementTestTitle => 'Bài kiểm tra xếp lớp';

  @override
  String onboardingQuestionCount(int count) {
    return '$count câu hỏi';
  }

  @override
  String get onboardingCompleteTestAction => 'Hoàn thành bài kiểm tra';

  @override
  String get formAnswerHint => 'Nhập câu trả lời';

  @override
  String get studyFillAnswerRequiredValidation => 'Câu trả lời là bắt buộc.';

  @override
  String get formTapToSpeakAction => 'Chạm để nói';

  @override
  String get formFillBlankHint => 'Điền vào chỗ trống';

  @override
  String get placeholderForgotPasswordTitle => 'Quên mật khẩu';

  @override
  String get placeholderForgotPasswordMessage => 'Luồng khôi phục mật khẩu vẫn chưa được nối lại.';

  @override
  String get placeholderDeckListTitle => 'Bộ thẻ';

  @override
  String get placeholderDeckListMessage => 'Bộ điều hợp danh sách bộ thẻ đang hoạt động.';

  @override
  String placeholderDeckListInFolderMessage(int folderId) {
    return 'Bộ điều hợp danh sách bộ thẻ đang hoạt động cho thư mục $folderId.';
  }

  @override
  String get placeholderOnboardingTitle => 'Onboarding';

  @override
  String get placeholderPermissionsTitle => 'Quyền truy cập';

  @override
  String get placeholderStudyGoalSetupTitle => 'Thiết lập mục tiêu học tập';

  @override
  String get placeholderDeckProgressTitle => 'Tiến độ bộ thẻ';

  @override
  String placeholderDeckProgressMessage(int deckId) {
    return 'Bộ điều hợp tiến độ của bộ thẻ $deckId đang hoạt động.';
  }

  @override
  String get placeholderStudyCalendarTitle => 'Lịch học tập';

  @override
  String get placeholderReminderPreviewTitle => 'Xem trước nhắc nhở';

  @override
  String get placeholderReminderSettingsTitle => 'Cài đặt nhắc nhở';

  @override
  String get placeholderReminderTimeSlotsTitle => 'Khung giờ nhắc nhở';

  @override
  String get placeholderAboutTitle => 'Giới thiệu';

  @override
  String get placeholderAudioSettingsTitle => 'Cài đặt âm thanh';

  @override
  String get placeholderBackupRestoreTitle => 'Sao lưu và khôi phục';

  @override
  String get placeholderLanguageSettingsTitle => 'Cài đặt ngôn ngữ';

  @override
  String get placeholderThemeSettingsTitle => 'Cài đặt giao diện';

  @override
  String get placeholderStudyHistoryTitle => 'Lịch sử học tập';

  @override
  String get placeholderStudyModePickerTitle => 'Chọn chế độ học';

  @override
  String get placeholderStudyModePickerReviewAction => 'Ôn tập';

  @override
  String get placeholderStudyResultTitle => 'Kết quả học tập';

  @override
  String get placeholderStudyResultRestartAction => 'Bắt đầu lại';

  @override
  String get placeholderStudyResultHistoryAction => 'Lịch sử';

  @override
  String get placeholderStudyResultReturnAction => 'Quay lại';

  @override
  String get placeholderStudySessionTitle => 'Phiên học';

  @override
  String get placeholderStudySessionModePickerAction => 'Chọn chế độ';

  @override
  String get placeholderStudySessionFinishAction => 'Kết thúc phiên';

  @override
  String get placeholderStudySessionExitAction => 'Thoát';

  @override
  String get placeholderStudySetupTitle => 'Thiết lập phiên học';

  @override
  String get placeholderStudySetupStartAction => 'Bắt đầu phiên';

  @override
  String get placeholderStudySetupModePickerAction => 'Chọn chế độ';

  @override
  String get placeholderStudySetupHistoryAction => 'Lịch sử';
}
