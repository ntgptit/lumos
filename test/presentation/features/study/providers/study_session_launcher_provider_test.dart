import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/data/repositories/study/study_repository_impl.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/presentation/features/study/providers/study_session_launcher_provider.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  group('StudySessionLauncher', () {
    test(
      'startSession delegates preferred session type to repository',
      () async {
        final FakeStudyRepository repository = FakeStudyRepository();
        final ProviderContainer container = ProviderContainer(
          overrides: [studyRepositoryProvider.overrideWithValue(repository)],
        );
        addTearDown(container.dispose);

        final StudySessionData session = await container
            .read(studySessionLauncherProvider.notifier)
            .startSession(
              deckId: 10,
              preferredSessionType: StudySessionTypeOption.review,
            );

        expect(session.sessionId, 33);
        expect(repository.lastDeckId, 10);
        expect(
          repository.lastPreferredSessionType,
          StudySessionTypeOption.review,
        );
      },
    );

    test('resetDeckProgress delegates to repository', () async {
      final FakeStudyRepository repository = FakeStudyRepository();
      final ProviderContainer container = ProviderContainer(
        overrides: [studyRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);

      await container
          .read(studySessionLauncherProvider.notifier)
          .resetDeckProgress(deckId: 10);

      expect(repository.lastDeckId, 10);
      expect(repository.resetDeckProgressCallCount, 1);
    });
  });
}
