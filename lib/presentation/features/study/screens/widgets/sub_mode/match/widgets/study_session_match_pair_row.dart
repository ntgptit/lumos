import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../providers/study_match_selection_provider.dart';
import 'study_session_match_pair_button.dart';

const double _matchColumnGap = AppSpacing.md;
const double _matchCardMinHeight = 204;
const double _matchCardMaxHeight = 276;
const double _matchCardHeightFactor = 0.72;

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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double columnWidth =
            (constraints.maxWidth - _matchColumnGap) / 2;
        final double resolvedRowHeight = math.min(
          _matchCardMaxHeight,
          math.max(_matchCardMinHeight, columnWidth * _matchCardHeightFactor),
        );
        return SizedBox(
          height: resolvedRowHeight,
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
              const SizedBox(width: _matchColumnGap),
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
      },
    );
  }
}
