import 'package:flutter/foundation.dart';

import '../auth/auth_models.dart';
import '../study/study_models.dart';

@immutable
class ProfileData {
  const ProfileData({
    required this.user,
    required this.studyPreference,
    required this.speechPreference,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      user: AuthUser.fromJson(
        (json['user'] as Map?)?.cast<String, dynamic>() ?? <String, dynamic>{},
      ),
      studyPreference: StudyPreference.fromJson(
        (json['studyPreference'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
      speechPreference: SpeechPreference.fromJson(
        (json['speechPreference'] as Map?)?.cast<String, dynamic>() ??
            <String, dynamic>{},
      ),
    );
  }

  final AuthUser user;
  final StudyPreference studyPreference;
  final SpeechPreference speechPreference;

  ProfileData copyWith({
    AuthUser? user,
    StudyPreference? studyPreference,
    SpeechPreference? speechPreference,
  }) {
    return ProfileData(
      user: user ?? this.user,
      studyPreference: studyPreference ?? this.studyPreference,
      speechPreference: speechPreference ?? this.speechPreference,
    );
  }
}
