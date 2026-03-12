import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repositories/study/study_repository_impl.dart';
import '../../../../domain/entities/study/study_models.dart';
import '../../../../domain/repositories/study/study_repository.dart';

part 'study_session_provider.g.dart';

@Riverpod(keepAlive: true)
class StudySessionController extends _$StudySessionController {
  @override
  Future<StudySessionData> build(int deckId) async {
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    return repository.startSession(deckId: deckId);
  }

  Future<void> submitAnswer(String answer) async {
    final StudySessionData current = state.asData!.value;
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    state = const AsyncLoading<StudySessionData>();
    state = await AsyncValue.guard<StudySessionData>(() {
      return repository.submitAnswer(sessionId: current.sessionId, answer: answer);
    });
  }

  Future<void> revealAnswer() async {
    final StudySessionData current = state.asData!.value;
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    state = const AsyncLoading<StudySessionData>();
    state = await AsyncValue.guard<StudySessionData>(() {
      return repository.revealAnswer(sessionId: current.sessionId);
    });
  }

  Future<void> markRemembered() async {
    final StudySessionData current = state.asData!.value;
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    state = const AsyncLoading<StudySessionData>();
    state = await AsyncValue.guard<StudySessionData>(() {
      return repository.markRemembered(sessionId: current.sessionId);
    });
  }

  Future<void> retryItem() async {
    final StudySessionData current = state.asData!.value;
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    state = const AsyncLoading<StudySessionData>();
    state = await AsyncValue.guard<StudySessionData>(() {
      return repository.retryItem(sessionId: current.sessionId);
    });
  }

  Future<void> goNext() async {
    final StudySessionData current = state.asData!.value;
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    state = const AsyncLoading<StudySessionData>();
    state = await AsyncValue.guard<StudySessionData>(() {
      return repository.goNext(sessionId: current.sessionId);
    });
  }
}
