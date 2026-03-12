package com.lumos.auth.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.lumos.auth.entity.UserAccount;

public interface UserAccountRepository extends JpaRepository<UserAccount, Long> {

    boolean existsByUsernameIgnoreCase(String username);

    boolean existsByEmailIgnoreCase(String email);

    Optional<UserAccount> findByIdAndDeletedAtIsNull(Long id);

    Optional<UserAccount> findByUsernameIgnoreCaseAndDeletedAtIsNull(String username);

    Optional<UserAccount> findByEmailIgnoreCaseAndDeletedAtIsNull(String email);

    @Query(value = """
            SELECT *
            FROM user_accounts
            WHERE deleted_at IS NULL
              AND (
                LOWER(username) = LOWER(:identifier)
                OR LOWER(email) = LOWER(:identifier)
              )
            LIMIT 1
            """, nativeQuery = true)
    Optional<UserAccount> findActiveByIdentifier(@Param("identifier") String identifier);
}
