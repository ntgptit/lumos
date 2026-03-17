import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_fill_content_state.dart';
import '../../../../mode/study_mode_action_view_model.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_fill_selection_provider.dart';
import '../../../../providers/study_speech_playback_provider.dart';
import '../widgets/study_session_progress_row.dart';
import '../widgets/study_session_layout_metrics.dart';
import 'widgets/study_session_fill_action_row.dart';
import 'widgets/study_session_fill_body_panel.dart';
import 'widgets/study_session_fill_prompt_card.dart';

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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactHeight = constraints.maxHeight < 760;
        final EdgeInsets contentPadding =
            StudySessionLayoutMetrics.contentPadding(
              context,
              top: compactHeight ? AppSpacing.sm : AppSpacing.md,
              bottom: compactHeight ? AppSpacing.lg : AppSpacing.xl,
            );
        final EdgeInsets progressPadding =
            StudySessionLayoutMetrics.progressPadding(
              context,
              horizontal: compactHeight ? AppSpacing.sm : AppSpacing.md,
            );
        final double sectionSpacing = StudySessionLayoutMetrics.sectionSpacing(
          context,
          baseValue: compactHeight ? AppSpacing.md : _fillSectionSpacing,
        );
        final double actionSpacing = StudySessionLayoutMetrics.actionSpacing(
          context,
          baseValue: compactHeight ? AppSpacing.lg : _fillActionSpacing,
        );
        return Padding(
          padding: contentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: progressPadding,
                child: StudySessionProgressRow(
                  progressValue: session.progress.sessionProgress,
                ),
              ),
              SizedBox(height: sectionSpacing),
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
                    SizedBox(height: sectionSpacing),
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
                      SizedBox(height: actionSpacing),
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
      },
    );
  }
}
