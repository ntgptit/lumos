import '../../../../domain/entities/study/study_models.dart';
import 'abstract_study_mode_view_strategy.dart';

class ReviewStudyModeViewStrategy extends AbstractStudyModeViewStrategy {
  const ReviewStudyModeViewStrategy();

  @override
  String get supportedMode => 'REVIEW';

  @override
  List<String> resolveActionOrder() {
    return const <String>['MARK_REMEMBERED', 'RETRY_ITEM', 'GO_NEXT'];
  }

  @override
  bool shouldShowAnswer({required StudySessionData session}) {
    return true;
  }

  @override
  String resolveRetryActionLabel() {
    return 'Need review';
  }
}
