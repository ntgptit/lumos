package com.lumos.study.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import com.lumos.study.dto.response.StudyPreferenceResponse;
import com.lumos.study.entity.UserStudyPreference;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface StudyPreferenceMapper {

    StudyPreferenceResponse toStudyPreferenceResponse(UserStudyPreference preference);
}
