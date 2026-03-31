import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../domain/entities/study/study_speech_contract.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'profile_speech_preview_panel.dart';
import 'profile_section_card.dart';
import 'profile_speech_toggle_tile.dart';

class ProfileSpeechSection extends StatelessWidget {
  const ProfileSpeechSection({
    required this.preference,
    required this.onEnabledChanged,
    required this.onAutoPlayChanged,
    required this.onAdapterChanged,
    required this.voiceOptions,
    required this.selectedVoiceId,
    required this.onVoiceChanged,
    required this.onSpeedChanged,
    required this.onPitchChanged,
    super.key,
  });

  final SpeechPreference preference;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<bool> onAutoPlayChanged;
  final ValueChanged<String> onAdapterChanged;
  final List<TtsVoiceOption> voiceOptions;
  final String selectedVoiceId;
  final ValueChanged<String> onVoiceChanged;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<double> onPitchChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final String resolvedAdapter = normalizeTtsAdapter(preference.adapter);
    final double resolvedSpeed = normalizeTtsSpeed(preference.speed);
    final double resolvedPitch = normalizeTtsPitch(preference.pitch);
    final double sectionGap = context.compactValue(
      baseValue: context.spacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double footerGap = context.compactValue(
      baseValue: context.spacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return ProfileSectionCard(
      title: l10n.profileSpeechSectionTitle,
      subtitle: l10n.profileSpeechSectionSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ProfileSpeechToggleTile(
            label: l10n.profileSpeechEnabledLabel,
            value: preference.enabled,
            onChanged: onEnabledChanged,
          ),
          SizedBox(height: sectionGap),
          ProfileSpeechToggleTile(
            label: l10n.profileSpeechAutoPlayLabel,
            value: preference.autoPlay,
            onChanged: onAutoPlayChanged,
          ),
          SizedBox(height: footerGap),
          LumosDropdown<String>(
            value: resolvedAdapter,
            label: l10n.profileSpeechAdapterLabel,
            items: supportedTtsAdapters
                .map((String adapter) {
                  final String adapterLabel =
                      adapter == studySpeechAdapterFlutterTts
                      ? l10n.profileSpeechAdapterFlutterTtsLabel
                      : adapter;
                  return DropdownMenuItem<String>(
                    value: adapter,
                    child: LumosText(
                      adapterLabel,
                      style: LumosTextStyle.bodyMedium,
                    ),
                  );
                })
                .toList(growable: false),
            onChanged: (String? adapter) {
              if (adapter == null) {
                return;
              }
              onAdapterChanged(adapter);
            },
          ),
          SizedBox(height: sectionGap),
          LumosDropdown<String>(
            value: selectedVoiceId,
            label: l10n.profileSpeechVoiceLabel,
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem<String>(
                value: studySpeechVoiceUnspecified,
                child: LumosText(
                  l10n.profileSpeechVoiceDefaultLabel,
                  style: LumosTextStyle.bodyMedium,
                ),
              ),
              ...voiceOptions.map(
                (TtsVoiceOption voice) => DropdownMenuItem<String>(
                  value: voice.id,
                  child: LumosText(
                    voice.label,
                    style: LumosTextStyle.bodyMedium,
                  ),
                ),
              ),
            ],
            onChanged: (String? voice) {
              if (voice == null) {
                return;
              }
              onVoiceChanged(voice);
            },
          ),
          SizedBox(height: sectionGap),
          LumosDropdown<double>(
            value: resolvedSpeed,
            label: l10n.profileSpeechSpeedLabel,
            items: supportedTtsSpeeds
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
              onSpeedChanged(speed);
            },
          ),
          SizedBox(height: sectionGap),
          LumosDropdown<double>(
            value: resolvedPitch,
            label: l10n.profileSpeechPitchLabel,
            items: supportedTtsPitches
                .map(
                  (double pitch) => DropdownMenuItem<double>(
                    value: pitch,
                    child: LumosText(
                      '${pitch.toStringAsFixed(1)}x',
                      style: LumosTextStyle.bodyMedium,
                    ),
                  ),
                )
                .toList(growable: false),
            onChanged: (double? pitch) {
              if (pitch == null) {
                return;
              }
              onPitchChanged(pitch);
            },
          ),
          SizedBox(height: footerGap),
          ProfileSpeechPreviewPanel(preference: preference),
        ],
      ),
    );
  }
}
