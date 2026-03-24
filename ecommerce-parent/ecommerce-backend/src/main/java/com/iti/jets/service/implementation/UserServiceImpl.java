package com.iti.jets.service.implementation;

import com.iti.jets.mapper.UserMapper;
import com.iti.jets.model.dto.request.AddressRequestDTO;
import com.iti.jets.model.dto.request.UpdatePersonalInfoRequestDTO;
import com.iti.jets.model.dto.response.UserAddressesDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.UserInterestsDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.dto.response.factory.ResponseFactory;
import com.iti.jets.model.entity.Address;
import com.iti.jets.model.entity.Category;
import com.iti.jets.model.entity.User;
import com.iti.jets.repository.interfaces.CategoryRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.iti.jets.util.PasswordHasher;

import java.math.BigDecimal;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

public class UserServiceImpl extends ContextHandler implements UserService {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserServiceImpl.class);

    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final UserMapper userMapper;

    public UserServiceImpl(UserRepository userRepository,
                           CategoryRepository categoryRepository,
                           UserMapper userMapper) {
        this.userRepository = userRepository;
        this.categoryRepository = categoryRepository;
        this.userMapper = userMapper;
    }

    @Override
    public UserDTO findById(Long id) {
        return executeInContext(() -> {
            Optional<User> userOpt = userRepository.findById(id);
            if (userOpt.isPresent()) {
                return userMapper.toDTO(userOpt.get());
            } else {
                return null;
            }
        });
    }

    @Override
    public List<UserDTO> findAll() {
        return executeInContext(() -> userRepository
                .findAll()
                .stream()
                .map(userMapper::toDTO)
                .toList()
        );
    }

    @Override
    public List<UserDTO> findAll(int pageNumber, int pageSize) {
        return executeInContext(() -> userRepository
                .findAll(pageNumber, pageSize)
                .stream()
                .map(userMapper::toDTO)
                .toList()
        );
    }

    @Override
    public void delete(Long id) {
        executeInContext(() -> {
            Optional<User> userOpt = userRepository.findById(id);
            if (userOpt.isPresent()) {
                userRepository.delete(userOpt.get());
            }
        });
    }

    @Override
    public long count() {
        return executeInContext(userRepository::count);
    }

    @Override
    public boolean existsById(Long id) {
        return executeInContext(() -> userRepository.existsById(id));
    }

    @Override
    public boolean existsByUserName(String username) {
        return executeInContext(() -> userRepository.existsByUserName(username));
    }

    @Override
    public boolean existsByEmail(String email) {
        return executeInContext(() -> userRepository.existsByEmail(email));
    }

    @Override
    public UserDTO findByUsername(String username) {
        return executeInContext(() -> {
            Optional<User> userOpt = userRepository.findByUserName(username);
            if (userOpt.isEmpty()) {
                return null;
            }
            return userMapper.toDTO(userOpt.get());
        });
    }

    @Override
    public UserAddressesDTO loadUserAddresses(Long id) {
        return executeInContext(() -> {
            Optional<User> userOpt = userRepository.findById(id);
            if (userOpt.isEmpty()) {
                return null;
            }

            return userMapper.toUserAddressesDTO(userOpt.get());
        });
    }

    @Override
    public UserInterestsDTO loadUserInterests(Long id) {
        return executeInContext(() -> {
            Optional<User> userOpt = userRepository.findById(id);
            if (userOpt.isEmpty()) {
                return null;
            }

            return userMapper.toUserInterestsDTO(userOpt.get());
        });
    }

    @Override
    public BaseResponse<Void> saveNewUserAddress(Long userId, AddressRequestDTO addressRequestDto) {
        return executeInContext(() -> {
            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isEmpty()) {
                return ResponseFactory.failure("Invalid user");
            }

            User user = userOpt.get();
            Address newAddress = userMapper.toAddressEntity(addressRequestDto);

            Optional<Address> existingAddress = user.getAddresses()
                    .stream()
                    .filter(addr -> addr.getAddressType().equals(newAddress.getAddressType()))
                    .findFirst();

            if (existingAddress.isPresent()) {
                // Update the existing address fields
                Address existing = existingAddress.get();
                existing.setGovernment(newAddress.getGovernment());
                existing.setCity(newAddress.getCity());
                existing.setStreet(newAddress.getStreet());
                existing.setBuildingNo(newAddress.getBuildingNo());
                existing.setDescription(newAddress.getDescription());
            } else {
                // Insert new address
                user.addAddress(newAddress);
            }

            userRepository.update(user);
            return ResponseFactory.success("Address saved successfully");
        });
    }

    @Override
    public BaseResponse<UserDTO> updateUser(Long userId, UpdatePersonalInfoRequestDTO userInfoRequestDto) {
        return executeInContext(() -> {
            if (userId == null || userInfoRequestDto == null) {
                return ResponseFactory.failure("Invalid user update request");
            }

            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isEmpty()) {
                return ResponseFactory.failure("Invalid user");
            }

            String firstName = normalize(userInfoRequestDto.getFirstName());
            String lastName = normalize(userInfoRequestDto.getLastName());

            if (isBlank(firstName)) {
                return ResponseFactory.failure("First name is required");
            }
            if (isBlank(lastName)) {
                return ResponseFactory.failure("Last name is required");
            }

            User user = userOpt.get();

            String passwordValidationMessage = validatePasswordChange(userInfoRequestDto, user);
            if (passwordValidationMessage != null) {
                return ResponseFactory.failure(passwordValidationMessage);
            }


            user.setFirstName(firstName);
            user.setLastName(lastName);
            user.setJob(normalizeNullable(userInfoRequestDto.getJob()));
            user.setBirthDate(userInfoRequestDto.getBirthDate());
            user.setEmailNotifications(Boolean.TRUE.equals(userInfoRequestDto.getEmailNotifications()));
            user.setInterests(resolveUserInterests(userInfoRequestDto.getInterestIds()));

            String newPassword = blankToNull(userInfoRequestDto.getNewPassword());
            if (newPassword != null) {
                user.setPassword(PasswordHasher.hash(newPassword));
            }

            User updatedUser = userRepository.update(user);
            return ResponseFactory.success("Profile updated successfully", userMapper.toDTO(updatedUser));
        });
    }

    private Set<Category> resolveUserInterests(Set<Long> interestIds) {
        Set<Category> resolvedInterests = new LinkedHashSet<>();
        if (interestIds == null || interestIds.isEmpty()) {
            return resolvedInterests;
        }

        for (Long interestId : interestIds) {
            if (interestId == null) {
                continue;
            }

            Optional<Category> categoryOpt = categoryRepository.findById(interestId);
            if (categoryOpt.isEmpty()) {
                throw new IllegalArgumentException("One or more selected interests are invalid");
            }
            resolvedInterests.add(categoryOpt.get());
        }

        return resolvedInterests;
    }

    @Override
    public BaseResponse<UserDTO> updateBalance(Long userId, BigDecimal newBalance) {
        return executeInContext(() -> {
            if (userId == null) {
                return ResponseFactory.failure("Invalid user");
            }

            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isEmpty()) {
                return ResponseFactory.failure("Invalid user");
            }

            User user = userOpt.get();
            user.setCreditLimit(newBalance == null ? BigDecimal.ZERO : newBalance);

            User updatedUser = userRepository.update(user);
            return ResponseFactory.success("Credit limit updated successfully", userMapper.toDTO(updatedUser));
        });
    }

    @Override
    public BaseResponse<Void> deleteUserAddress(Long userId, Long addressId) {
        return executeInContext(() -> {
            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isEmpty()) {
                return ResponseFactory.failure("Invalid user");
            }

            User user = userOpt.get();

            Optional<Address> existingAddress = user.getAddresses()
                    .stream()
                    .filter(addr -> addr.getId().equals(addressId))
                    .findFirst();

            if (existingAddress.isEmpty()) {
                return ResponseFactory.failure("Address not found");
            } else {
                user.removeAddress(existingAddress.get());
            }

            userRepository.update(user);
            return ResponseFactory.success("Address deleted successfully");
        });
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    private String normalizeNullable(String value) {
        if (value == null) {
            return null;
        }

        String normalized = value.trim();
        return normalized.isEmpty() ? null : normalized;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String blankToNull(String value) {
        if (value == null) {
            return null;
        }

        return value.isBlank() ? null : value;
    }

    private String validatePasswordChange(UpdatePersonalInfoRequestDTO request, User user) {
        String currentPassword = blankToNull(request.getCurrentPassword());
        String newPassword = blankToNull(request.getNewPassword());
        String confirmNewPassword = blankToNull(request.getConfirmNewPassword());

        boolean wantsPasswordChange = currentPassword != null || newPassword != null || confirmNewPassword != null;
        if (!wantsPasswordChange) {
            return null;
        }

        if (currentPassword == null) {
            return "Current password is required";
        }
        if (!PasswordHasher.verify(currentPassword, user.getPassword())) {
            return "Current password is incorrect";
        }
        if (newPassword == null) {
            return "New password is required";
        }
        if (confirmNewPassword == null) {
            return "Please confirm the new password";
        }
        if (!newPassword.equals(confirmNewPassword)) {
            return "New passwords do not match";
        }
        if (currentPassword.equals(newPassword)) {
            return "New password must be different from the current password";
        }
        if (newPassword.length() < 8) {
            return "New password must be at least 8 characters long";
        }

        return null;
    }
}
