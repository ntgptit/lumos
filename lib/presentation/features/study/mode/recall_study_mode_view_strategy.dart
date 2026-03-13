import 'abstract_study_mode_view_strategy.dart';

class RecallStudyModeViewStrategy extends AbstractStudyModeViewStrategy {
  const RecallStudyModeViewStrategy();

  @override
  String get supportedMode => 'RECALL';

  @override
  List<String> resolveActionOrder() {
    return const <String>[
      'REVEAL_ANSWER',
      'MARK_REMEMBERED',
      'RETRY_ITEM',
      'GO_NEXT',
    ];
  }
}
