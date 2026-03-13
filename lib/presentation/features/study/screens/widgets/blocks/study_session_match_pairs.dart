import 'package:flutter/material.dart';

import '../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../domain/entities/study/study_models.dart';
import '../../../../../shared/widgets/lumos_widgets.dart';

class StudySessionMatchPairs extends StatelessWidget {
  const StudySessionMatchPairs({
    required this.pairs,
    required this.matchedPairs,
    required this.selectedLeftId,
    required this.selectedRightId,
    required this.onSelectLeft,
    required this.onSelectRight,
    required this.onSubmit,
    required this.submitEnabled,
    super.key,
  });

  final List<StudyMatchPair> pairs;
  final List<StudyMatchSubmission> matchedPairs;
  final String? selectedLeftId;
  final String? selectedRightId;
  final ValueChanged<String> onSelectLeft;
  final ValueChanged<String> onSelectRight;
  final VoidCallback onSubmit;
  final bool submitEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(child: _buildColumn(isLeftColumn: true)),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _buildColumn(isLeftColumn: false)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        LumosPrimaryButton(
          onPressed: submitEnabled ? onSubmit : null,
          label: 'Kiểm tra',
          icon: Icons.check_rounded,
          expanded: true,
        ),
      ],
    );
  }

  Widget _buildColumn({required bool isLeftColumn}) {
    final Iterable<Widget> tiles = pairs.map((StudyMatchPair pair) {
      final String itemId = isLeftColumn ? pair.leftId : pair.rightId;
      final String label = isLeftColumn ? pair.leftLabel : pair.rightLabel;
      final bool isMatched = isLeftColumn
          ? matchedPairs.any(
              (StudyMatchSubmission item) => item.leftId == itemId,
            )
          : matchedPairs.any(
              (StudyMatchSubmission item) => item.rightId == itemId,
            );
      final bool isSelected = isLeftColumn
          ? selectedLeftId == itemId
          : selectedRightId == itemId;
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: _buildPairButton(
          label: label,
          isMatched: isMatched,
          isSelected: isSelected,
          onPressed: isLeftColumn
              ? () => onSelectLeft(itemId)
              : () => onSelectRight(itemId),
        ),
      );
    });
    return Column(children: tiles.toList(growable: false));
  }

  Widget _buildPairButton({
    required String label,
    required bool isMatched,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    if (isMatched) {
      return LumosSecondaryButton(
        onPressed: null,
        label: 'Đã ghép · $label',
        expanded: true,
      );
    }
    if (isSelected) {
      return LumosPrimaryButton(
        onPressed: onPressed,
        label: label,
        expanded: true,
      );
    }
    return LumosOutlineButton(
      onPressed: onPressed,
      label: label,
      expanded: true,
    );
  }
}
