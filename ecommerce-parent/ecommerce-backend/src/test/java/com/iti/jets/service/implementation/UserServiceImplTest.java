package com.iti.jets.service.implementation;

import com.iti.jets.mapper.UserMapper;
import com.iti.jets.model.dto.request.AddressRequestDTO;
import com.iti.jets.model.dto.request.UpdatePersonalInfoRequestDTO;
import com.iti.jets.model.dto.response.UserAddressesDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.UserInterestsDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.entity.Address;
import com.iti.jets.model.entity.Category;
import com.iti.jets.model.entity.User;
import com.iti.jets.model.entity.UserInterest;
import com.iti.jets.model.enums.AddressType;
import com.iti.jets.model.enums.UserRole;
import com.iti.jets.repository.interfaces.CategoryRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("UserServiceImpl Tests")
class UserServiceImplTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private CategoryRepository categoryRepository;

    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private UserServiceImpl userService;

    private User mockUser;
    private UserDTO mockUserDTO;

    @BeforeEach
    void setUp() {
        mockUser = new User();
        mockUser.setId(1L);
        mockUser.setUsername("john_doe");
        mockUser.setEmail("john@example.com");
        mockUser.setFirstName("John");
        mockUser.setLastName("Doe");
        mockUser.setRole(UserRole.USER);
        mockUser.setPassword("$2a$hashed_password");

        mockUserDTO = new UserDTO();
        // populate DTO fields as needed
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findById
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findById")
    class FindById {

        @Test
        @DisplayName("returns UserDTO when user exists")
        void returnsUserDTO_whenUserExists() {
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            UserDTO result = userService.findById(1L);

            assertNotNull(result);
            verify(userRepository).findById(1L);
            verify(userMapper).toDTO(mockUser);
        }

        @Test
        @DisplayName("returns null when user does not exist")
        void returnsNull_whenUserNotFound() {
            when(userRepository.findById(99L)).thenReturn(Optional.empty());

            UserDTO result = userService.findById(99L);

            assertNull(result);
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findAll
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findAll")
    class FindAll {

        @Test
        @DisplayName("returns list of mapped UserDTOs")
        void returnsMappedDTOs() {
            when(userRepository.findAll()).thenReturn(List.of(mockUser));
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            List<UserDTO> result = userService.findAll();

            assertEquals(1, result.size());
        }

        @Test
        @DisplayName("returns empty list when no users exist")
        void returnsEmptyList_whenNoUsers() {
            when(userRepository.findAll()).thenReturn(List.of());

            List<UserDTO> result = userService.findAll();

            assertTrue(result.isEmpty());
        }

        @Test
        @DisplayName("returns paged results")
        void returnsMappedDTOs_withPagination() {
            when(userRepository.findAll(0, 10)).thenReturn(List.of(mockUser));
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            List<UserDTO> result = userService.findAll(0, 10);

            assertEquals(1, result.size());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // delete
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("delete")
    class Delete {

        @Test
        @DisplayName("deletes user when found")
        void deletesUser_whenFound() {
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

            userService.delete(1L);

            verify(userRepository).delete(mockUser);
        }

        @Test
        @DisplayName("does nothing when user not found")
        void doesNothing_whenUserNotFound() {
            when(userRepository.findById(99L)).thenReturn(Optional.empty());

            userService.delete(99L);

            verify(userRepository, never()).delete(any());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // existence checks
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("Existence checks")
    class ExistenceChecks {

        @Test
        @DisplayName("existsById returns true when user exists")
        void existsById_returnsTrue() {
            when(userRepository.existsById(1L)).thenReturn(true);
            assertTrue(userService.existsById(1L));
        }

        @Test
        @DisplayName("existsById returns false when user does not exist")
        void existsById_returnsFalse() {
            when(userRepository.existsById(99L)).thenReturn(false);
            assertFalse(userService.existsById(99L));
        }

        @Test
        @DisplayName("existsByUserName returns true when username taken")
        void existsByUserName_returnsTrue() {
            when(userRepository.existsByUserName("john_doe")).thenReturn(true);
            assertTrue(userService.existsByUserName("john_doe"));
        }

        @Test
        @DisplayName("existsByEmail returns true when email taken")
        void existsByEmail_returnsTrue() {
            when(userRepository.existsByEmail("john@example.com")).thenReturn(true);
            assertTrue(userService.existsByEmail("john@example.com"));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // findByUsername
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("findByUsername")
    class FindByUsername {

        @Test
        @DisplayName("returns UserDTO when username exists")
        void returnsUserDTO_whenFound() {
            when(userRepository.findByUserName("john_doe")).thenReturn(Optional.of(mockUser));
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            UserDTO result = userService.findByUsername("john_doe");

            assertNotNull(result);
        }

        @Test
        @DisplayName("returns null when username not found")
        void returnsNull_whenNotFound() {
            when(userRepository.findByUserName("unknown")).thenReturn(Optional.empty());

            assertNull(userService.findByUsername("unknown"));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // loadUserAddresses / loadUserInterests
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("loadUserAddresses")
    class LoadUserAddresses {

        @Test
        @DisplayName("returns addresses DTO when user found")
        void returnsAddressesDTO_whenUserFound() {
            UserAddressesDTO addressesDTO = new UserAddressesDTO();
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(userMapper.toUserAddressesDTO(mockUser)).thenReturn(addressesDTO);

            UserAddressesDTO result = userService.loadUserAddresses(1L);

            assertNotNull(result);
        }

        @Test
        @DisplayName("returns null when user not found")
        void returnsNull_whenUserNotFound() {
            when(userRepository.findById(99L)).thenReturn(Optional.empty());

            assertNull(userService.loadUserAddresses(99L));
        }
    }

    @Nested
    @DisplayName("loadUserInterests")
    class LoadUserInterests {

        @Test
        @DisplayName("returns interests DTO when user found")
        void returnsInterestsDTO_whenUserFound() {
            UserInterestsDTO interestsDTO = new UserInterestsDTO();
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(userMapper.toUserInterestsDTO(mockUser)).thenReturn(interestsDTO);

            UserInterestsDTO result = userService.loadUserInterests(1L);

            assertNotNull(result);
        }

        @Test
        @DisplayName("returns null when user not found")
        void returnsNull_whenUserNotFound() {
            when(userRepository.findById(99L)).thenReturn(Optional.empty());

            assertNull(userService.loadUserInterests(99L));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // saveNewUserAddress
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("saveNewUserAddress")
    class SaveNewUserAddress {

        private AddressRequestDTO addressRequest;
        private Address newAddress;

        @BeforeEach
        void init() {
            addressRequest = new AddressRequestDTO();
            newAddress = new Address();
            newAddress.setAddressType(AddressType.HOME);
            mockUser.setAddresses(new java.util.HashSet<>());
        }

        @Test
        @DisplayName("returns failure when user not found")
        void returnsFailure_whenUserNotFound() {
            when(userRepository.findById(99L)).thenReturn(Optional.empty());

            BaseResponse<Void> result = userService.saveNewUserAddress(99L, addressRequest);

            assertFalse(result.isSuccess());
            assertEquals("Invalid user", result.getMessage());
        }

        @Test
        @DisplayName("inserts new address when type does not already exist")
        void insertsNewAddress_whenTypeDoesNotExist() {
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(userMapper.toAddressEntity(addressRequest)).thenReturn(newAddress);
            when(userRepository.update(mockUser)).thenReturn(mockUser);

            BaseResponse<Void> result = userService.saveNewUserAddress(1L, addressRequest);

            assertTrue(result.isSuccess());
            assertTrue(mockUser.getAddresses().contains(newAddress));
            verify(userRepository).update(mockUser);
        }

        @Test
        @DisplayName("updates existing address when type already exists")
        void updatesExistingAddress_whenTypeExists() {
            Address existing = new Address();
            existing.setAddressType(AddressType.HOME);
            existing.setCity("Cairo");
            mockUser.getAddresses().add(existing);

            Address incoming = new Address();
            incoming.setAddressType(AddressType.HOME);
            incoming.setCity("Alexandria");

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(userMapper.toAddressEntity(addressRequest)).thenReturn(incoming);
            when(userRepository.update(mockUser)).thenReturn(mockUser);

            BaseResponse<Void> result = userService.saveNewUserAddress(1L, addressRequest);

            assertTrue(result.isSuccess());
            assertEquals("Alexandria", existing.getCity());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // toggleRole
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("toggleRole")
    class ToggleRole {

        @Test
        @DisplayName("returns false when user not found")
        void returnsFalse_whenUserNotFound() {
            when(userRepository.findById(99L)).thenReturn(Optional.empty());

            assertFalse(userService.toggleRole(99L));
        }

        @Test
        @DisplayName("promotes USER to ADMIN")
        void promotesUser_toAdmin() {
            mockUser.setRole(UserRole.USER);
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(userRepository.update(mockUser)).thenReturn(mockUser);

            boolean result = userService.toggleRole(1L);

            assertTrue(result);
            assertEquals(UserRole.ADMIN, mockUser.getRole());
        }

        @Test
        @DisplayName("demotes ADMIN to USER")
        void demotesAdmin_toUser() {
            mockUser.setRole(UserRole.ADMIN);
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(userRepository.update(mockUser)).thenReturn(mockUser);

            boolean result = userService.toggleRole(1L);

            assertTrue(result);
            assertEquals(UserRole.USER, mockUser.getRole());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // updateUser
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("updateUser")
    class UpdateUser {

        private UpdatePersonalInfoRequestDTO validRequest;

        @BeforeEach
        void init() {
            validRequest = new UpdatePersonalInfoRequestDTO();
            validRequest.setFirstName("Jane");
            validRequest.setLastName("Doe");
            // no password change
        }

        @Test
        @DisplayName("returns failure when userId is null")
        void returnsFailure_whenUserIdNull() {
            BaseResponse<UserDTO> result = userService.updateUser(null, validRequest);

            assertFalse(result.isSuccess());
        }

        @Test
        @DisplayName("returns failure when request is null")
        void returnsFailure_whenRequestNull() {
            BaseResponse<UserDTO> result = userService.updateUser(1L, null);

            assertFalse(result.isSuccess());
        }

        @Test
        @DisplayName("returns failure when user not found")
        void returnsFailure_whenUserNotFound() {
            when(userRepository.findById(99L)).thenReturn(Optional.empty());

            BaseResponse<UserDTO> result = userService.updateUser(99L, validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Invalid user", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when firstName is blank")
        void returnsFailure_whenFirstNameBlank() {
            validRequest.setFirstName("  ");
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

            BaseResponse<UserDTO> result = userService.updateUser(1L, validRequest);

            assertFalse(result.isSuccess());
            assertEquals("First name is required", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when lastName is blank")
        void returnsFailure_whenLastNameBlank() {
            validRequest.setLastName("");
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

            BaseResponse<UserDTO> result = userService.updateUser(1L, validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Last name is required", result.getMessage());
        }

        @Test
        @DisplayName("updates user successfully without password change")
        void updatesUser_successfully_withoutPasswordChange() {
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(userRepository.update(mockUser)).thenReturn(mockUser);
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            BaseResponse<UserDTO> result = userService.updateUser(1L, validRequest);

            assertTrue(result.isSuccess());
            assertEquals("Jane", mockUser.getFirstName());
            assertEquals("Doe", mockUser.getLastName());
        }

        @Test
        @DisplayName("returns failure when current password not provided during password change")
        void returnsFailure_whenCurrentPasswordMissing() {
            validRequest.setNewPassword("newPass123");
            validRequest.setConfirmNewPassword("newPass123");
            // currentPassword left null

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

            BaseResponse<UserDTO> result = userService.updateUser(1L, validRequest);

            assertFalse(result.isSuccess());
            assertEquals("Current password is required", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when new passwords do not match")
        void returnsFailure_whenNewPasswordsMismatch() {
            validRequest.setCurrentPassword("currentPass");
            validRequest.setNewPassword("newPass123");
            validRequest.setConfirmNewPassword("differentPass");

            // mock PasswordHasher.verify via a user with known hash — adjust if static method is mockable
            mockUser.setPassword(com.iti.jets.util.PasswordHasher.hash("currentPass"));
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

            BaseResponse<UserDTO> result = userService.updateUser(1L, validRequest);

            assertFalse(result.isSuccess());
            assertEquals("New passwords do not match", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when new password is same as current")
        void returnsFailure_whenNewPasswordSameAsCurrent() {
            mockUser.setPassword(com.iti.jets.util.PasswordHasher.hash("samePass123"));
            validRequest.setCurrentPassword("samePass123");
            validRequest.setNewPassword("samePass123");
            validRequest.setConfirmNewPassword("samePass123");

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

            BaseResponse<UserDTO> result = userService.updateUser(1L, validRequest);

            assertFalse(result.isSuccess());
            assertEquals("New password must be different from the current password", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when new password is too short")
        void returnsFailure_whenNewPasswordTooShort() {
            mockUser.setPassword(com.iti.jets.util.PasswordHasher.hash("currentPass"));
            validRequest.setCurrentPassword("currentPass");
            validRequest.setNewPassword("short");
            validRequest.setConfirmNewPassword("short");

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

            BaseResponse<UserDTO> result = userService.updateUser(1L, validRequest);

            assertFalse(result.isSuccess());
            assertEquals("New password must be at least 8 characters long", result.getMessage());
        }

        @Test
        @DisplayName("updates password when all password fields are valid")
        void updatesPassword_whenValid() {
            mockUser.setPassword(com.iti.jets.util.PasswordHasher.hash("currentPass"));
            validRequest.setCurrentPassword("currentPass");
            validRequest.setNewPassword("newValidPass");
            validRequest.setConfirmNewPassword("newValidPass");

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(userRepository.update(mockUser)).thenReturn(mockUser);
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            BaseResponse<UserDTO> result = userService.updateUser(1L, validRequest);

            assertTrue(result.isSuccess());
            // Password should be re-hashed
            assertNotEquals("currentPass", mockUser.getPassword());
        }

        @Test
        @DisplayName("throws exception when an interest id is invalid")
        void throwsException_whenInterestIdInvalid() {
            validRequest.setInterestIds(Set.of(999L));

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(categoryRepository.findById(999L)).thenReturn(Optional.empty());

            assertThrows(Exception.class, () -> userService.updateUser(1L, validRequest));
        }

        @Test
        @DisplayName("resolves valid interest ids successfully")
        void resolvesInterests_whenValid() {
            Category category = new Category();
            category.setId(5L);
            validRequest.setInterestIds(Set.of(5L));

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(categoryRepository.findById(5L)).thenReturn(Optional.of(category));
            when(userRepository.update(mockUser)).thenReturn(mockUser);
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            BaseResponse<UserDTO> result = userService.updateUser(1L, validRequest);

            assertTrue(result.isSuccess());
            Set<UserInterest> interests = mockUser.getInterests();
            for(var intr : interests){
                assertTrue(intr.getCategory() == category);
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // updateBalance
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("updateBalance")
    class UpdateBalance {

        @Test
        @DisplayName("returns failure when userId is null")
        void returnsFailure_whenUserIdNull() {
            BaseResponse<UserDTO> result = userService.updateBalance(null, BigDecimal.TEN);

            assertFalse(result.isSuccess());
        }

        @Test
        @DisplayName("returns failure when user not found")
        void returnsFailure_whenUserNotFound() {
            when(userRepository.findById(99L)).thenReturn(Optional.empty());

            BaseResponse<UserDTO> result = userService.updateBalance(99L, BigDecimal.TEN);

            assertFalse(result.isSuccess());
        }

        @Test
        @DisplayName("sets balance to ZERO when null is passed")
        void setsBalanceToZero_whenNullBalance() {
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(userRepository.update(mockUser)).thenReturn(mockUser);
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            BaseResponse<UserDTO> result = userService.updateBalance(1L, null);

            assertTrue(result.isSuccess());
            assertEquals(BigDecimal.ZERO, mockUser.getCreditLimit());
        }

        @Test
        @DisplayName("updates balance to provided value")
        void updatesBalance_whenValidAmount() {
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(userRepository.update(mockUser)).thenReturn(mockUser);
            when(userMapper.toDTO(mockUser)).thenReturn(mockUserDTO);

            BaseResponse<UserDTO> result = userService.updateBalance(1L, new BigDecimal("500.00"));

            assertTrue(result.isSuccess());
            assertEquals(new BigDecimal("500.00"), mockUser.getCreditLimit());
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // deleteUserAddress
    // ─────────────────────────────────────────────────────────────────────────
    @Nested
    @DisplayName("deleteUserAddress")
    class DeleteUserAddress {

        @Test
        @DisplayName("returns failure when user not found")
        void returnsFailure_whenUserNotFound() {
            when(userRepository.findById(99L)).thenReturn(Optional.empty());

            BaseResponse<Void> result = userService.deleteUserAddress(99L, 1L);

            assertFalse(result.isSuccess());
            assertEquals("Invalid user", result.getMessage());
        }

        @Test
        @DisplayName("returns failure when address not found on user")
        void returnsFailure_whenAddressNotFound() {
            mockUser.setAddresses(new java.util.HashSet<>());
            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));

            BaseResponse<Void> result = userService.deleteUserAddress(1L, 99L);

            assertFalse(result.isSuccess());
            assertEquals("Address not found", result.getMessage());
        }

        @Test
        @DisplayName("removes address successfully when found")
        void removesAddress_whenFound() {
            Address address = new Address();
            address.setId(10L);
            mockUser.setAddresses(new java.util.HashSet<>(Set.of(address)));

            when(userRepository.findById(1L)).thenReturn(Optional.of(mockUser));
            when(userRepository.update(mockUser)).thenReturn(mockUser);

            BaseResponse<Void> result = userService.deleteUserAddress(1L, 10L);

            assertTrue(result.isSuccess());
            assertFalse(mockUser.getAddresses().contains(address));
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // updateProfilePicUrl
    // ─────────────────────────────────────────────────────────────────────────
    @Test
    @DisplayName("updateProfilePicUrl delegates to repository")
    void updateProfilePicUrl_delegatesToRepository() {
        userService.updateProfilePicUrl(1L, "http://example.com/pic.jpg");

        verify(userRepository).updateProfilePicture(1L, "http://example.com/pic.jpg");
    }

    // ─────────────────────────────────────────────────────────────────────────
    // count
    // ─────────────────────────────────────────────────────────────────────────
    @Test
    @DisplayName("count returns repository count")
    void count_returnsRepositoryCount() {
        when(userRepository.count()).thenReturn(42L);

        assertEquals(42L, userService.count());
    }
}