import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumos/data/repositories/profile/profile_repository_impl.dart';
import 'package:lumos/domain/entities/study/study_models.dart';

void main() {
  group('DioProfileRepository', () {
    test('calls profile endpoints and maps payloads', () async {
      final Dio dio = Dio();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
                if (options.path == ProfileRepositoryImplConst.profilePath) {
                  handler.resolve(
                    Response<dynamic>(
                      requestOptions: options,
                      data: <String, dynamic>{
                        'user': <String, dynamic>{
                          'id': 7,
                          'username': 'tester',
                          'email': 'tester@mail.com',
                          'accountStatus': 'ACTIVE',
                        },
                        'studyPreference': <String, dynamic>{
                          'firstLearningCardLimit': 20,
                        },
                        'speechPreference': <String, dynamic>{
                          'enabled': true,
                          'autoPlay': false,
                          'voice': 'ko-KR-neutral',
                          'speed': 1.0,
                          'locale': 'ko-KR',
                        },
                      },
                    ),
                  );
                  return;
                }
                if (options.path ==
                    ProfileRepositoryImplConst.speechPreferencePath) {
                  handler.resolve(
                    Response<dynamic>(
                      requestOptions: options,
                      data: <String, dynamic>{
                        'enabled': true,
                        'autoPlay': false,
                        'voice': 'ko-KR-neutral',
                        'speed': 1.0,
                        'locale': 'ko-KR',
                      },
                    ),
                  );
                  return;
                }
                handler.resolve(
                  Response<dynamic>(
                    requestOptions: options,
                    data: <String, dynamic>{'firstLearningCardLimit': 20},
                  ),
                );
              },
        ),
      );
      final DioProfileRepository repository = DioProfileRepository(dio: dio);

      final profile = await repository.getProfile();
      final SpeechPreference speechPreference = await repository
          .getSpeechPreference();
      final SpeechPreference updatedSpeech = await repository
          .updateSpeechPreference(
            preference: speechPreference.copyWith(autoPlay: true),
          );
      final StudyPreference studyPreference = await repository
          .getStudyPreference();
      final StudyPreference updatedStudy = await repository
          .updateStudyPreference(
            preference: studyPreference.copyWith(firstLearningCardLimit: 12),
          );

      expect(profile.user.username, 'tester');
      expect(profile.studyPreference.firstLearningCardLimit, 20);
      expect(profile.speechPreference.voice, 'ko-KR-neutral');
      expect(speechPreference.enabled, isTrue);
      expect(updatedSpeech.autoPlay, isFalse);
      expect(studyPreference.firstLearningCardLimit, 20);
      expect(updatedStudy.firstLearningCardLimit, 20);
    });
  });
}
