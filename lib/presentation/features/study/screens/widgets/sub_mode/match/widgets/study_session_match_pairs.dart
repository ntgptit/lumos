import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../mode/study_match_pair_layout_resolver.dart';
import 'study_session_match_pair_row.dart';

class StudySessionMatchPairs extends StatelessWidget {
  const StudySessionMatchPairs({
    required this.pairs,
    required this.matchedPairs,
    required this.selectedLeftId,
    required this.selectedRightId,
    required this.onSelectLeft,
    required this.onSelectRight,
    required this.shuffleSeed,
    super.key,
  });

  final List<StudyMatchPair> pairs;
  final List<StudyMatchSubmission> matchedPairs;
  final String? selectedLeftId;
  final String? selectedRightId;
  final ValueChanged<String> onSelectLeft;
  final ValueChanged<String> onSelectRight;
  final int shuffleSeed;

  @override
  Widget build(BuildContext context) {
    final Set<String> matchedLeftIds = matchedPairs
        .map((StudyMatchSubmission pair) => pair.leftId)
        .toSet();
    final Set<String> matchedRightIds = matchedPairs
        .map((StudyMatchSubmission pair) => pair.rightId)
        .toSet();
    final List<StudyMatchPair> rightColumnPairs =
        StudyMatchPairLayoutResolver.resolveRightColumnPairs(
          pairs: pairs,
          shuffleSeed: shuffleSeed,
        );
    final List<StudyMatchPair> visibleLeftPairs = pairs
        .where((StudyMatchPair pair) => !matchedLeftIds.contains(pair.leftId))
        .toList(growable: false);
    final List<StudyMatchPair> visibleRightPairs = rightColumnPairs
        .where((StudyMatchPair pair) => !matchedRightIds.contains(pair.rightId))
        .toList(growable: false);
    final int rowCount = visibleLeftPairs.length < visibleRightPairs.length
        ? visibleLeftPairs.length
        : visibleRightPairs.length;
    if (rowCount == 0) {
      return const SizedBox.shrink();
    }
    return Column(
      children: List<Widget>.generate(rowCount, (int index) {
        final Widget row = StudySessionMatchPairRow(
          leftPair: visibleLeftPairs[index],
          rightPair: visibleRightPairs[index],
          matchedPairs: matchedPairs,
          selectedLeftId: selectedLeftId,
          selectedRightId: selectedRightId,
          onSelectLeft: onSelectLeft,
          onSelectRight: onSelectRight,
        );
        if (index == rowCount - 1) {
          return row;
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: row,
        );
      }),
    );
  }
}
