import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';
import '../../../providers/study_speech_playback_provider.dart';

class StudySessionSpeechPanel extends StatelessWidget {
  const StudySessionSpeechPanel({
    required this.speech,
    required this.playbackState,
    required this.onPlayPressed,
    required this.onReplayPressed,
    super.key,
  });

  final SpeechCapability speech;
  final StudySpeechPlaybackState playbackState;
  final VoidCallback onPlayPressed;
  final VoidCallback onReplayPressed;

  @override
  Widget build(BuildContext context) {
    if (!speech.available) {
      return const SizedBox.shrink();
    }
    final bool canPlay = speech.allowedActions.contains(
      StudySpeechPlaybackConst.playSpeechAction,
    );
    final bool canReplay = speech.allowedActions.contains(
      StudySpeechPlaybackConst.replaySpeechAction,
    );
    return LumosCard(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            LumosText(
              'Text to speech · ${speech.locale}',
              style: LumosTextStyle.labelLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            LumosText(
              'Voice: ${speech.voice} · Speed: ${speech.speed.toStringAsFixed(1)}x',
              style: LumosTextStyle.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: <Widget>[
                LumosPrimaryButton(
                  onPressed: playbackState.isBusy || !canPlay
                      ? null
                      : onPlayPressed,
                  label: playbackState.isPlaying ? 'Đang phát' : 'Nghe',
                  icon: Icons.volume_up_rounded,
                ),
                LumosOutlineButton(
                  onPressed: playbackState.isBusy || !canReplay
                      ? null
                      : onReplayPressed,
                  label: 'Phát lại',
                  icon: Icons.replay_rounded,
                ),
              ],
            ),
            if (playbackState.errorMessage
                case final String errorMessage) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              LumosText(errorMessage, style: LumosTextStyle.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
