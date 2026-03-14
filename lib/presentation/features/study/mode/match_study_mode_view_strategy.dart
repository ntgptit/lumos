import 'abstract_study_mode_view_strategy.dart';

class MatchStudyModeViewStrategy extends AbstractStudyModeViewStrategy {
  const MatchStudyModeViewStrategy();

  @override
  String get supportedMode => 'MATCH';

  @override
  List<String> resolveActionOrder() {
    return const <String>[];
  }

  @override
  bool usesChoiceGrid() {
    return true;
  }
}
