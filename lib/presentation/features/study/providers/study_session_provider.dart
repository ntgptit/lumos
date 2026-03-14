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

  Future<StudySessionData> submitAnswer(String answer) async {
    return _runSessionMutation((
      StudyRepository repository,
      StudySessionData current,
    ) {
      return repository.submitAnswer(
        sessionId: current.sessionId,
        answer: answer,
      );
    });
  }

  Future<StudySessionData> submitMatchedPairs(
    List<StudyMatchSubmission> matchedPairs,
  ) async {
    return _runSessionMutation((
      StudyRepository repository,
      StudySessionData current,
    ) {
      return repository.submitMatchedPairs(
        sessionId: current.sessionId,
        matchedPairs: matchedPairs,
      );
    });
  }

  Future<StudySessionData> revealAnswer() async {
    return _runSessionMutation((
      StudyRepository repository,
      StudySessionData current,
    ) {
      return repository.revealAnswer(sessionId: current.sessionId);
    });
  }

  Future<StudySessionData> markRemembered() async {
    return _runSessionMutation((
      StudyRepository repository,
      StudySessionData current,
    ) {
      return repository.markRemembered(sessionId: current.sessionId);
    });
  }

  Future<StudySessionData> retryItem() async {
    return _runSessionMutation((
      StudyRepository repository,
      StudySessionData current,
    ) {
      return repository.retryItem(sessionId: current.sessionId);
    });
  }

  Future<StudySessionData> goNext() async {
    return _runSessionMutation((
      StudyRepository repository,
      StudySessionData current,
    ) {
      return repository.goNext(sessionId: current.sessionId);
    });
  }

  Future<StudySessionData> resetCurrentMode() async {
    return _runSessionMutation((
      StudyRepository repository,
      StudySessionData current,
    ) {
      return repository.resetCurrentMode(sessionId: current.sessionId);
    });
  }

  Future<StudySessionData> _runSessionMutation(
    Future<StudySessionData> Function(
      StudyRepository repository,
      StudySessionData current,
    )
    mutation,
  ) async {
    final AsyncValue<StudySessionData> previousState = state;
    final StudySessionData current = previousState.requireValue;
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    state = const AsyncLoading<StudySessionData>();
    final AsyncValue<StudySessionData> nextState =
        await AsyncValue.guard<StudySessionData>(() {
          return mutation(repository, current);
        });
    state = nextState;
    return nextState.requireValue;
  }
}
