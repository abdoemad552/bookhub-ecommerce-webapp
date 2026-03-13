package com.iti.jets.repository.interfaces;

import com.iti.jets.model.entity.User;
import com.iti.jets.model.enums.UserRole;
import com.iti.jets.repository.generic.BaseRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface UserRepository extends BaseRepository<User, Long> {

    Optional<User> findByEmail(String email);

    boolean existsByEmail(String email);

    Optional<User> findByUserName(String username);

    boolean existsByUserName(String username);

    Optional<User> findByUsernameOrEmail(String username, String email);

    List<User> findByRole(UserRole role);

    public List<User> findByRole(UserRole role, int pageNumber, int pageSize);

    List<User> findByJob(String job);

    List<User> findZeroCreditUsers(String job);

    List<User> findEmailEnabledUsers();

    void updatePassword(Long userId, String newPassword);

    void updateProfilePicture(Long userId, String profilePicUrl);

    void updateEmailNotifications(Long userId, Boolean enabled);

    void updateCreditLimit(Long userId, BigDecimal newCreditLimit);

    void updatePersonalInfo(Long userId, String firstName, String lastName, String job, LocalDate birthDate);

    /* Note:
     * Any bidirectional relation is managed by synchronization methods
     */
}