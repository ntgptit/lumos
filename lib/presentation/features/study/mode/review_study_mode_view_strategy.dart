import 'abstract_study_mode_view_strategy.dart';

class ReviewStudyModeViewStrategy extends AbstractStudyModeViewStrategy {
  const ReviewStudyModeViewStrategy();

  @override
  String get supportedMode => 'REVIEW';

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
