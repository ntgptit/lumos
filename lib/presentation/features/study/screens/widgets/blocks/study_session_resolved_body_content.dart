import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../domain/entities/study/study_models.dart';
import '../../../mode/study_mode_view_model.dart';
import '../../../mode/study_mode_view_strategy.dart';
import '../../../mode/study_mode_view_strategy_factory.dart';
import '../../../providers/study_match_selection_provider.dart';
import '../../../providers/study_speech_playback_provider.dart';
import '../sub_mode/study_session_mode_content.dart';

class StudySessionResolvedBodyContent extends ConsumerWidget {
  const StudySessionResolvedBodyContent({
    required this.session,
    required this.modeStrategyFactory,
    required this.answerController,
    required this.onSubmitTypedAnswer,
    required this.onSubmitMatchedPairs,
    required this.onChoicePressed,
    required this.onSelectMatchLeft,
    required this.onSelectMatchRight,
    required this.onActionPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewStrategyFactory modeStrategyFactory;
  final TextEditingController answerController;
  final VoidCallback onSubmitTypedAnswer;
  final VoidCallback onSubmitMatchedPairs;
  final ValueChanged<String> onChoicePressed;
  final ValueChanged<String> onSelectMatchLeft;
  final ValueChanged<String> onSelectMatchRight;
  final Future<void> Function(String) onActionPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final StudyModeViewModel viewModel = _buildModeViewModel(session);
    final StudyMatchSelectionState matchSelectionState = ref.watch(
      studyMatchSelectionControllerProvider(session.sessionId),
    );
    final StudySpeechPlaybackState speechPlaybackState = ref.watch(
      studySpeechPlaybackControllerProvider(session.sessionId),
    );
    return StudySessionModeContent(
      session: session,
      viewModel: viewModel,
      answerController: answerController,
      matchSelectionState: matchSelectionState,
      speechPlaybackState: speechPlaybackState,
      onSubmitTypedAnswer: onSubmitTypedAnswer,
      onSubmitMatchedPairs: onSubmitMatchedPairs,
      onChoicePressed: onChoicePressed,
      onSelectMatchLeft: onSelectMatchLeft,
      onSelectMatchRight: onSelectMatchRight,
      onActionPressed: onActionPressed,
      onPlaySpeech: onPlaySpeech,
      onReplaySpeech: onReplaySpeech,
    );
  }

  StudyModeViewModel _buildModeViewModel(StudySessionData currentSession) {
    final StudyModeViewStrategy modeStrategy = modeStrategyFactory.resolve(
      currentSession.activeMode,
    );
    return modeStrategy.buildViewModel(session: currentSession);
  }
}
