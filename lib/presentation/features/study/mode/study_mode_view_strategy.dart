import '../../../../domain/entities/study/study_models.dart';
import 'study_mode_view_model.dart';

abstract class StudyModeViewStrategy {
  const StudyModeViewStrategy();

  String get supportedMode;

  StudyModeViewModel buildViewModel({required StudySessionData session});
}
