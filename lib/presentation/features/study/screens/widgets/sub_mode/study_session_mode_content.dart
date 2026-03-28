import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../mode/study_mode_view_model.dart';
import '../../../providers/study_fill_selection_provider.dart';
import '../../../providers/study_guess_selection_provider.dart';
import '../../../providers/study_match_selection_provider.dart';
import '../../../providers/study_recall_selection_provider.dart';
import '../../../providers/study_speech_playback_provider.dart';
import 'fill/study_session_fill_content.dart';
import 'guess/study_session_guess_content.dart';
import 'match/study_session_match_content.dart';
import 'recall/study_session_recall_content.dart';
import 'review/study_session_review_content.dart';
import 'study_session_sub_mode_const.dart';

class StudySessionModeContent extends StatelessWidget {
  const StudySessionModeContent({
    required this.session,
    required this.viewModel,
    required this.answerController,
    required this.fillSelectionState,
    required this.guessSelectionState,
    required this.matchSelectionState,
    required this.recallSelectionState,
    required this.speechPlaybackState,
    required this.onSubmitTypedAnswer,
    required this.onChoicePressed,
    required this.onSelectMatchLeft,
    required this.onSelectMatchRight,
    required this.onActionPressed,
    required this.onFillInputChanged,
    required this.onRetryInputPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final TextEditingController answerController;
  final StudyFillSelectionState fillSelectionState;
  final StudyGuessSelectionState guessSelectionState;
  final StudyMatchSelectionState matchSelectionState;
  final StudyRecallSelectionState recallSelectionState;
  final StudySpeechPlaybackState speechPlaybackState;
  final VoidCallback onSubmitTypedAnswer;
  final ValueChanged<String> onChoicePressed;
  final ValueChanged<String> onSelectMatchLeft;
  final ValueChanged<String> onSelectMatchRight;
  final Future<void> Function(String) onActionPressed;
  final ValueChanged<String> onFillInputChanged;
  final VoidCallback onRetryInputPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context) {
    final Widget content = switch (session.activeMode) {
      StudySessionSubModeConst.reviewMode => StudySessionReviewContent(
        session: session,
        speechPlaybackState: speechPlaybackState,
        onActionPressed: onActionPressed,
        onPlaySpeech: onPlaySpeech,
        onReplaySpeech: onReplaySpeech,
      ),
      StudySessionSubModeConst.fillMode => StudySessionFillContent(
        session: session,
        viewModel: viewModel,
        fillSelectionState: fillSelectionState,
        answerController: answerController,
        speechPlaybackState: speechPlaybackState,
        onSubmitTypedAnswer: onSubmitTypedAnswer,
        onActionPressed: onActionPressed,
        onInputChanged: onFillInputChanged,
        onRetryInputPressed: onRetryInputPressed,
        onPlaySpeech: onPlaySpeech,
        onReplaySpeech: onReplaySpeech,
      ),
      StudySessionSubModeConst.guessMode => StudySessionGuessContent(
        session: session,
        viewModel: viewModel,
        guessSelectionState: guessSelectionState,
        speechPlaybackState: speechPlaybackState,
        onChoicePressed: onChoicePressed,
        onActionPressed: onActionPressed,
        onPlaySpeech: onPlaySpeech,
        onReplaySpeech: onReplaySpeech,
      ),
      StudySessionSubModeConst.matchMode => StudySessionMatchContent(
        session: session,
        viewModel: viewModel,
        matchSelectionState: matchSelectionState,
        onSelectMatchLeft: onSelectMatchLeft,
        onSelectMatchRight: onSelectMatchRight,
      ),
      StudySessionSubModeConst.recallMode => StudySessionRecallContent(
        session: session,
        viewModel: viewModel,
        recallSelectionState: recallSelectionState,
        speechPlaybackState: speechPlaybackState,
        onActionPressed: onActionPressed,
        onPlaySpeech: onPlaySpeech,
        onReplaySpeech: onReplaySpeech,
      ),
      _ => const SizedBox.shrink(),
    };
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double horizontalInset = constraints.isDesktop
            ? LumosSpacing.sm
            : constraints.isTablet
            ? LumosSpacing.xs
            : LumosSpacing.none;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalInset),
          child: content,
        );
      },
    );
  }
}

