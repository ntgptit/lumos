package com.lumos.study.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import com.lumos.study.dto.response.SpeechPreferenceResponse;
import com.lumos.study.entity.UserSpeechPreference;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface SpeechPreferenceMapper {

    SpeechPreferenceResponse toSpeechPreferenceResponse(UserSpeechPreference preference);
}
