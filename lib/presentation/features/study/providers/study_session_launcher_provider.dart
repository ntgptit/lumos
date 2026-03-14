import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repositories/study/study_repository_impl.dart';
import '../../../../domain/entities/study/study_models.dart';
import '../../../../domain/repositories/study/study_repository.dart';

part 'study_session_launcher_provider.g.dart';

@Riverpod(keepAlive: true)
class StudySessionLauncher extends _$StudySessionLauncher {
  @override
  void build() {}

  Future<StudySessionData> startSession({
    required int deckId,
    StudySessionTypeOption? preferredSessionType,
  }) {
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    return repository.startSession(
      deckId: deckId,
      preferredSessionType: preferredSessionType,
    );
  }

  Future<void> resetDeckProgress({required int deckId}) {
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    return repository.resetDeckProgress(deckId: deckId);
  }
}
