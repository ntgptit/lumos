import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/speech/providers/tts_voice_options_provider.dart';
import '../../../../core/speech/tts_voice_option.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/themes/foundation/app_foundation.dart';
import '../../../../domain/entities/profile/profile_models.dart';
import '../../../../domain/entities/study/study_speech_contract.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../shared/widgets/lumos_widgets.dart';
import '../../auth/providers/auth_session_provider.dart';
import '../providers/profile_provider.dart';
import 'widgets/blocks/content/profile_account_card.dart';
import 'widgets/blocks/content/profile_speech_section.dart';
import 'widgets/blocks/content/profile_study_section.dart';
import 'widgets/blocks/content/profile_theme_section.dart';
import 'widgets/blocks/footer/profile_logout_button.dart';
import 'widgets/states/profile_error_view.dart';

abstract final class ProfileContentConst {
  ProfileContentConst._();

  static const double maxWidth = 560;
}

class ProfileContent extends ConsumerWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final double screenPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.lg,
      minScale: ResponsiveDimensions.compactOuterInsetScale,
    );
    final double sectionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: AppSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final AsyncValue<ProfileData> profileAsync = ref.watch(
      profileControllerProvider,
    );
    final ThemeMode themeMode = ref.watch(appThemeModeProvider);
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ProfileContentConst.maxWidth,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(screenPadding),
            child: profileAsync.when(
              loading: () => const Center(child: LumosLoadingIndicator()),
              error: (Object error, StackTrace stackTrace) {
                return ProfileErrorView(
                  message: error.toString(),
                  onRetry: () {
                    unawaited(
                      ref.read(profileControllerProvider.notifier).reload(),
                    );
                  },
                );
              },
              data: (ProfileData profile) {
                final AsyncValue<List<TtsVoiceOption>> voiceOptionsAsync = ref
                    .watch(
                      ttsVoiceOptionsProvider(
                        profile.speechPreference.adapter,
                        profile.speechPreference.locale,
                      ),
                    );
                final List<TtsVoiceOption> voiceOptions =
                    voiceOptionsAsync.asData?.value ?? const <TtsVoiceOption>[];
                String selectedVoiceId = studySpeechVoiceUnspecified;
                for (final TtsVoiceOption option in voiceOptions) {
                  if (option.id != profile.speechPreference.voice) {
                    continue;
                  }
                  selectedVoiceId = option.id;
                  break;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ProfileAccountCard(user: profile.user),
                    SizedBox(height: sectionGap),
                    ProfileThemeSection(
                      themeMode: themeMode,
                      onPreferenceChanged: (AppThemePreference preference) {
                        unawaited(
                          ref
                              .read(appThemeModeProvider.notifier)
                              .setPreference(preference),
                        );
                      },
                      onQuickTogglePressed: () {
                        unawaited(
                          ref.read(appThemeModeProvider.notifier).toggleTheme(),
                        );
                      },
                    ),
                    SizedBox(height: sectionGap),
                    ProfileStudySection(
                      preference: profile.studyPreference,
                      onLimitChanged: (int limit) {
                        unawaited(
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateStudyPreference(
                                profile.studyPreference.copyWith(
                                  firstLearningCardLimit: limit,
                                ),
                              ),
                        );
                      },
                    ),
                    SizedBox(height: sectionGap),
                    ProfileSpeechSection(
                      preference: profile.speechPreference,
                      onEnabledChanged: (bool enabled) {
                        unawaited(
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateSpeechPreference(
                                profile.speechPreference.copyWith(
                                  enabled: enabled,
                                ),
                              ),
                        );
                      },
                      onAutoPlayChanged: (bool autoPlay) {
                        unawaited(
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateSpeechPreference(
                                profile.speechPreference.copyWith(
                                  autoPlay: autoPlay,
                                ),
                              ),
                        );
                      },
                      onAdapterChanged: (String adapter) {
                        unawaited(
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateSpeechPreference(
                                profile.speechPreference.copyWith(
                                  adapter: adapter,
                                  voice: studySpeechVoiceUnspecified,
                                ),
                              ),
                        );
                      },
                      voiceOptions: voiceOptions,
                      selectedVoiceId: selectedVoiceId,
                      onVoiceChanged: (String voice) {
                        unawaited(
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateSpeechPreference(
                                profile.speechPreference.copyWith(voice: voice),
                              ),
                        );
                      },
                      onSpeedChanged: (double speed) {
                        unawaited(
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateSpeechPreference(
                                profile.speechPreference.copyWith(speed: speed),
                              ),
                        );
                      },
                      onPitchChanged: (double pitch) {
                        unawaited(
                          ref
                              .read(profileControllerProvider.notifier)
                              .updateSpeechPreference(
                                profile.speechPreference.copyWith(pitch: pitch),
                              ),
                        );
                      },
                    ),
                    SizedBox(height: sectionGap),
                    ProfileLogoutButton(
                      label: l10n.commonLogout,
                      onPressed: () {
                        unawaited(
                          ref
                              .read(authSessionControllerProvider.notifier)
                              .logout(),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
