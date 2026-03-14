import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_fill_content_state.dart';
import '../../../../mode/study_mode_action_view_model.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_fill_selection_provider.dart';
import '../../../../providers/study_speech_playback_provider.dart';
import '../widgets/study_session_progress_row.dart';
import 'widgets/study_session_fill_action_row.dart';
import 'widgets/study_session_fill_body_panel.dart';
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
    required this.fillSelectionState,
    required this.answerController,
    required this.speechPlaybackState,
    required this.onSubmitTypedAnswer,
    required this.onActionPressed,
    required this.onInputChanged,
    required this.onRetryInputPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final StudyFillSelectionState fillSelectionState;
  final TextEditingController answerController;
  final StudySpeechPlaybackState speechPlaybackState;
  final VoidCallback onSubmitTypedAnswer;
  final Future<void> Function(String) onActionPressed;
  final ValueChanged<String> onInputChanged;
  final VoidCallback onRetryInputPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context) {
    final StudyFillContentState contentState = StudyFillContentState.resolve(
      viewModel: viewModel,
      fillSelectionState: fillSelectionState,
    );
    final StudyModeActionViewModel? secondaryAction =
        contentState.secondaryAction;
    return Padding(
      padding: _fillContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: _fillProgressPadding,
            child: StudySessionProgressRow(
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
                    fillSelectionState: fillSelectionState,
                    answerController: answerController,
                    showsAnswerPanel: contentState.showsAnswerPanel,
                    showsInputPanel: contentState.showsInputPanel,
                    onInputChanged: onInputChanged,
                    onSubmitTypedAnswer: onSubmitTypedAnswer,
                  ),
                ),
                if (contentState.showsBottomActions) ...<Widget>[
                  const SizedBox(height: _fillActionSpacing),
                  StudySessionFillActionRow(
                    actions: const <StudyModeActionViewModel>[],
                    secondaryLabel: secondaryAction?.label,
                    onSecondaryPressed: secondaryAction != null
                        ? () {
                            onActionPressed(secondaryAction.actionId);
                          }
                        : null,
                    primaryLabel: contentState.primaryLabel,
                    onPrimaryPressed: contentState.showsRetryAction
                        ? onRetryInputPressed
                        : contentState.showsInputPanel
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
