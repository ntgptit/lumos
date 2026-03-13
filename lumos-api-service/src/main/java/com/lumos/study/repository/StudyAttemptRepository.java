package com.lumos.study.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.lumos.study.entity.StudyAttempt;
import com.lumos.study.enums.StudyMode;

public interface StudyAttemptRepository extends JpaRepository<StudyAttempt, Long> {

    long countByStudySessionUserAccountIdAndReviewOutcome(Long userId, com.lumos.study.enums.ReviewOutcome reviewOutcome);

    void deleteAllByStudySessionIdAndStudyMode(Long studySessionId, StudyMode studyMode);
}
