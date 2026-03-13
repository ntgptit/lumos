package com.lumos.auth.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

import com.lumos.auth.dto.response.AuthResponse;
import com.lumos.auth.dto.response.AuthUserResponse;
import com.lumos.auth.dto.response.CurrentUserResponse;
import com.lumos.auth.entity.UserAccount;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface AuthMapper {

    @Mapping(target = "accountStatus", expression = "java(userAccount.getAccountStatus().name())")
    AuthUserResponse toAuthUserResponse(UserAccount userAccount);

    @Mapping(target = "accountStatus", expression = "java(userAccount.getAccountStatus().name())")
    CurrentUserResponse toCurrentUserResponse(UserAccount userAccount);

    default AuthResponse toAuthResponse(
            UserAccount userAccount,
            String accessToken,
            String refreshToken,
            Long expiresIn) {
        return new AuthResponse(
                toAuthUserResponse(userAccount),
                accessToken,
                refreshToken,
                expiresIn,
                true);
    }
}
