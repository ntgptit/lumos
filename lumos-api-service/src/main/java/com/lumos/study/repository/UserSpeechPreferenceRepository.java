package com.lumos.study.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.lumos.study.entity.UserSpeechPreference;

public interface UserSpeechPreferenceRepository extends JpaRepository<UserSpeechPreference, Long> {

    Optional<UserSpeechPreference> findByUserAccountIdAndDeletedAtIsNull(Long userId);
}
