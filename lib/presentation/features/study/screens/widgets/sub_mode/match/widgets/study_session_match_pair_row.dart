import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../providers/study_match_selection_provider.dart';
import 'study_session_match_pair_button.dart';

class StudySessionMatchPairRow extends StatelessWidget {
  const StudySessionMatchPairRow({
    required this.leftPair,
    required this.rightPair,
    required this.selectionState,
    required this.onSelectLeft,
    required this.onSelectRight,
    super.key,
  });

  final StudyMatchPair leftPair;
  final StudyMatchPair rightPair;
  final StudyMatchSelectionState selectionState;
  final ValueChanged<String> onSelectLeft;
  final ValueChanged<String> onSelectRight;

  @override
  Widget build(BuildContext context) {
    final bool isLeftMatched = selectionState.isLeftMatched(leftPair.leftId);
    final bool isRightMatched = selectionState.isRightMatched(rightPair.rightId);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: StudySessionMatchPairButton(
              label: leftPair.leftLabel,
              isMatched: isLeftMatched,
              isSelected: selectionState.selectedLeftId == leftPair.leftId,
              isSuccessFeedback: selectionState.isSuccessFeedbackForLeft(
                leftPair.leftId,
              ),
              isErrorFeedback: selectionState.isErrorFeedbackForLeft(
                leftPair.leftId,
              ),
              isDisappearing: selectionState.isLeftDisappearing(
                leftPair.leftId,
              ),
              isMeaningCard: true,
              isInteractionLocked: selectionState.isInteractionLocked,
              onPressed: () => onSelectLeft(leftPair.leftId),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: StudySessionMatchPairButton(
              label: rightPair.rightLabel,
              isMatched: isRightMatched,
              isSelected: selectionState.selectedRightId == rightPair.rightId,
              isSuccessFeedback: selectionState.isSuccessFeedbackForRight(
                rightPair.rightId,
              ),
              isErrorFeedback: selectionState.isErrorFeedbackForRight(
                rightPair.rightId,
              ),
              isDisappearing: selectionState.isRightDisappearing(
                rightPair.rightId,
              ),
              isMeaningCard: false,
              isInteractionLocked: selectionState.isInteractionLocked,
              onPressed: () => onSelectRight(rightPair.rightId),
            ),
          ),
        ],
      ),
    );
  }
}
