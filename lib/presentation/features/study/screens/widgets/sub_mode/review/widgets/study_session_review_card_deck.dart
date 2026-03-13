import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/extensions/theme_extensions.dart';
import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import '../../../../../providers/study_speech_playback_provider.dart';
import 'study_session_review_card.dart';

class StudySessionReviewCardDeck extends StatelessWidget {
  const StudySessionReviewCardDeck({
    required this.session,
    required this.speechPlaybackState,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudySpeechPlaybackState speechPlaybackState;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: StudySessionReviewCard(
            content: _buildPromptContent(session.currentItem),
            textStyle: context.textTheme.headlineSmall,
            trailing: const LumosIcon(Icons.edit_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: StudySessionReviewCard(
            content: _buildAnswerContent(session.currentItem),
            textStyle: context.textTheme.headlineMedium,
            trailing: LumosIconButton(
              icon: speechPlaybackState.isPlaying
                  ? Icons.volume_off_rounded
                  : Icons.volume_up_rounded,
              tooltip: speechPlaybackState.isPlaying
                  ? l10n.studySpeechReplayAction
                  : l10n.flashcardPlayAudioTooltip,
              onPressed: session.currentItem.speech.available
                  ? _handleSpeechPressed
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  void _handleSpeechPressed() {
    if (speechPlaybackState.isPlaying) {
      onReplaySpeech();
      return;
    }
    onPlaySpeech();
  }

  String _buildPromptContent(StudySessionItemData currentItem) {
    if (currentItem.note.isEmpty) {
      return currentItem.prompt;
    }
    if (currentItem.prompt.isEmpty) {
      return currentItem.note;
    }
    return '${currentItem.prompt} / ${currentItem.note}';
  }

  String _buildAnswerContent(StudySessionItemData currentItem) {
    if (currentItem.answer.isNotEmpty) {
      return currentItem.answer;
    }
    return currentItem.pronunciation;
  }
}
