package com.lumos.testkit;

import com.lumos.auth.dto.response.CurrentUserResponse;
import com.lumos.profile.dto.response.ProfileResponse;

public final class ProfileTestFixtures {

    private ProfileTestFixtures() {
    }

    public static CurrentUserResponse currentUserResponse() {
        return new CurrentUserResponse(7L, "tester", "tester@mail.com", "ACTIVE");
    }

    public static ProfileResponse profileResponse() {
        return new ProfileResponse(
                currentUserResponse(),
                StudyTestFixtures.studyPreferenceResponse(),
                StudyTestFixtures.speechPreferenceResponse());
    }
}
