package com.iti.jets.repository.implementation;

import com.iti.jets.exception.RepositoryException;
import com.iti.jets.model.entity.User;
import com.iti.jets.model.enums.UserRole;
import com.iti.jets.repository.generic.BaseRepositoryImpl;
import com.iti.jets.repository.interfaces.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public class UserRepositoryImpl extends BaseRepositoryImpl<User, Long> implements UserRepository {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserRepositoryImpl.class.getName());

    public UserRepositoryImpl() {
        super();
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return executeReadOnly(em ->
                em.createNamedQuery("User.findByEmail", getEntityClass())
                        .setParameter("email", email)
                        .getResultStream()
                        .findFirst()
        );
    }

    @Override
    public boolean existsByEmail(String email) {
        String jpql = "SELECT COUNT(u) FROM User u WHERE u.email = :email";

        return executeReadOnly(em ->
                em.createQuery(jpql, Long.class)
                        .setParameter("email", email)
                        .getSingleResult() > 0
        );
    }

    @Override
    public Optional<User> findByUserName(String username) {
        return executeReadOnly(em ->
                em.createNamedQuery("User.findByUserName", getEntityClass())
                        .setParameter("username", username)
                        .getResultStream()
                        .findFirst()
        );
    }

    @Override
    public boolean existsByUserName(String username) {
        String jpql = "SELECT COUNT(u) FROM User u WHERE u.username = :username";

        return executeReadOnly(em ->
                em.createQuery(jpql, Long.class)
                        .setParameter("username", username)
                        .getSingleResult() > 0
        );
    }

    @Override
    public Optional<User> findByUsernameOrEmail(String username, String email) {
        String jpql = "SELECT u FROM User u WHERE u.username = :username OR u.email = :email";

        return executeReadOnly(em ->
                em.createQuery(jpql, getEntityClass())
                        .setParameter("username", username)
                        .setParameter("email", email)
                        .getResultStream()
                        .findFirst()
        );
    }

    @Override
    public List<User> findByRole(UserRole role) {
        return executeReadOnly(em ->
                em.createNamedQuery("User.findByRole", getEntityClass())
                        .setParameter("role", role)
                        .getResultList()
        );
    }

    @Override
    public List<User> findByRole(UserRole role, int pageNumber, int pageSize) {
        int offset = (pageNumber - 1) * pageSize;

        return executeReadOnly(em ->
                em.createNamedQuery("User.findByRole", getEntityClass())
                        .setParameter("role", role)
                        .setFirstResult(offset)
                        .setMaxResults(pageSize)
                        .getResultList()
        );
    }

    @Override
    public List<User> findByJob(String job) {
        return executeReadOnly(em ->
                em.createNamedQuery("User.findByJob", getEntityClass())
                        .setParameter("job", job)
                        .getResultList()
        );
    }

    @Override
    public List<User> findZeroCreditUsers(String job) {
        return executeReadOnly(em ->
                em.createNamedQuery("User.findZeroCreditUsers", getEntityClass())
                        .getResultList()
        );
    }

    @Override
    public List<User> findEmailEnabledUsers() {
        return executeReadOnly(em ->
                em.createNamedQuery("User.findEmailEnabledUsers", getEntityClass())
                        .getResultList()
        );
    }

    @Override
    public void updatePassword(Long userId, String newPassword) {
        executeInTransaction(em -> {
            User user = em.find(getEntityClass(), userId);

            if (user == null) {
                throw new RepositoryException("User not found with ID: " + userId);
            }

            user.setPassword(newPassword);
            LOGGER.info("Password updated for User ID: {}", userId);

            return null;
        });
    }

    @Override
    public void updateProfilePicture(Long userId, String profilePicUrl) {
        executeInTransaction(em -> {
            User user = em.find(getEntityClass(), userId);

            if (user == null) {
                throw new RepositoryException("User not found with ID: " + userId);
            }

            user.setProfilePicUrl(profilePicUrl);
            LOGGER.info("Profile picture updated for User ID: {}", userId);

            return null;
        });
    }

    @Override
    public void updateEmailNotifications(Long userId, Boolean enabled) {
        executeInTransaction(em -> {
            User user = em.find(getEntityClass(), userId);

            if (user == null) {
                throw new RepositoryException("User not found with ID: " + userId);
            }

            user.setEmailNotifications(enabled);
            LOGGER.info("Email notifications set to {} for User ID: {}", enabled, userId);

            return null;
        });
    }

    @Override
    public void updateCreditLimit(Long userId, BigDecimal newCreditLimit) {
        executeInTransaction(em -> {
            User user = em.find(getEntityClass(), userId);

            if (user == null) {
                throw new RepositoryException("User not found with ID: " + userId);
            }

            user.setCreditLimit(newCreditLimit);
            LOGGER.info("Credit limit updated to {} for User ID: {}", newCreditLimit, userId);

            return null;
        });
    }

    @Override
    public void updatePersonalInfo(Long userId, String firstName, String lastName, String job, LocalDate birthDate) {
        executeInTransaction(em -> {
            User user = em.find(getEntityClass(), userId);

            if (user == null) {
                throw new RepositoryException("User not found with ID: " + userId);
            }

            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setJob(job);
            user.setBirthDate(birthDate);
            LOGGER.info("Personal info updated for User ID: {}", userId);

            return null;
        });
    }
}