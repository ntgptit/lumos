import 'package:flutter/material.dart';

import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_speech_playback_provider.dart';
import '../widgets/study_session_choice_list.dart';
import '../widgets/study_session_sub_mode_scaffold.dart';

class StudySessionGuessContent extends StatelessWidget {
  const StudySessionGuessContent({
    required this.session,
    required this.viewModel,
    required this.speechPlaybackState,
    required this.onChoicePressed,
    required this.onActionPressed,
    required this.onPlaySpeech,
    required this.onReplaySpeech,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final StudySpeechPlaybackState speechPlaybackState;
  final ValueChanged<String> onChoicePressed;
  final Future<void> Function(String) onActionPressed;
  final VoidCallback onPlaySpeech;
  final VoidCallback onReplaySpeech;

  @override
  Widget build(BuildContext context) {
    final List<Widget> bodyChildren = <Widget>[];
    if (viewModel.choices.isNotEmpty) {
      bodyChildren.add(
        StudySessionChoiceList(
          choices: viewModel.choices,
          useGrid: viewModel.useChoiceGrid,
          onChoicePressed: onChoicePressed,
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
