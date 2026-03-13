import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumos/data/repositories/study/study_repository_impl.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/presentation/features/study/providers/study_session_provider.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  group('StudySessionController', () {
    test('build starts session with deck id', () async {
      final FakeStudyRepository repository = FakeStudyRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [studyRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      final session = await container.read(
        studySessionControllerProvider(
          const StudySessionLaunchRequest(deckId: 10),
        ).future,
      );

      expect(repository.lastDeckId, 10);
      expect(session.sessionId, 33);
    });

    test('submitAnswer delegates to repository and updates state', () async {
      final FakeStudyRepository repository = FakeStudyRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [studyRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(
        studySessionControllerProvider(
          const StudySessionLaunchRequest(deckId: 10),
        ).future,
      );

      await container
          .read(
            studySessionControllerProvider(
              const StudySessionLaunchRequest(deckId: 10),
            ).notifier,
          )
          .submitAnswer('xin chao');

      final session = container
          .read(
            studySessionControllerProvider(
              const StudySessionLaunchRequest(deckId: 10),
            ),
          )
          .requireValue;
      expect(repository.lastAnswer, 'xin chao');
      expect(session.modeState, 'WAITING_FEEDBACK');
    });

    test(
      'revealAnswer markRemembered retryItem and goNext update canonical state',
      () async {
        final FakeStudyRepository repository = FakeStudyRepository();
        final ProviderContainer container = ProviderContainer(
          overrides: [studyRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);
        await container.read(
          studySessionControllerProvider(
            const StudySessionLaunchRequest(deckId: 10),
          ).future,
        );

        await container
            .read(
              studySessionControllerProvider(
                const StudySessionLaunchRequest(deckId: 10),
              ).notifier,
            )
            .revealAnswer();
        expect(
          container
              .read(
                studySessionControllerProvider(
                  const StudySessionLaunchRequest(deckId: 10),
                ),
              )
              .requireValue
              .modeState,
          'WAITING_FEEDBACK',
        );

        await container
            .read(
              studySessionControllerProvider(
                const StudySessionLaunchRequest(deckId: 10),
              ).notifier,
            )
            .markRemembered();
        expect(
          container
              .read(
                studySessionControllerProvider(
                  const StudySessionLaunchRequest(deckId: 10),
                ),
              )
              .requireValue
              .allowedActions,
          contains('GO_NEXT'),
        );

        await container
            .read(
              studySessionControllerProvider(
                const StudySessionLaunchRequest(deckId: 10),
              ).notifier,
            )
            .retryItem();
        expect(
          container
              .read(
                studySessionControllerProvider(
                  const StudySessionLaunchRequest(deckId: 10),
                ),
              )
              .requireValue
              .modeState,
          'WAITING_FEEDBACK',
        );

        await container
            .read(
              studySessionControllerProvider(
                const StudySessionLaunchRequest(deckId: 10),
              ).notifier,
            )
            .goNext();
        expect(
          container
              .read(
                studySessionControllerProvider(
                  const StudySessionLaunchRequest(deckId: 10),
                ),
              )
              .requireValue
              .activeMode,
          'MATCH',
        );
      },
    );

    test(
      'resetCurrentMode delegates to repository and resets canonical state',
      () async {
        final FakeStudyRepository repository = FakeStudyRepository();
        final ProviderContainer container = ProviderContainer(
          overrides: [studyRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);
        await container.read(
          studySessionControllerProvider(
            const StudySessionLaunchRequest(deckId: 10),
          ).future,
        );

        await container
            .read(
              studySessionControllerProvider(
                const StudySessionLaunchRequest(deckId: 10),
              ).notifier,
            )
            .resetCurrentMode();

        final StudySessionData session = container
            .read(
              studySessionControllerProvider(
                const StudySessionLaunchRequest(deckId: 10),
              ),
            )
            .requireValue;
        expect(repository.resetCurrentModeCallCount, 1);
        expect(session.modeState, 'INITIALIZED');
        expect(session.allowedActions, contains('RESET_CURRENT_MODE'));
      },
    );

    test('build resumes session when session id is provided', () async {
      final FakeStudyRepository repository = FakeStudyRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [studyRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container.read(
        studySessionControllerProvider(
          const StudySessionLaunchRequest(deckId: 10, sessionId: 33),
        ).future,
      );

      expect(repository.lastSessionId, 33);
    });
  });
}
