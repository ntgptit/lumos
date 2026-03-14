import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../../../core/providers/theme_provider.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../../auth/providers/auth_session_provider.dart';
import '../../../../../../study/providers/speech_preference_provider.dart';
import '../../../../../../study/providers/study_preference_provider.dart';
import 'home_profile_support.dart';

class HomeProfileContent extends ConsumerWidget {
  const HomeProfileContent({
    required this.l10n,
    required this.themeMode,
    required this.selectedPreference,
    super.key,
  });

  final AppLocalizations l10n;
  final ThemeMode themeMode;
  final AppThemePreference selectedPreference;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<StudyPreference> studyAsync = ref.watch(
      studyPreferenceControllerProvider,
    );
    final AsyncValue<SpeechPreference> speechAsync = ref.watch(
      speechPreferenceControllerProvider,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        LumosCard(
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
                LumosRadioGroup<AppThemePreference>(
                  options: AppThemePreference.values,
                  value: selectedPreference,
                  onChanged: (AppThemePreference? value) {
                    if (value == null) {
                      return;
                    }
                    ref
                        .read(appThemeModeProvider.notifier)
                        .setPreference(value);
                  },
                  labelBuilder: (AppThemePreference preference) {
                    return homeThemeLabel(l10n: l10n, preference: preference);
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                LumosOutlineButton(
                  label: homeQuickToggleLabel(l10n: l10n, mode: themeMode),
                  icon: Icons.brightness_6_outlined,
                  expanded: true,
                  onPressed: () {
                    ref.read(appThemeModeProvider.notifier).toggleTheme();
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        LumosCard(
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
                          items: HomeProfileSupportConst.firstLearningCardLimits
                              .map(
                                (int limit) => DropdownMenuItem<int>(
                                  value: limit,
                                  child: LumosText(
                                    l10n.profileStudyFirstLearningLimitValue(
                                      limit,
                                    ),
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
                                .read(
                                  studyPreferenceControllerProvider.notifier,
                                )
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
        ),
        const SizedBox(height: AppSpacing.lg),
        speechAsync.when(
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
                child: LumosText(
                  error.toString(),
                  style: LumosTextStyle.bodySmall,
                ),
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
                            .savePreference(
                              preference.copyWith(enabled: enabled),
                            );
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
                      items: HomeProfileSupportConst.speechVoices
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
                        saveSpeechPreference(
                          ref: ref,
                          preference: preference.copyWith(voice: voice),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    LumosDropdown<double>(
                      value: preference.speed,
                      label: l10n.profileSpeechSpeedLabel,
                      items: HomeProfileSupportConst.speechSpeeds
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
                        saveSpeechPreference(
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
        ),
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
}
