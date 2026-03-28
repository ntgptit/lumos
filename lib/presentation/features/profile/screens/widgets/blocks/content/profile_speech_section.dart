import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../domain/entities/study/study_speech_contract.dart';
import '../../../../../../../l10n/app_localizations.dart';
import 'package:lumos/presentation/shared/composites/appbars/lumos_app_bar.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_action_sheet.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_dialog.dart';
import 'package:lumos/presentation/shared/composites/dialogs/lumos_prompt_dialog.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_search_bar.dart';
import 'package:lumos/presentation/shared/composites/forms/lumos_sort_bar.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item.dart';
import 'package:lumos/presentation/shared/composites/lists/lumos_action_list_item_card.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_empty_state.dart';
import 'package:lumos/presentation/shared/composites/states/lumos_error_state.dart';
import 'package:lumos/presentation/shared/composites/text/lumos_inline_text.dart';
import 'package:lumos/presentation/shared/layouts/lumos_screen_transition.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_floating_action_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_icon_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_outline_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_primary_button.dart';
import 'package:lumos/presentation/shared/primitives/buttons/lumos_secondary_button.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_card.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_icon.dart';
import 'package:lumos/presentation/shared/primitives/displays/lumos_progress_bar.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_loading_indicator.dart';
import 'package:lumos/presentation/shared/primitives/feedback/lumos_snackbar.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_dropdown.dart';
import 'package:lumos/presentation/shared/primitives/inputs/lumos_text_field.dart';
import 'package:lumos/presentation/shared/primitives/layout/lumos_spacing.dart';
import 'package:lumos/presentation/shared/primitives/text/lumos_text.dart';
import 'profile_speech_preview_panel.dart';

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
    final double cardPadding = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double sectionGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.md,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    final double footerGap = ResponsiveDimensions.compactValue(
      context: context,
      baseValue: LumosSpacing.lg,
      minScale: ResponsiveDimensions.compactInsetScale,
    );
    return LumosCard(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            LumosText(
              l10n.profileSpeechSectionTitle,
              style: LumosTextStyle.titleLarge,
            ),
            const SizedBox(height: LumosSpacing.sm),
            LumosText(
              l10n.profileSpeechSectionSubtitle,
              style: LumosTextStyle.bodyMedium,
            ),
            const SizedBox(height: LumosSpacing.md),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: LumosText(
                l10n.profileSpeechEnabledLabel,
                style: LumosTextStyle.bodyMedium,
              ),
              value: preference.enabled,
              onChanged: onEnabledChanged,
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: LumosText(
                l10n.profileSpeechAutoPlayLabel,
                style: LumosTextStyle.bodyMedium,
              ),
              value: preference.autoPlay,
              onChanged: onAutoPlayChanged,
            ),
            SizedBox(height: sectionGap),
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
      ),
    );
  }
}

