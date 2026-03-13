import 'abstract_study_mode_view_strategy.dart';

class FillStudyModeViewStrategy extends AbstractStudyModeViewStrategy {
  const FillStudyModeViewStrategy();

  @override
  String get supportedMode => 'FILL';

  @override
  List<String> resolveActionOrder() {
    return const <String>['REVEAL_ANSWER', 'GO_NEXT'];
  }

  @override
  String resolveRevealActionLabel() {
    return 'Trợ giúp';
  }

  @override
  String resolveSubmitLabel() {
    return 'Kiểm tra';
  }
}
