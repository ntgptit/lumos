import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import 'study_session_match_pair_button.dart';

class StudySessionMatchPairColumn extends StatelessWidget {
  const StudySessionMatchPairColumn({
    required this.pairs,
    required this.matchedPairs,
    required this.selectedItemId,
    required this.isLeftColumn,
    required this.onSelectItem,
    super.key,
  });

  final List<StudyMatchPair> pairs;
  final List<StudyMatchSubmission> matchedPairs;
  final String? selectedItemId;
  final bool isLeftColumn;
  final ValueChanged<String> onSelectItem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: pairs
          .map((StudyMatchPair pair) {
            final String itemId = isLeftColumn ? pair.leftId : pair.rightId;
            final String label = isLeftColumn
                ? pair.leftLabel
                : pair.rightLabel;
            final bool isMatched = isLeftColumn
                ? matchedPairs.any(
                    (StudyMatchSubmission item) => item.leftId == itemId,
                  )
                : matchedPairs.any(
                    (StudyMatchSubmission item) => item.rightId == itemId,
                  );
            final bool isSelected = selectedItemId == itemId;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: StudySessionMatchPairButton(
                label: label,
                isMatched: isMatched,
                isSelected: isSelected,
                onPressed: () => onSelectItem(itemId),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
