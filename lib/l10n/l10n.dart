import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension AppLocalizationsContextExt on BuildContext {
  AppLocalizations get l10n {
    return AppLocalizations.of(this)!;
  }
}
