import 'package:flutter/material.dart';

import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_match_selection_provider.dart';
import '../../../../providers/study_speech_playback_provider.dart';
import '../widgets/study_session_sub_mode_scaffold.dart';
import 'widgets/study_session_match_pairs.dart';

class StudySessionMatchContent extends StatelessWidget {
  const StudySessionMatchContent({
    required this.session,
    required this.viewModel,
    required this.matchSelectionState,
    required this.speechPlaybackState,
    required this.onSubmitMatchedPairs,
    required this.onSelectMatchLeft,
    required this.onSelectMatchRight,
    required this.onActionPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final StudyMatchSelectionState matchSelectionState;
  final StudySpeechPlaybackState speechPlaybackState;
  final VoidCallback onSubmitMatchedPairs;
  final ValueChanged<String> onSelectMatchLeft;
  final ValueChanged<String> onSelectMatchRight;
  final Future<void> Function(String) onActionPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context) {
    final List<Widget> bodyChildren = <Widget>[];
    if (viewModel.matchPairs.isNotEmpty) {
      bodyChildren.add(
        StudySessionMatchPairs(
          pairs: viewModel.matchPairs,
          matchedPairs: matchSelectionState.matchedPairs,
          selectedLeftId: matchSelectionState.selectedLeftId,
          selectedRightId: matchSelectionState.selectedRightId,
          onSelectLeft: onSelectMatchLeft,
          onSelectRight: onSelectMatchRight,
          onSubmit: onSubmitMatchedPairs,
          submitEnabled: matchSelectionState.canSubmit,
        ),
      );
    }
    return StudySessionSubModeScaffold(
      session: session,
      viewModel: viewModel,
      speechPlaybackState: speechPlaybackState,
      onActionPressed: onActionPressed,
      onPlaySpeech: onPlaySpeech,
      onReplaySpeech: onReplaySpeech,
      bodyChildren: bodyChildren,
    );
  }
}
