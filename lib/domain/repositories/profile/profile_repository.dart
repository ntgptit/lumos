import '../../entities/profile/profile_models.dart';
import '../../entities/study/study_models.dart';

abstract class ProfileRepository {
  Future<ProfileData> getProfile();

  Future<SpeechPreference> getSpeechPreference();

  Future<SpeechPreference> updateSpeechPreference({
    required SpeechPreference preference,
  });

  Future<StudyPreference> getStudyPreference();

  Future<StudyPreference> updateStudyPreference({
    required StudyPreference preference,
  });
}
