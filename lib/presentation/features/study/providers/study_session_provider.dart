import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repositories/study/study_repository_impl.dart';
import '../../../../domain/entities/study/study_models.dart';
import '../../../../domain/repositories/study/study_repository.dart';

part 'study_session_provider.g.dart';

class StudySessionLaunchRequest {
  const StudySessionLaunchRequest({required this.deckId, this.sessionId});

  final int deckId;
  final int? sessionId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is StudySessionLaunchRequest &&
        other.deckId == deckId &&
        other.sessionId == sessionId;
  }

  @override
  int get hashCode => Object.hash(deckId, sessionId);
}

@Riverpod(keepAlive: true)
class StudySessionController extends _$StudySessionController {
  @override
  Future<StudySessionData> build(StudySessionLaunchRequest request) async {
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    final int? sessionId = request.sessionId;
    if (sessionId != null) {
      return repository.resumeSession(sessionId: sessionId);
    }
    return repository.startSession(deckId: request.deckId);
  }

  Future<void> submitAnswer(String answer) async {
    final StudySessionData current = state.asData!.value;
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    state = const AsyncLoading<StudySessionData>();
    state = await AsyncValue.guard<StudySessionData>(() {
      return repository.submitAnswer(
        sessionId: current.sessionId,
        answer: answer,
      );
    });
  }

  Future<void> submitMatchedPairs(
    List<StudyMatchSubmission> matchedPairs,
  ) async {
    final StudySessionData current = state.asData!.value;
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    state = const AsyncLoading<StudySessionData>();
    state = await AsyncValue.guard<StudySessionData>(() {
      return repository.submitMatchedPairs(
        sessionId: current.sessionId,
        matchedPairs: matchedPairs,
      );
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
