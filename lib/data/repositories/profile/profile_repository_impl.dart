import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/network/providers/network_providers.dart';
import '../../../domain/entities/profile/profile_models.dart';
import '../../../domain/entities/study/study_models.dart';
import '../../../domain/repositories/profile/profile_repository.dart';

part 'profile_repository_impl.g.dart';

abstract final class ProfileRepositoryImplConst {
  ProfileRepositoryImplConst._();

  static const String profilePath = '/api/v1/profile';
  static const String speechPreferencePath = '$profilePath/speech-preference';
  static const String studyPreferencePath = '$profilePath/study-preference';
}

class DioProfileRepository implements ProfileRepository {
  const DioProfileRepository({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<ProfileData> getProfile() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ProfileRepositoryImplConst.profilePath,
    );
    return ProfileData.fromJson(_castMap(response.data));
  }

  @override
  Future<SpeechPreference> getSpeechPreference() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ProfileRepositoryImplConst.speechPreferencePath,
    );
    return SpeechPreference.fromJson(_castMap(response.data));
  }

  @override
  Future<SpeechPreference> updateSpeechPreference({
    required SpeechPreference preference,
  }) async {
    final Response<dynamic> response = await _dio.put<dynamic>(
      ProfileRepositoryImplConst.speechPreferencePath,
      data: preference.toJson(),
    );
    return SpeechPreference.fromJson(_castMap(response.data));
  }

  @override
  Future<StudyPreference> getStudyPreference() async {
    final Response<dynamic> response = await _dio.get<dynamic>(
      ProfileRepositoryImplConst.studyPreferencePath,
    );
    return StudyPreference.fromJson(_castMap(response.data));
  }

  @override
  Future<StudyPreference> updateStudyPreference({
    required StudyPreference preference,
  }) async {
    final Response<dynamic> response = await _dio.put<dynamic>(
      ProfileRepositoryImplConst.studyPreferencePath,
      data: preference.toJson(),
    );
    return StudyPreference.fromJson(_castMap(response.data));
  }

  Map<String, dynamic> _castMap(dynamic rawValue) {
    if (rawValue is Map<dynamic, dynamic>) {
      return rawValue.cast<String, dynamic>();
    }
    return <String, dynamic>{};
  }
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(Ref ref) {
  final Dio dio = ref.watch(dioClientProvider);
  return DioProfileRepository(dio: dio);
}
