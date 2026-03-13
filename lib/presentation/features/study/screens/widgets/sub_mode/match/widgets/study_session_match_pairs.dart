import 'package:flutter/material.dart';

import '../../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../../domain/entities/study/study_models.dart';
import '../../../../../../../../l10n/app_localizations.dart';
import '../../../../../../../shared/widgets/lumos_widgets.dart';
import 'study_session_match_pair_column.dart';

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
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: StudySessionMatchPairColumn(
                pairs: pairs,
                matchedPairs: matchedPairs,
                selectedItemId: selectedLeftId,
                isLeftColumn: true,
                onSelectItem: onSelectLeft,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: StudySessionMatchPairColumn(
                pairs: pairs,
                matchedPairs: matchedPairs,
                selectedItemId: selectedRightId,
                isLeftColumn: false,
                onSelectItem: onSelectRight,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        LumosPrimaryButton(
          onPressed: submitEnabled ? onSubmit : null,
          label: l10n.studyMatchCheckAction,
          icon: Icons.check_rounded,
          expanded: true,
        ),
      ],
    );
  }
}
