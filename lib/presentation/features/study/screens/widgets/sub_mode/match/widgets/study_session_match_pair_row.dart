import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import 'study_session_match_pair_button.dart';

class StudySessionMatchPairRow extends StatelessWidget {
  const StudySessionMatchPairRow({
    required this.leftPair,
    required this.rightPair,
    required this.matchedPairs,
    required this.selectedLeftId,
    required this.selectedRightId,
    required this.onSelectLeft,
    required this.onSelectRight,
    super.key,
  });

  final StudyMatchPair leftPair;
  final StudyMatchPair rightPair;
  final List<StudyMatchSubmission> matchedPairs;
  final String? selectedLeftId;
  final String? selectedRightId;
  final ValueChanged<String> onSelectLeft;
  final ValueChanged<String> onSelectRight;

  @override
  Widget build(BuildContext context) {
    final bool isLeftMatched = matchedPairs.any(
      (StudyMatchSubmission pair) => pair.leftId == leftPair.leftId,
    );
    final bool isRightMatched = matchedPairs.any(
      (StudyMatchSubmission pair) => pair.rightId == rightPair.rightId,
    );
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: StudySessionMatchPairButton(
              label: leftPair.leftLabel,
              isMatched: isLeftMatched,
              isSelected: selectedLeftId == leftPair.leftId,
              isMeaningCard: true,
              onPressed: () => onSelectLeft(leftPair.leftId),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: StudySessionMatchPairButton(
              label: rightPair.rightLabel,
              isMatched: isRightMatched,
              isSelected: selectedRightId == rightPair.rightId,
              isMeaningCard: false,
              onPressed: () => onSelectRight(rightPair.rightId),
            ),
          ),
        ],
      ),
    );
  }
}
