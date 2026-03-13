import 'package:flutter/material.dart';

import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_speech_playback_provider.dart';
import '../widgets/study_session_answer_input.dart';
import '../widgets/study_session_sub_mode_scaffold.dart';

class StudySessionRecallContent extends StatelessWidget {
  const StudySessionRecallContent({
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
    final List<Widget> bodyChildren = <Widget>[];
    if (viewModel.showAnswerInput) {
      bodyChildren.add(
        StudySessionAnswerInput(
          controller: answerController,
          label: viewModel.inputLabel,
          submitLabel: viewModel.submitLabel,
          onSubmit: onSubmitTypedAnswer,
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
