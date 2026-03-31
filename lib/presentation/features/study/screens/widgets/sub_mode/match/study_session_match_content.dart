import 'package:flutter/material.dart';

import 'package:lumos/core/theme/app_foundation.dart';
import '../../../../../../../domain/entities/study/study_models.dart';
import '../../../../mode/study_mode_view_model.dart';
import '../../../../providers/study_match_selection_provider.dart';
import '../widgets/study_session_layout_metrics.dart';
import '../widgets/study_session_progress_row.dart';
import 'widgets/study_session_match_pairs.dart';

const double _matchSectionSpacing =
    24;
const double _matchBottomSpacing =
    48;

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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool compactHeight =
            constraints.maxHeight < StudySessionLayoutMetrics.compactBodyHeightBreakpoint;
        final EdgeInsets
        contentPadding = StudySessionLayoutMetrics.contentPadding(
          context,
          top: compactHeight
              ? context.spacing.sm
              : context.spacing.md,
          bottom: compactHeight
              ? context.spacing.lg
              : context.spacing.xl,
        );
        final EdgeInsets
        progressPadding = StudySessionLayoutMetrics.progressPadding(
          context,
          horizontal: compactHeight
              ? context.spacing.sm
              : context.spacing.md,
        );
        final double sectionSpacing = StudySessionLayoutMetrics.sectionSpacing(
          context,
          baseValue: compactHeight
              ? context.spacing.md
              : _matchSectionSpacing,
        );
        final double bottomSpacing = StudySessionLayoutMetrics.actionSpacing(
          context,
          baseValue: compactHeight
              ? context.spacing.lg
              : _matchBottomSpacing,
        );
        return Padding(
          padding: contentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: progressPadding,
                child: StudySessionProgressRow(
                  progressValue: session.progress.sessionProgress,
                ),
              ),
              SizedBox(height: sectionSpacing),
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
                      SizedBox(height: bottomSpacing),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
