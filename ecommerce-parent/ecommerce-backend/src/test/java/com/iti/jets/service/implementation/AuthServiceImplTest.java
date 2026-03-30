package com.iti.jets.service.implementation;

import com.iti.jets.mapper.UserMapper;
import com.iti.jets.model.dto.request.LoginRequestDTO;
import com.iti.jets.model.dto.request.RegisterRequestDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.entity.Category;
import com.iti.jets.model.entity.User;
import com.iti.jets.model.enums.UserRole;
import com.iti.jets.repository.interfaces.CategoryRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import com.iti.jets.util.PasswordHasher;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Optional;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("AuthServiceImpl Tests")
class AuthServiceImplTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private CategoryRepository categoryRepository;

    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private AuthServiceImpl authService;

    private User mockUser;
    private UserDTO mockUserDTO;

    @BeforeEach
    void setUp() {
        mockUser = new User();
        mockUser.setId(1L);
        mockUser.setUsername("john_doe");
        mockUser.setEmail("john@example.com");
        mockUser.setPassword(PasswordHasher.hash("password123"));
        mockUser.setFirstName("John");
        mockUser.setLastName("Doe");
        mockUser.setRole(UserRole.USER);

        mockUserDTO = new UserDTO();
    }

    // ─────────────────────────────────────────────────────────────────────────
    // login
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("login")
    class Login {

        private LoginRequestDTO validRequest;

        @BeforeEach
        void init() {
            validRequest = new LoginRequestDTO();
            validRequest.setUsernameOrEmail("john_doe");
            validRequest.setPassword("password123");
        }

        @Test
        @DisplayName("returns failure when request is null")
        void returnsFailure_whenRequestNull() {
            BaseResponse<UserDTO> result = authService.login(null);

            assertFalse(result.isSuccess());
            assertEquals("Login request cannot be null", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when usernameOrEmail is blank")
        void returnsFailure_whenUsernameBlank() {
            validRequest.setUsernameOrEmail("  ");

            BaseResponse<UserDTO> result = authService.login(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Username or email is required", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when usernameOrEmail is null")
        void returnsFailure_whenUsernameNull() {
            validRequest.setUsernameOrEmail(null);

            BaseResponse<UserDTO> result = authService.login(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Username or email is required", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when password is blank")
        void returnsFailure_whenPasswordBlank() {
            validRequest.setPassword("");

            BaseResponse<UserDTO> result = authService.login(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Password is required", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when user not found")
        void returnsFailure_whenUserNotFound() {
            when(userRepository.findByUsernameOrEmail(anyString(), anyString()))
                    .thenReturn(Optional.empty());

            BaseResponse<UserDTO> result = authService.login(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Invalid Username or Email", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when password is wrong")
        void returnsFailure_whenPasswordWrong() {
            validRequest.setPassword("wrongPassword");
            when(userRepository.findByUsernameOrEmail(anyString(), anyString()))
                    .thenReturn(Optional.of(mockUser));

            BaseResponse<UserDTO> result = authService.login(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Wrong password", result.getMessage());
        }

        @Test
        @DisplayName("returns success with UserDTO on valid credentials")
        void returnsSuccess_onValidCredentials() {
            when(userRepository.findByUsernameOrEmail("john_doe", "john_doe"))
                    .thenReturn(Optional.of(mockUser));
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            BaseResponse<UserDTO> result = authService.login(validRequest);

            assertTrue(result.isSuccess());
            assertNotNull(result.getData());
        }

        @Test
        @DisplayName("can login with email as identifier")
        void returnsSuccess_whenLoginWithEmail() {
            validRequest.setUsernameOrEmail("john@example.com");

            when(userRepository.findByUsernameOrEmail("john@example.com", "john@example.com"))
                    .thenReturn(Optional.of(mockUser));
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            BaseResponse<UserDTO> result = authService.login(validRequest);

            assertTrue(result.isSuccess());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // register
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("register")
    class Register {

        private RegisterRequestDTO validRequest;

        @BeforeEach
        void init() {
            validRequest = new RegisterRequestDTO();
            validRequest.setUsername("new_user");
            validRequest.setFirstName("Alice");
            validRequest.setLastName("Smith");
            validRequest.setEmail("alice@example.com");
            validRequest.setPassword("securePass");
            validRequest.setConfirmPassword("securePass");
            validRequest.setBirthDate(LocalDate.of(1995, 5, 15));
            validRequest.setJob("Engineer");
            validRequest.setCreditLimit(BigDecimal.ZERO);
            validRequest.setEmailNotifications(true);
        }

        @Test
        @DisplayName("returns failure when request is null")
        void returnsFailure_whenRequestNull() {
            BaseResponse<UserDTO> result = authService.register(null);

            assertFalse(result.isSuccess());
            assertEquals("Register request cannot be null", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when username is blank")
        void returnsFailure_whenUsernameBlank() {
            validRequest.setUsername("");

            BaseResponse<UserDTO> result = authService.register(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Username is required", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when firstName is blank")
        void returnsFailure_whenFirstNameBlank() {
            validRequest.setFirstName(null);

            BaseResponse<UserDTO> result = authService.register(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Firstname is required", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when lastName is blank")
        void returnsFailure_whenLastNameBlank() {
            validRequest.setLastName("  ");

            BaseResponse<UserDTO> result = authService.register(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Lastname is required", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when email is blank")
        void returnsFailure_whenEmailBlank() {
            validRequest.setEmail("");

            BaseResponse<UserDTO> result = authService.register(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Email is required", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when password is blank")
        void returnsFailure_whenPasswordBlank() {
            validRequest.setPassword(null);

            BaseResponse<UserDTO> result = authService.register(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Password is required", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when confirmPassword is blank")
        void returnsFailure_whenConfirmPasswordBlank() {
            validRequest.setConfirmPassword("");

            BaseResponse<UserDTO> result = authService.register(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Confirm password is required", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when passwords do not match")
        void returnsFailure_whenPasswordsMismatch() {
            validRequest.setConfirmPassword("differentPass");

            BaseResponse<UserDTO> result = authService.register(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Passwords are not matched", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when username is already taken")
        void returnsFailure_whenUsernameTaken() {
            when(userRepository.existsByUserName("new_user")).thenReturn(true);

            BaseResponse<UserDTO> result = authService.register(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("This username is already taken", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when email is already taken")
        void returnsFailure_whenEmailTaken() {
            when(userRepository.existsByUserName("new_user")).thenReturn(false);
            when(userRepository.existsByEmail("alice@example.com")).thenReturn(true);

            BaseResponse<UserDTO> result = authService.register(validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Email address already exists", result.getMessage());
        }

        @Test
        @DisplayName("registers user successfully with no interests")
        void registersUser_successfully_withNoInterests() {
            when(userRepository.existsByUserName("new_user")).thenReturn(false);
            when(userRepository.existsByEmail("alice@example.com")).thenReturn(false);
            when(userRepository.save(any(User.class))).thenReturn(mockUser);
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            BaseResponse<UserDTO> result = authService.register(validRequest);

            assertTrue(result.isSuccess());
            verify(userRepository).save(any(User.class));
        }

        @Test
        @DisplayName("registers user and attaches valid interests")
        void registersUser_withInterests_whenCategoriesExist() {
            Category cat = new Category();
            cat.setId(3L);
            validRequest.setCategoryIds(Set.of(3L));

            when(userRepository.existsByUserName("new_user")).thenReturn(false);
            when(userRepository.existsByEmail("alice@example.com")).thenReturn(false);
            when(categoryRepository.findById(3L)).thenReturn(Optional.of(cat));
            when(userRepository.save(any(User.class))).thenReturn(mockUser);
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            BaseResponse<UserDTO> result = authService.register(validRequest);

            assertTrue(result.isSuccess());
            verify(categoryRepository).findById(3L);
        }

        @Test
        @DisplayName("skips non-existent category without failure")
        void skipsInvalidCategory_withoutError() {
            validRequest.setCategoryIds(Set.of(999L));

            when(userRepository.existsByUserName("new_user")).thenReturn(false);
            when(userRepository.existsByEmail("alice@example.com")).thenReturn(false);
            when(categoryRepository.findById(999L)).thenReturn(Optional.empty());
            when(userRepository.save(any(User.class))).thenReturn(mockUser);
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            BaseResponse<UserDTO> result = authService.register(validRequest);

            // ifPresent means missing category is simply skipped
            assertTrue(result.isSuccess());
        }

        @Test
        @DisplayName("password is stored hashed, not plain text")
        void passwordIsHashed_notPlainText() {
            when(userRepository.existsByUserName(anyString())).thenReturn(false);
            when(userRepository.existsByEmail(anyString())).thenReturn(false);
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));
            when(userMapper.toDTO(any())).thenReturn(mockUserDTO);

            authService.register(validRequest);

            verify(userRepository).save(argThat(savedUser ->
                    !savedUser.getPassword().equals("securePass") // must NOT be plain text
            ));
        }

        @Test
        @DisplayName("new user is always registered with USER role")
        void newUser_alwaysRegisteredAsUserRole() {
            when(userRepository.existsByUserName(anyString())).thenReturn(false);
            when(userRepository.existsByEmail(anyString())).thenReturn(false);
            when(userRepository.save(any(User.class))).thenAnswer(inv -> inv.getArgument(0));
            when(userMapper.toDTO(any())).thenReturn(mockUserDTO);

            authService.register(validRequest);

            verify(userRepository).save(argThat(savedUser ->
                    savedUser.getRole() == UserRole.USER
            ));
        }
    }
}