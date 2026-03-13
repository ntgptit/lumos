import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_speech_playback_provider.dart';
import 'study_session_action_bar.dart';
import 'study_session_header.dart';
import 'study_session_prompt_card.dart';
import 'study_session_speech_panel.dart';

const String _answerInstruction = 'Đáp án';

class StudySessionSubModeScaffold extends StatelessWidget {
  const StudySessionSubModeScaffold({
    required this.session,
    required this.viewModel,
    required this.speechPlaybackState,
    required this.onActionPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    this.bodyChildren = const <Widget>[],
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final StudySpeechPlaybackState speechPlaybackState;
  final Future<void> Function(String) onActionPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;
  final List<Widget> bodyChildren;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        StudySessionHeader(
          sessionType: session.sessionType,
          modeLabel: viewModel.modeLabel,
          progressValue: session.progress.sessionProgress,
        ),
        const SizedBox(height: AppSpacing.lg),
        StudySessionSpeechPanel(
          speech: session.currentItem.speech,
          playbackState: speechPlaybackState,
          onPlayPressed: onPlaySpeech,
          onReplayPressed: onReplaySpeech,
        ),
        if (session.currentItem.speech.available)
          const SizedBox(height: AppSpacing.lg),
        StudySessionPromptCard(
          instruction: viewModel.instruction,
          prompt: viewModel.prompt,
          showAnswer: false,
          answer: '',
        ),
        if (viewModel.showAnswer) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          StudySessionPromptCard(
            instruction: _answerInstruction,
            prompt: viewModel.answer,
            showAnswer: false,
            answer: '',
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        ...bodyChildren,
        const SizedBox(height: AppSpacing.md),
        StudySessionActionBar(
          actions: viewModel.actions,
          onActionPressed: (String actionId) {
            onActionPressed(actionId);
          },
        ),
      ],
    );
  }
}
