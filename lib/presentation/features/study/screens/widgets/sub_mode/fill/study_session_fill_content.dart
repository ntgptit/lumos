import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_speech_playback_provider.dart';
import 'widgets/study_session_fill_action_row.dart';
import 'widgets/study_session_fill_body_panel.dart';
import 'widgets/study_session_fill_progress_row.dart';
import 'widgets/study_session_fill_prompt_card.dart';

const EdgeInsetsGeometry _fillContentPadding = EdgeInsets.fromLTRB(
  AppSpacing.lg,
  AppSpacing.md,
  AppSpacing.lg,
  AppSpacing.xl,
);
const EdgeInsetsGeometry _fillProgressPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.md,
);
const double _fillSectionSpacing = AppSpacing.lg;
const double _fillActionSpacing = AppSpacing.xl;

class StudySessionFillContent extends StatelessWidget {
  const StudySessionFillContent({
    required this.session,
    required this.viewModel,
    required this.answerController,
    required this.speechPlaybackState,
    required this.onSubmitTypedAnswer,
    required this.onActionPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final TextEditingController answerController;
  final StudySpeechPlaybackState speechPlaybackState;
  final VoidCallback onSubmitTypedAnswer;
  final Future<void> Function(String) onActionPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context) {
    final bool showsAnswerPanel = viewModel.showAnswer;
    final bool showsInputPanel = viewModel.showAnswerInput;
    final bool showsActionRow = viewModel.actions.isNotEmpty;
    final bool showsSubmitAction = showsInputPanel;
    final bool showsBottomActions = showsActionRow || showsSubmitAction;
    return Padding(
      padding: _fillContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: _fillProgressPadding,
            child: StudySessionFillProgressRow(
              progressValue: session.progress.sessionProgress,
            ),
          ),
          const SizedBox(height: _fillSectionSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: StudySessionFillPromptCard(
                    prompt: viewModel.prompt,
                    speech: session.currentItem.speech,
                    playbackState: speechPlaybackState,
                    onPlayPressed: speechPlaybackState.isPlaying
                        ? onReplaySpeech
                        : onPlaySpeech,
                  ),
                ),
                const SizedBox(height: _fillSectionSpacing),
                Expanded(
                  child: StudySessionFillBodyPanel(
                    viewModel: viewModel,
                    answerController: answerController,
                    showsAnswerPanel: showsAnswerPanel,
                    showsInputPanel: showsInputPanel,
                    onSubmitTypedAnswer: onSubmitTypedAnswer,
                  ),
                ),
                if (showsBottomActions) ...<Widget>[
                  const SizedBox(height: _fillActionSpacing),
                  StudySessionFillActionRow(
                    actions: viewModel.actions,
                    submitLabel: showsSubmitAction ? viewModel.submitLabel : null,
                    onSubmitPressed: showsSubmitAction
                        ? onSubmitTypedAnswer
                        : null,
                    onActionPressed: (String actionId) {
                      onActionPressed(actionId);
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
