import 'study_mode_view_strategy.dart';

class StudyModeViewStrategyFactory {
  const StudyModeViewStrategyFactory({
    required List<StudyModeViewStrategy> strategies,
  }) : _strategies = strategies;

  final List<StudyModeViewStrategy> _strategies;

  StudyModeViewStrategy resolve(String mode) {
    for (final StudyModeViewStrategy strategy in _strategies) {
      if (strategy.supportedMode != mode) {
        continue;
      }
      return strategy;
    }
    throw StateError('Missing StudyModeViewStrategy for mode: $mode');
  }
}
