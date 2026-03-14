import 'package:flutter/material.dart';

import '../../../../../../../core/themes/foundation/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_match_selection_provider.dart';
import '../widgets/study_session_progress_row.dart';
import 'widgets/study_session_match_pairs.dart';

const EdgeInsetsGeometry _matchContentPadding = EdgeInsets.fromLTRB(
  AppSpacing.lg,
  AppSpacing.md,
  AppSpacing.lg,
  AppSpacing.xl,
);
const EdgeInsetsGeometry _matchProgressPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.md,
);
const double _matchSectionSpacing = AppSpacing.lg;
const double _matchBottomSpacing = AppSpacing.xxl;

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
    final ScrollBehavior scrollBehavior = ScrollConfiguration.of(
      context,
    ).copyWith(scrollbars: false);
    return Padding(
      padding: _matchContentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: _matchProgressPadding,
            child: StudySessionProgressRow(
              progressValue: session.progress.sessionProgress,
            ),
          ),
          const SizedBox(height: _matchSectionSpacing),
          Expanded(
            child: ScrollConfiguration(
              behavior: scrollBehavior,
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
                  const SizedBox(height: _matchBottomSpacing),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
