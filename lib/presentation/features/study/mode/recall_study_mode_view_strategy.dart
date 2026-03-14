import 'package:flutter/material.dart';

import '../../../../domain/entities/study/study_models.dart';
import 'abstract_study_mode_view_strategy.dart';
import 'study_mode_action_button_style.dart';
import 'study_mode_action_view_model.dart';

class RecallStudyModeViewStrategy extends AbstractStudyModeViewStrategy {
  const RecallStudyModeViewStrategy();

  @override
  String get supportedMode => 'RECALL';

  @override
  List<String> resolveActionOrder() {
    return const <String>[
      'REVEAL_ANSWER',
      'MARK_REMEMBERED',
      'RETRY_ITEM',
      'GO_NEXT',
    ];
  }

  @override
  String resolveRevealActionLabel() {
    return 'Hiển thị';
  }

  @override
  String resolveRetryActionLabel() {
    return 'Đã quên';
  }

  @override
  StudyModeActionViewModel? resolveActionViewModel({
    required String actionId,
    required StudySessionData session,
  }) {
    if (actionId == 'GO_NEXT') {
      return StudyModeActionViewModel(
        actionId: actionId,
        label: session.sessionCompleted ? 'Hoàn tất' : 'Tiếp theo',
        style: StudyModeActionButtonStyle.primary,
        icon: Icons.navigate_next_rounded,
      );
    }
    return super.resolveActionViewModel(actionId: actionId, session: session);
  }
}
