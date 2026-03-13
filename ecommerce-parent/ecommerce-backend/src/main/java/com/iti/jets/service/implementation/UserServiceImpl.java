package com.iti.jets.service.implementation;

import com.iti.jets.mapper.UserMapper;
import com.iti.jets.model.dto.response.UserDTO;
import com.iti.jets.repository.interfaces.CategoryRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import com.iti.jets.service.interfaces.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;

public class UserServiceImpl implements UserService {

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
    public UserDTO findById(Long aLong) {
        return null;
    }

    @Override
    public List<UserDTO> findAll() {
        return List.of();
    }

    @Override
    public List<UserDTO> findAll(int pageNumber, int pageSize) {
        return List.of();
    }

    @Override
    public void delete(Long aLong) {

    }

    @Override
    public long count() {
        return 0;
    }

    @Override
    public boolean existsById(Long aLong) {
        return false;
    }
}
