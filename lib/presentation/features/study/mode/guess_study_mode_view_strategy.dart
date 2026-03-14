import 'abstract_study_mode_view_strategy.dart';

class GuessStudyModeViewStrategy extends AbstractStudyModeViewStrategy {
  const GuessStudyModeViewStrategy();

  @override
  String get supportedMode => 'GUESS';

  @override
  List<String> resolveActionOrder() {
    return const <String>[];
  }
}
