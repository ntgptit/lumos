import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repositories/study/study_repository_impl.dart';
import '../../../../domain/entities/study/study_models.dart';
import '../../../../domain/repositories/study/study_repository.dart';

part 'study_preference_provider.g.dart';

@Riverpod(keepAlive: true)
class StudyPreferenceController extends _$StudyPreferenceController {
  @override
  Future<StudyPreference> build() async {
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    return repository.getStudyPreference();
  }

  Future<void> savePreference(StudyPreference preference) async {
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    state = const AsyncLoading<StudyPreference>();
    state = await AsyncValue.guard<StudyPreference>(() {
      return repository.updateStudyPreference(preference: preference);
    });
  }
}
