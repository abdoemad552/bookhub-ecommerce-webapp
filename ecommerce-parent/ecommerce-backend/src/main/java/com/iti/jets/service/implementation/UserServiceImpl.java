package com.iti.jets.service.implementation;

import com.iti.jets.mapper.UserMapper;
import com.iti.jets.model.dto.request.AddressRequestDTO;
import com.iti.jets.model.dto.response.CartDTO;
import com.iti.jets.model.dto.response.UserAddressesDTO;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.model.dto.response.factory.BaseResponse;
import com.iti.jets.model.dto.response.factory.ResponseFactory;
import com.iti.jets.model.entity.Address;
import com.iti.jets.model.entity.User;
import com.iti.jets.repository.interfaces.CategoryRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import com.iti.jets.service.generic.ContextHandler;
import com.iti.jets.service.interfaces.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

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
}