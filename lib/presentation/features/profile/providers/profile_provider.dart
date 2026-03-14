import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repositories/profile/profile_repository_impl.dart';
import '../../../../domain/entities/profile/profile_models.dart';
import '../../../../domain/entities/study/study_models.dart';
import '../../../../domain/repositories/profile/profile_repository.dart';

part 'profile_provider.g.dart';

@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  @override
  Future<ProfileData> build() async {
    final ProfileRepository repository = ref.read(profileRepositoryProvider);
    return repository.getProfile();
  }

  Future<void> reload() async {
    final ProfileRepository repository = ref.read(profileRepositoryProvider);
    state = await AsyncValue.guard<ProfileData>(() {
      return repository.getProfile();
    });
  }

  Future<void> updateStudyPreference(StudyPreference preference) async {
    final ProfileRepository repository = ref.read(profileRepositoryProvider);
    final ProfileData current = state.requireValue;
    final StudyPreference updated = await repository.updateStudyPreference(
      preference: preference,
    );
    state = AsyncValue.data(current.copyWith(studyPreference: updated));
  }

  Future<void> updateSpeechPreference(SpeechPreference preference) async {
    final ProfileRepository repository = ref.read(profileRepositoryProvider);
    final ProfileData current = state.requireValue;
    final SpeechPreference updated = await repository.updateSpeechPreference(
      preference: preference,
    );
    state = AsyncValue.data(current.copyWith(speechPreference: updated));
  }
}
