import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../mode/fill_study_mode_view_strategy.dart';
import '../mode/guess_study_mode_view_strategy.dart';
import '../mode/match_study_mode_view_strategy.dart';
import '../mode/recall_study_mode_view_strategy.dart';
import '../mode/review_study_mode_view_strategy.dart';
import '../mode/study_mode_view_strategy.dart';
import '../mode/study_mode_view_strategy_factory.dart';

part 'study_mode_view_strategy_factory_provider.g.dart';

@Riverpod(keepAlive: true)
StudyModeViewStrategyFactory studyModeViewStrategyFactory(Ref ref) {
  return const StudyModeViewStrategyFactory(
    strategies: <StudyModeViewStrategy>[
      ReviewStudyModeViewStrategy(),
      MatchStudyModeViewStrategy(),
      GuessStudyModeViewStrategy(),
      RecallStudyModeViewStrategy(),
      FillStudyModeViewStrategy(),
    ],
  );
}
