import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/data/repositories/study/study_repository_impl.dart';
import 'package:lumos/presentation/features/study/providers/study_session_provider.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  group('StudySessionController', () {
    test('build starts session with deck id', () async {
      final FakeStudyRepository repository = FakeStudyRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          studyRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final session = await container.read(
        studySessionControllerProvider(10).future,
      );

      expect(repository.lastDeckId, 10);
      expect(session.sessionId, 33);
    });

    test('submitAnswer delegates to repository and updates state', () async {
      final FakeStudyRepository repository = FakeStudyRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          studyRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(studySessionControllerProvider(10).future);

      await container
          .read(studySessionControllerProvider(10).notifier)
          .submitAnswer('xin chao');

      final session = container.read(studySessionControllerProvider(10)).requireValue;
      expect(repository.lastAnswer, 'xin chao');
      expect(session.modeState, 'WAITING_FEEDBACK');
    });

    test('revealAnswer markRemembered retryItem and goNext update canonical state', () async {
      final FakeStudyRepository repository = FakeStudyRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [
          studyRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      await container.read(studySessionControllerProvider(10).future);

      await container.read(studySessionControllerProvider(10).notifier).revealAnswer();
      expect(
        container.read(studySessionControllerProvider(10)).requireValue.modeState,
        'WAITING_FEEDBACK',
      );

      await container.read(studySessionControllerProvider(10).notifier).markRemembered();
      expect(
        container.read(studySessionControllerProvider(10)).requireValue.allowedActions,
        contains('GO_NEXT'),
      );

      await container.read(studySessionControllerProvider(10).notifier).retryItem();
      expect(
        container.read(studySessionControllerProvider(10)).requireValue.modeState,
        'RETRY_PENDING',
      );

      await container.read(studySessionControllerProvider(10).notifier).goNext();
      expect(
        container.read(studySessionControllerProvider(10)).requireValue.activeMode,
        'MATCH',
      );
    });
  });
}
