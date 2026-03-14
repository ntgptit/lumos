package com.lumos.study.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.lumos.study.entity.UserStudyPreference;

public interface UserStudyPreferenceRepository extends JpaRepository<UserStudyPreference, Long> {

    Optional<UserStudyPreference> findByUserAccountIdAndDeletedAtIsNull(Long userId);
}
