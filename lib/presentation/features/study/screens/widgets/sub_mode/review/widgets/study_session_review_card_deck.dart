import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../providers/study_speech_playback_provider.dart';
import 'study_session_review_answer_card.dart';
import 'study_session_review_prompt_card.dart';

const double _reviewCardSpacing = AppSpacing.lg;

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
          child: StudySessionReviewPromptCard(
            content: _buildPromptContent(session.currentItem),
          ),
        ),
        const SizedBox(height: _reviewCardSpacing),
        Expanded(
          child: StudySessionReviewAnswerCard(
            content: _buildAnswerContent(session.currentItem),
            isSpeechAvailable: session.currentItem.speech.available,
            isPlaying: speechPlaybackState.isPlaying,
            tooltip: speechPlaybackState.isPlaying
                ? l10n.studySpeechReplayAction
                : l10n.flashcardPlayAudioTooltip,
            onSpeechPressed: _handleSpeechPressed,
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
      return currentItem.answer;
    }
    if (currentItem.answer.isEmpty) {
      return currentItem.note;
    }
    return '${currentItem.answer} / ${currentItem.note}';
  }

  String _buildAnswerContent(StudySessionItemData currentItem) {
    if (currentItem.prompt.isEmpty) {
      return currentItem.pronunciation;
    }
    return currentItem.prompt;
  }
}
