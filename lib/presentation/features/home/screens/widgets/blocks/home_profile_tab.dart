import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../core/providers/theme_provider.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../auth/providers/auth_session_provider.dart';
import '../../../../study/providers/speech_preference_provider.dart';
import '../../../../study/providers/study_preference_provider.dart';

abstract final class HomeProfileTabConst {
  HomeProfileTabConst._();

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

class HomeProfileTab extends ConsumerWidget {
  const HomeProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeMode themeMode = ref.watch(appThemeModeProvider);
    final AppThemePreference selectedPreference = _toPreference(
      mode: themeMode,
    );
    final Widget content = _buildContent(
      ref: ref,
      l10n: l10n,
      themeMode: themeMode,
      selectedPreference: selectedPreference,
    );
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: HomeProfileTabConst.maxWidth,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: content,
        ),
      ),
    );
  }

  Widget _buildContent({
    required WidgetRef ref,
    required AppLocalizations l10n,
    required ThemeMode themeMode,
    required AppThemePreference selectedPreference,
  }) {
    final AsyncValue<SpeechPreference> speechAsync = ref.watch(
      speechPreferenceControllerProvider,
    );
    final AsyncValue<StudyPreference> studyAsync = ref.watch(
      studyPreferenceControllerProvider,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildThemeCard(
          ref: ref,
          l10n: l10n,
          themeMode: themeMode,
          selectedPreference: selectedPreference,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildStudyCard(ref: ref, l10n: l10n, studyAsync: studyAsync),
        const SizedBox(height: AppSpacing.lg),
        _buildSpeechCard(ref: ref, l10n: l10n, speechAsync: speechAsync),
        const SizedBox(height: AppSpacing.lg),
        LumosDangerButton(
          onPressed: () async {
            await ref.read(authSessionControllerProvider.notifier).logout();
          },
          label: l10n.commonLogout,
          icon: Icons.logout_rounded,
        ),
      ],
    );
  }

  Widget _buildThemeCard({
    required WidgetRef ref,
    required AppLocalizations l10n,
    required ThemeMode themeMode,
    required AppThemePreference selectedPreference,
  }) {
    return LumosCard(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(
              l10n.profileThemeSectionTitle,
              style: LumosTextStyle.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            LumosText(
              l10n.profileThemeSectionSubtitle,
              style: LumosTextStyle.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildThemePreferenceSelector(
              ref: ref,
              l10n: l10n,
              selectedPreference: selectedPreference,
            ),
            const SizedBox(height: AppSpacing.sm),
            _buildQuickToggleButton(ref: ref, l10n: l10n, themeMode: themeMode),
          ],
        ),
      ),
    );
  }

  Widget _buildThemePreferenceSelector({
    required WidgetRef ref,
    required AppLocalizations l10n,
    required AppThemePreference selectedPreference,
  }) {
    return LumosRadioGroup<AppThemePreference>(
      options: AppThemePreference.values,
      value: selectedPreference,
      onChanged: (AppThemePreference? value) {
        if (value == null) {
          return;
        }
        ref.read(appThemeModeProvider.notifier).setPreference(value);
      },
      labelBuilder: (AppThemePreference preference) {
        return _themeLabel(l10n: l10n, preference: preference);
      },
    );
  }

  Widget _buildQuickToggleButton({
    required WidgetRef ref,
    required AppLocalizations l10n,
    required ThemeMode themeMode,
  }) {
    return LumosOutlineButton(
      label: _quickToggleLabel(l10n: l10n, mode: themeMode),
      icon: Icons.brightness_6_outlined,
      expanded: true,
      onPressed: () {
        ref.read(appThemeModeProvider.notifier).toggleTheme();
      },
    );
  }

  AppThemePreference _toPreference({required ThemeMode mode}) {
    return switch (mode) {
      ThemeMode.light => AppThemePreference.light,
      ThemeMode.dark => AppThemePreference.dark,
      _ => AppThemePreference.system,
    };
  }

  String _themeLabel({
    required AppLocalizations l10n,
    required AppThemePreference preference,
  }) {
    return switch (preference) {
      AppThemePreference.system => l10n.profileThemeSystem,
      AppThemePreference.light => l10n.profileThemeLight,
      AppThemePreference.dark => l10n.profileThemeDark,
    };
  }

  String _quickToggleLabel({
    required AppLocalizations l10n,
    required ThemeMode mode,
  }) {
    return switch (mode) {
      ThemeMode.dark => l10n.profileThemeToggleToLight,
      _ => l10n.profileThemeToggleToDark,
    };
  }

  Widget _buildStudyCard({
    required WidgetRef ref,
    required AppLocalizations l10n,
    required AsyncValue<StudyPreference> studyAsync,
  }) {
    return LumosCard(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(
              l10n.profileStudySectionTitle,
              style: LumosTextStyle.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            LumosText(
              l10n.profileStudySectionSubtitle,
              style: LumosTextStyle.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            studyAsync.when(
              loading: () => const Center(child: LumosLoadingIndicator()),
              error: (Object error, StackTrace stackTrace) {
                return LumosText(
                  error.toString(),
                  style: LumosTextStyle.bodySmall,
                );
              },
              data: (StudyPreference preference) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    LumosDropdown<int>(
                      value: preference.firstLearningCardLimit,
                      label: l10n.profileStudyFirstLearningLimitLabel,
                      items: HomeProfileTabConst.firstLearningCardLimits
                          .map(
                            (int limit) => DropdownMenuItem<int>(
                              value: limit,
                              child: LumosText(
                                l10n.profileStudyFirstLearningLimitValue(limit),
                                style: LumosTextStyle.bodyMedium,
                              ),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (int? limit) {
                        if (limit == null) {
                          return;
                        }
                        ref
                            .read(studyPreferenceControllerProvider.notifier)
                            .savePreference(
                              preference.copyWith(
                                firstLearningCardLimit: limit,
                              ),
                            );
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    LumosText(
                      l10n.profileStudyReviewHint,
                      style: LumosTextStyle.bodySmall,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeechCard({
    required WidgetRef ref,
    required AppLocalizations l10n,
    required AsyncValue<SpeechPreference> speechAsync,
  }) {
    return speechAsync.when(
      loading: () => const LumosCard(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: LumosLoadingIndicator(),
        ),
      ),
      error: (Object error, StackTrace stackTrace) {
        return LumosCard(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: LumosText(error.toString(), style: LumosTextStyle.bodySmall),
          ),
        );
      },
      data: (SpeechPreference preference) {
        return LumosCard(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                LumosText(
                  l10n.profileSpeechSectionTitle,
                  style: LumosTextStyle.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: LumosText(
                    l10n.profileSpeechEnabledLabel,
                    style: LumosTextStyle.bodyMedium,
                  ),
                  value: preference.enabled,
                  onChanged: (bool enabled) {
                    ref
                        .read(speechPreferenceControllerProvider.notifier)
                        .savePreference(preference.copyWith(enabled: enabled));
                  },
                ),
                SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.zero,
                  title: LumosText(
                    l10n.profileSpeechAutoPlayLabel,
                    style: LumosTextStyle.bodyMedium,
                  ),
                  value: preference.autoPlay,
                  onChanged: (bool autoPlay) {
                    ref
                        .read(speechPreferenceControllerProvider.notifier)
                        .savePreference(
                          preference.copyWith(autoPlay: autoPlay),
                        );
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                LumosDropdown<String>(
                  value: preference.voice,
                  label: l10n.profileSpeechVoiceLabel,
                  items: HomeProfileTabConst.speechVoices
                      .map(
                        (String voice) => DropdownMenuItem<String>(
                          value: voice,
                          child: LumosText(
                            voice,
                            style: LumosTextStyle.bodyMedium,
                          ),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (String? voice) {
                    if (voice == null) {
                      return;
                    }
                    _saveSpeechPreference(
                      ref: ref,
                      preference: preference.copyWith(voice: voice),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                LumosDropdown<double>(
                  value: preference.speed,
                  label: l10n.profileSpeechSpeedLabel,
                  items: HomeProfileTabConst.speechSpeeds
                      .map(
                        (double speed) => DropdownMenuItem<double>(
                          value: speed,
                          child: LumosText(
                            '${speed.toStringAsFixed(1)}x',
                            style: LumosTextStyle.bodyMedium,
                          ),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (double? speed) {
                    if (speed == null) {
                      return;
                    }
                    _saveSpeechPreference(
                      ref: ref,
                      preference: preference.copyWith(speed: speed),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveSpeechPreference({
    required WidgetRef ref,
    required SpeechPreference preference,
  }) {
    ref
        .read(speechPreferenceControllerProvider.notifier)
        .savePreference(preference);
  }
}
