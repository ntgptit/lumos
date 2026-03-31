import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../l10n/app_localizations.dart';
import '../../../../mode/study_recall_layout_resolver.dart';
import '../../../../mode/study_mode_action_button_style.dart';
import '../../../../mode/study_mode_action_view_model.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_recall_selection_provider.dart';
import '../../../../providers/study_speech_playback_provider.dart';
import '../widgets/study_session_layout_metrics.dart';
import '../widgets/study_session_progress_row.dart';
import 'widgets/study_session_recall_action_row.dart';
import 'widgets/study_session_recall_answer_panel.dart';
import 'widgets/study_session_recall_prompt_card.dart';

const double _recallSectionSpacing =
    24;
const double _recallActionSpacing =
    32;

class StudySessionRecallContent extends StatelessWidget {
  const StudySessionRecallContent({
    required this.session,
    required this.viewModel,
    required this.recallSelectionState,
    required this.speechPlaybackState,
    required this.onActionPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final StudyRecallSelectionState recallSelectionState;
  final StudySpeechPlaybackState speechPlaybackState;
  final Future<void> Function(String) onActionPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<StudyModeActionViewModel> visibleActions =
        StudyRecallLayoutResolver.resolveVisibleActions(
          viewModel: viewModel,
          showsNextActionOnly: recallSelectionState.showsNextActionOnly,
          fallbackNextAction: StudyModeActionViewModel(
            actionId: 'GO_NEXT',
            label: l10n.commonNext,
            style: StudyModeActionButtonStyle.primary,
            icon: Icons.navigate_next_rounded,
          ),
        );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactHeight =
            constraints.maxHeight < StudySessionLayoutMetrics.compactBodyHeightBreakpoint;
        final EdgeInsets
        contentPadding = StudySessionLayoutMetrics.contentPadding(
          context,
          top: compactHeight
              ? context.spacing.sm
              : context.spacing.md,
          bottom: compactHeight
              ? context.spacing.lg
              : context.spacing.xl,
        );
        final EdgeInsets
        progressPadding = StudySessionLayoutMetrics.progressPadding(
          context,
          horizontal: compactHeight
              ? context.spacing.sm
              : context.spacing.md,
        );
        final double sectionSpacing = StudySessionLayoutMetrics.sectionSpacing(
          context,
          baseValue: compactHeight
              ? context.spacing.md
              : _recallSectionSpacing,
        );
        final double actionSpacing = StudySessionLayoutMetrics.actionSpacing(
          context,
          baseValue: compactHeight
              ? context.spacing.lg
              : _recallActionSpacing,
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
                    SizedBox(height: sectionSpacing),
                    Expanded(
                      child: StudySessionRecallAnswerPanel(
                        content: StudyRecallLayoutResolver.resolveAnswerContent(
                          session: session,
                        ),
                        isRevealed: viewModel.showAnswer,
                      ),
                    ),
                    SizedBox(height: actionSpacing),
                    StudySessionRecallActionRow(
                      actions: visibleActions,
                      selectionState: recallSelectionState,
                      onActionPressed: onActionPressed,
                    ),
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
