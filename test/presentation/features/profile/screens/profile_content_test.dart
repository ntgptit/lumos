import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/core/theme/app_theme.dart';
import 'package:lumos/core/theme/responsive/screen_info.dart';
import 'package:lumos/data/repositories/profile/profile_repository_impl.dart';
import 'package:lumos/domain/entities/profile/profile_models.dart';
import 'package:lumos/domain/entities/study/study_models.dart';
import 'package:lumos/domain/repositories/profile/profile_repository.dart';
import 'package:lumos/l10n/app_localizations.dart';
import 'package:lumos/presentation/features/profile/screens/profile_content.dart';

import '../../../../testkit/feature_fixtures.dart';

void main() {
  group('ProfileContent', () {
    testWidgets('renders profile sections and preview controls', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildProfileContent(profileRepository: FakeProfileRepository()),
      );

      await tester.pumpAndSettle();

      expect(find.text('Speech preference'), findsOneWidget);
      expect(find.text('Voice preview'), findsOneWidget);
      expect(find.text('Play preview'), findsOneWidget);
      expect(find.text('Stop'), findsOneWidget);
      expect(
        find.text(
          '안녕하세요. 이 문장은 현재 음성과 속도, 음높이를 테스트하기 위한 예시입니다.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows error view when profile loading fails', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _buildProfileContent(
          profileRepository: const _ThrowingProfileRepository(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('load failed'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}

Widget _buildProfileContent({required ProfileRepository profileRepository}) {
  const Size size = Size(390, 844);
  return ProviderScope(
    overrides: [
      profileRepositoryProvider.overrideWithValue(profileRepository),
    ],
    child: MaterialApp(
      theme: AppTheme.light(screenInfo: ScreenInfo.fromSize(size)),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(body: ProfileContent()),
    ),
  );
}

class _ThrowingProfileRepository implements ProfileRepository {
  const _ThrowingProfileRepository();

  @override
  Future<ProfileData> getProfile() {
    throw StateError('load failed');
  }

  @override
  Future<SpeechPreference> getSpeechPreference() {
    throw StateError('load failed');
  }

  @override
  Future<StudyPreference> getStudyPreference() {
    throw StateError('load failed');
  }

  @override
  Future<SpeechPreference> updateSpeechPreference({
    required SpeechPreference preference,
  }) {
    throw StateError('load failed');
  }

  @override
  Future<StudyPreference> updateStudyPreference({
    required StudyPreference preference,
  }) {
    throw StateError('load failed');
  }
}
