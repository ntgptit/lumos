import '../../../../l10n/app_localizations.dart';
import '../providers/states/enums/home_tab_id.dart';

extension HomeTabIdL10nExtension on HomeTabId {
  String toLocalizedLabel(AppLocalizations l10n) {
    return switch (this) {
      HomeTabId.home => l10n.homeTabHome,
      HomeTabId.library => l10n.homeTabLibrary,
      HomeTabId.folders => l10n.homeTabFolders,
      HomeTabId.progress => l10n.homeTabProgress,
      HomeTabId.profile => l10n.homeTabProfile,
    };
  }
}
