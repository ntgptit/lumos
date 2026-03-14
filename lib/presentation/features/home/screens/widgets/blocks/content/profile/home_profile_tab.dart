import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../core/providers/theme_provider.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import 'home_profile_content.dart';
import 'home_profile_support.dart';

class HomeProfileTab extends ConsumerWidget {
  const HomeProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeMode themeMode = ref.watch(appThemeModeProvider);
    final AppThemePreference selectedPreference = homeThemePreferenceFromMode(
      mode: themeMode,
    );
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: HomeProfileSupportConst.maxWidth,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: HomeProfileContent(
            l10n: l10n,
            themeMode: themeMode,
            selectedPreference: selectedPreference,
          ),
        ),
      ),
    );
  }
}
