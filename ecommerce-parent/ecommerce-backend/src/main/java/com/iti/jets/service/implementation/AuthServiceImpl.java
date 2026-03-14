package com.iti.jets.service.implementation;

import com.iti.jets.mapper.UserMapper;
import com.iti.jets.model.dto.request.LoginRequestDTO;
import com.iti.jets.model.dto.request.RegisterRequestDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.dto.response.factory.ResponseFactory;
import com.iti.jets.model.entity.User;
import com.iti.jets.model.enums.UserRole;
import com.iti.jets.repository.interfaces.CategoryRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.AuthService;
import com.iti.jets.util.PasswordHasher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Optional;

public class AuthServiceImpl extends ContextHandler implements AuthService {

    private static final Logger LOGGER = LoggerFactory.getLogger(AuthServiceImpl.class);

    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final UserMapper userMapper;

    public AuthServiceImpl(UserRepository userRepository,
                           CategoryRepository categoryRepository,
                           UserMapper userMapper) {
        this.userRepository = userRepository;
        this.categoryRepository = categoryRepository;
        this.userMapper = userMapper;
    }

    @Override
    public BaseResponse<UserDTO> login(LoginRequestDTO request) {
        var validationRes = validateLoginRequest(request);

        if (validationRes.isFailure()) {
            LOGGER.warn("Failed login attempt: Invalid request formate");
            return ResponseFactory.failure(validationRes.getMessage());
        }

        return executeInContext(() -> {

            Optional<User> userOpt = userRepository
                    .findByUsernameOrEmail(request.getUsernameOrEmail(), request.getUsernameOrEmail());

            if (userOpt.isEmpty()) {
                LOGGER.warn("Failed login attempt: {} invalid username or email", request.getUsernameOrEmail());
                return ResponseFactory.failure("Invalid Username or Email");
            }

            User user = userOpt.get();

            // Validate password
            if (!PasswordHasher.verify(request.getPassword(), user.getPassword())) {
                LOGGER.warn("Failed login attempt: {} wrong password", request.getUsernameOrEmail());
                return ResponseFactory.failure("Wrong password");
            }

            if(request.getEmailNotifications() != null){
                user.setEmailNotifications(request.getEmailNotifications());
                userRepository.update(user);
            }

            LOGGER.info("Login successful: {}", user.getUsername());
            return ResponseFactory.success("Login successful:", userMapper.toDTO(user));
        });
    }

    @Override
    public BaseResponse<UserDTO> register(RegisterRequestDTO request) {
        var validationRes = validateRegisterRequest(request);

        if (validationRes.isFailure()) {
            LOGGER.warn("Failed register attempt: Invalid request formate");
            return ResponseFactory.failure(validationRes.getMessage());
        }

        return executeInContext(() -> {

            // Check duplicates
            if (userRepository.existsByUserName(request.getUsername())) {
                return ResponseFactory.failure("This username is already taken");
            }
            if (userRepository.existsByEmail(request.getEmail())) {
                return ResponseFactory.failure("Email address already exists");
            }

            User newUser = User.builder()
                    .username(request.getUsername())
                    .email(request.getEmail())
                    .password(PasswordHasher.hash(request.getPassword()))
                    .firstName(request.getFirstName())
                    .lastName(request.getLastName())
                    .birthDate(request.getBirthDate())
                    .job(request.getJob())
                    .creditLimit(request.getCreditLimit())
                    .role(UserRole.USER)
                    .emailNotifications(false)
                    .profilePicUrl(null)
                    .build();

            // Attach interests if found
            if (request.getCategoryIds() != null && !request.getCategoryIds().isEmpty()) {
                for (Long categoryId : request.getCategoryIds()) {
                    categoryRepository.findById(categoryId)
                            .ifPresent(newUser::addInterest);
                }
            }

            // Cascade saves all UserInterest records
            User savedUser = userRepository.save(newUser);

            LOGGER.info("User registered: {}", savedUser.getUsername());
            return ResponseFactory.success("Registered successful:", userMapper.toDTO(savedUser));
        });
    }

    // Helper Methods
    private BaseResponse<UserDTO> validateLoginRequest(LoginRequestDTO request) {
        if (request == null) {
            return ResponseFactory.failure("Login request cannot be null");
        }
        if (isBlank(request.getUsernameOrEmail())) {
            return ResponseFactory.failure("Username or email is required");
        }
        if (isBlank(request.getPassword())) {
            return ResponseFactory.failure("Password is required");
        }

        return ResponseFactory.success("Passed");
    }

    private BaseResponse<UserDTO> validateRegisterRequest(RegisterRequestDTO request) {
        if (request == null) {
            return ResponseFactory.failure("Register request cannot be null");
        }
        if (isBlank(request.getUsername())) {
            return ResponseFactory.failure("Username is required");
        }
        if (isBlank(request.getFirstName())) {
            return ResponseFactory.failure("Firstname is required");
        }
        if (isBlank(request.getLastName())) {
            return ResponseFactory.failure("Lastname is required");
        }
        if (isBlank(request.getEmail())) {
            return ResponseFactory.failure("Email is required");
        }
        if (isBlank(request.getPassword())) {
            return ResponseFactory.failure("Password is required");
        }
        if (isBlank(request.getConfirmPassword())) {
            return ResponseFactory.failure("Confirm password is required");
        }
        if (!request.getPassword().equals(request.getConfirmPassword())) {
            return ResponseFactory.failure("Passwords are not matched");
        }

        return ResponseFactory.success("Passed");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}