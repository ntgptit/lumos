import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../../../shared/widgets/lumos_widgets.dart';

abstract final class ProfileSpeechSectionConst {
  ProfileSpeechSectionConst._();

  static const List<String> speechVoices = <String>[
    'ko-KR-neutral',
    'ko-KR-female',
    'ko-KR-male',
  ];
  static const List<double> speechSpeeds = <double>[0.8, 1.0, 1.2, 1.5];
}

class ProfileSpeechSection extends StatelessWidget {
  const ProfileSpeechSection({
    required this.preference,
    required this.onEnabledChanged,
    required this.onAutoPlayChanged,
    required this.onVoiceChanged,
    required this.onSpeedChanged,
    super.key,
  });

  final SpeechPreference preference;
  final ValueChanged<bool> onEnabledChanged;
  final ValueChanged<bool> onAutoPlayChanged;
  final ValueChanged<String> onVoiceChanged;
  final ValueChanged<double> onSpeedChanged;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
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
            const SizedBox(height: AppSpacing.sm),
            LumosDropdown<String>(
              value: preference.voice,
              label: l10n.profileSpeechVoiceLabel,
              items: ProfileSpeechSectionConst.speechVoices
                  .map(
                    (String voice) => DropdownMenuItem<String>(
                      value: voice,
                      child: LumosText(voice, style: LumosTextStyle.bodyMedium),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (String? voice) {
                if (voice == null) {
                  return;
                }
                onVoiceChanged(voice);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            LumosDropdown<double>(
              value: preference.speed,
              label: l10n.profileSpeechSpeedLabel,
              items: ProfileSpeechSectionConst.speechSpeeds
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
          ],
        ),
      ),
    );
  }
}
