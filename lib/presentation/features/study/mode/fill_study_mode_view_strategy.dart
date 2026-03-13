import 'abstract_study_mode_view_strategy.dart';

class FillStudyModeViewStrategy extends AbstractStudyModeViewStrategy {
  const FillStudyModeViewStrategy();

  @override
  String get supportedMode => 'FILL';

  @override
  List<String> resolveActionOrder() {
    return const <String>[
      'REVEAL_ANSWER',
      'RETRY_ITEM',
      'GO_NEXT',
    ];
  }
}
