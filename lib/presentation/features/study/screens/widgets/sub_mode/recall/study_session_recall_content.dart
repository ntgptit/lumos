import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_recall_layout_resolver.dart';
import '../../../../mode/study_mode_action_view_model.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_speech_playback_provider.dart';
import 'widgets/study_session_recall_action_row.dart';
import 'widgets/study_session_recall_answer_panel.dart';
import 'widgets/study_session_recall_progress_row.dart';
import 'widgets/study_session_recall_prompt_card.dart';

const EdgeInsetsGeometry _recallContentPadding = EdgeInsets.fromLTRB(
  AppSpacing.lg,
  AppSpacing.md,
  AppSpacing.lg,
  AppSpacing.xl,
);
const EdgeInsetsGeometry _recallProgressPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.md,
);
const double _recallSectionSpacing = AppSpacing.lg;
const double _recallActionSpacing = AppSpacing.xl;

class StudySessionRecallContent extends StatelessWidget {
  const StudySessionRecallContent({
    required this.session,
    required this.viewModel,
    required this.speechPlaybackState,
    required this.onActionPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final StudySpeechPlaybackState speechPlaybackState;
  final Future<void> Function(String) onActionPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context) {
    final List<StudyModeActionViewModel> visibleActions =
        StudyRecallLayoutResolver.resolveVisibleActions(
      viewModel: viewModel,
    );
    return Padding(
      padding: _recallContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: _recallProgressPadding,
            child: StudySessionRecallProgressRow(
              progressValue: session.progress.sessionProgress,
            ),
          ),
          const SizedBox(height: _recallSectionSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: StudySessionRecallPromptCard(
                    prompt: StudyRecallLayoutResolver.resolvePromptContent(
                      session: session,
                      viewModel: viewModel,
                    ),
                    speech: session.currentItem.speech,
                    playbackState: speechPlaybackState,
                    onPlayPressed: speechPlaybackState.isPlaying
                        ? onReplaySpeech
                        : onPlaySpeech,
                  ),
                ),
                const SizedBox(height: _recallSectionSpacing),
                Expanded(
                  child: StudySessionRecallAnswerPanel(
                    content: StudyRecallLayoutResolver.resolveAnswerContent(
                      session: session,
                    ),
                    isRevealed: viewModel.showAnswer,
                  ),
                ),
                const SizedBox(height: _recallActionSpacing),
                StudySessionRecallActionRow(
                  actions: visibleActions,
                  onActionPressed: onActionPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
