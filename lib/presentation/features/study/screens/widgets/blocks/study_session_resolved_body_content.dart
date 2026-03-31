import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../mode/study_mode_view_model.dart';
import '../../../mode/study_mode_view_strategy.dart';
import '../../../mode/study_mode_view_strategy_factory.dart';
import '../../../providers/study_fill_selection_provider.dart';
import '../../../providers/study_guess_selection_provider.dart';
import '../../../providers/study_match_selection_provider.dart';
import '../../../providers/study_recall_selection_provider.dart';
import '../../../providers/study_speech_playback_provider.dart';
import '../sub_mode/study_session_mode_content.dart';

class StudySessionResolvedBodyContent extends ConsumerWidget {
  const StudySessionResolvedBodyContent({
    required this.session,
    required this.modeStrategyFactory,
    required this.answerController,
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
  final StudyModeViewStrategyFactory modeStrategyFactory;
  final TextEditingController answerController;
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
  Widget build(BuildContext context, WidgetRef ref) {
    final StudyModeViewModel viewModel = _buildModeViewModel(session);
    final StudyFillSelectionState fillSelectionState = ref.watch(
      studyFillSelectionControllerProvider(session.sessionId),
    );
    final StudyGuessSelectionState guessSelectionState = ref.watch(
      studyGuessSelectionControllerProvider(session.sessionId),
    );
    final StudyMatchSelectionState matchSelectionState = ref.watch(
      studyMatchSelectionControllerProvider(session.sessionId),
    );
    final StudyRecallSelectionState recallSelectionState = ref.watch(
      studyRecallSelectionControllerProvider(session.sessionId),
    );
    final StudySpeechPlaybackState speechPlaybackState = ref.watch(
      studySpeechPlaybackControllerProvider(session.sessionId),
    );
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxWidth = constraints.isDesktop
            ? context.component.loadingStateMaxWidth
            : constraints.maxWidth;
        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: StudySessionModeContent(
              session: session,
              viewModel: viewModel,
              answerController: answerController,
              fillSelectionState: fillSelectionState,
              guessSelectionState: guessSelectionState,
              matchSelectionState: matchSelectionState,
              recallSelectionState: recallSelectionState,
              speechPlaybackState: speechPlaybackState,
              onSubmitTypedAnswer: onSubmitTypedAnswer,
              onChoicePressed: onChoicePressed,
              onSelectMatchLeft: onSelectMatchLeft,
              onSelectMatchRight: onSelectMatchRight,
              onActionPressed: onActionPressed,
              onFillInputChanged: onFillInputChanged,
              onRetryInputPressed: onRetryInputPressed,
              onPlaySpeech: onPlaySpeech,
              onReplaySpeech: onReplaySpeech,
            ),
          ),
        );
      },
    );
  }

  StudyModeViewModel _buildModeViewModel(StudySessionData currentSession) {
    final StudyModeViewStrategy modeStrategy = modeStrategyFactory.resolve(
      currentSession.activeMode,
    );
    return modeStrategy.buildViewModel(session: currentSession);
  }
}
