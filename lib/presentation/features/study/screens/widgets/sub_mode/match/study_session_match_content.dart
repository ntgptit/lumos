import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_match_selection_provider.dart';
import 'widgets/study_session_match_pairs.dart';
import 'widgets/study_session_match_progress_row.dart';

const EdgeInsetsGeometry _matchContentPadding = EdgeInsets.fromLTRB(
  AppSpacing.lg,
  AppSpacing.lg,
  AppSpacing.lg,
  AppSpacing.xl,
);
const EdgeInsetsGeometry _matchProgressPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.lg,
);

class StudySessionMatchContent extends StatelessWidget {
  const StudySessionMatchContent({
    required this.session,
    required this.viewModel,
    required this.matchSelectionState,
    required this.onSelectMatchLeft,
    required this.onSelectMatchRight,
    super.key,
  });

  final StudySessionData session;
  final StudyModeViewModel viewModel;
  final StudyMatchSelectionState matchSelectionState;
  final ValueChanged<String> onSelectMatchLeft;
  final ValueChanged<String> onSelectMatchRight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _matchContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: _matchProgressPadding,
            child: StudySessionMatchProgressRow(
              progressValue: session.progress.sessionProgress,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                StudySessionMatchPairs(
                  pairs: viewModel.matchPairs,
                  selectionState: matchSelectionState,
                  onSelectLeft: onSelectMatchLeft,
                  onSelectRight: onSelectMatchRight,
                  shuffleSeed: session.currentItem.flashcardId,
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
