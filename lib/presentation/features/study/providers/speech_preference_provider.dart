import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repositories/study/study_repository_impl.dart';
import '../../../../domain/entities/study/study_models.dart';
import '../../../../domain/repositories/study/study_repository.dart';

part 'speech_preference_provider.g.dart';

@Riverpod(keepAlive: true)
class SpeechPreferenceController extends _$SpeechPreferenceController {
  @override
  Future<SpeechPreference> build() async {
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    return repository.getSpeechPreference();
  }

  Future<void> savePreference(SpeechPreference preference) async {
    final StudyRepository repository = ref.read(studyRepositoryProvider);
    state = const AsyncLoading<SpeechPreference>();
    state = await AsyncValue.guard<SpeechPreference>(() {
      return repository.updateSpeechPreference(preference: preference);
    });
  }
}
