package com.lumos.profile.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import com.lumos.auth.dto.response.CurrentUserResponse;
import com.lumos.profile.dto.response.ProfileResponse;
import com.lumos.study.dto.response.SpeechPreferenceResponse;
import com.lumos.study.dto.response.StudyPreferenceResponse;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface ProfileMapper {

    ProfileResponse toProfileResponse(
            CurrentUserResponse user,
            StudyPreferenceResponse studyPreference,
            SpeechPreferenceResponse speechPreference);
}
