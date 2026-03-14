import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../core/providers/theme_provider.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../../study/providers/speech_preference_provider.dart';

abstract final class HomeProfileSupportConst {
  HomeProfileSupportConst._();

  static const double maxWidth = 560;
  static const List<String> speechVoices = <String>[
    'ko-KR-neutral',
    'ko-KR-female',
    'ko-KR-male',
  ];
  static const List<double> speechSpeeds = <double>[0.8, 1.0, 1.2, 1.5];
  static final List<int> firstLearningCardLimits = List<int>.generate(
    StudyPreference.maxFirstLearningCardLimit,
    (int index) => StudyPreference.minFirstLearningCardLimit + index,
    growable: false,
  );
}

AppThemePreference homeThemePreferenceFromMode({required ThemeMode mode}) {
  return switch (mode) {
    ThemeMode.light => AppThemePreference.light,
    ThemeMode.dark => AppThemePreference.dark,
    _ => AppThemePreference.system,
  };
}

String homeThemeLabel({
  required AppLocalizations l10n,
  required AppThemePreference preference,
}) {
  return switch (preference) {
    AppThemePreference.system => l10n.profileThemeSystem,
    AppThemePreference.light => l10n.profileThemeLight,
    AppThemePreference.dark => l10n.profileThemeDark,
  };
}

String homeQuickToggleLabel({
  required AppLocalizations l10n,
  required ThemeMode mode,
}) {
  return switch (mode) {
    ThemeMode.dark => l10n.profileThemeToggleToLight,
    _ => l10n.profileThemeToggleToDark,
  };
}

void saveSpeechPreference({
  required WidgetRef ref,
  required SpeechPreference preference,
}) {
  ref
      .read(speechPreferenceControllerProvider.notifier)
      .savePreference(preference);
}
