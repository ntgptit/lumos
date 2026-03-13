package com.lumos.study.support;

import com.lumos.auth.entity.UserAccount;
import com.lumos.auth.exception.UnauthorizedAccessException;
import com.lumos.auth.repository.UserAccountRepository;
import com.lumos.study.constant.StudyConstants;
import com.lumos.study.entity.UserStudyPreference;
import com.lumos.study.repository.UserStudyPreferenceRepository;

import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class UserStudyPreferenceSupport {

    private final UserAccountRepository userAccountRepository;
    private final UserStudyPreferenceRepository userStudyPreferenceRepository;

    public UserStudyPreference resolvePreference(Long userId) {
        final UserStudyPreference existingPreference = this.userStudyPreferenceRepository
                .findByUserAccountIdAndDeletedAtIsNull(userId)
                .orElse(null);
        // Reuse the stored study preference when the user has already configured one.
        if (existingPreference != null) {
            // Return the existing preference instead of creating a duplicate row for the same account.
            return existingPreference;
        }
        final UserAccount userAccount = this.userAccountRepository.findByIdAndDeletedAtIsNull(userId)
                .orElseThrow(UnauthorizedAccessException::new);
        final UserStudyPreference preference = new UserStudyPreference();
        preference.setUserAccount(userAccount);
        preference.setFirstLearningCardLimit(StudyConstants.DEFAULT_FIRST_LEARNING_CARD_LIMIT);
        // Return the newly persisted default preference so later reads and updates reuse the same record.
        return this.userStudyPreferenceRepository.save(preference);
    }

    public int resolveFirstLearningCardLimit(Long userId) {
        final UserStudyPreference preference = resolvePreference(userId);
        // Return the canonical first-learning card limit that should cap new-card selection per session.
        return preference.getFirstLearningCardLimit();
    }
}
