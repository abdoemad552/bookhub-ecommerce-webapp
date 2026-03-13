package com.iti.jets.service.factory;

import com.iti.jets.mapper.UserMapper;
import com.iti.jets.repository.implementation.CategoryRepositoryImpl;
import com.iti.jets.repository.implementation.UserRepositoryImpl;
import com.iti.jets.repository.interfaces.CategoryRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import com.iti.jets.service.implementation.AuthServiceImpl;
import com.iti.jets.service.implementation.UserServiceImpl;
import com.iti.jets.service.interfaces.AuthService;
import com.iti.jets.service.interfaces.UserService;


public class ServiceFactory {

    private static volatile ServiceFactory instance;

    // Repository
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;

    // Service
    private final AuthService authService;
    private final UserService userService;

    private ServiceFactory() {
        // Repository
        this.userRepository = new UserRepositoryImpl();
        this.categoryRepository = new CategoryRepositoryImpl();

        // Service
        this.authService = new AuthServiceImpl(userRepository, categoryRepository, UserMapper.getInstance());
        this.userService = new UserServiceImpl(userRepository, categoryRepository, UserMapper.getInstance());
    }

    public static ServiceFactory getInstance() {
        if (instance == null) {
            synchronized (ServiceFactory.class) {
                if (instance == null) {
                    instance = new ServiceFactory();
                }
            }
        }
        return instance;
    }

    public AuthService getAuthService() {
        return authService;
    }

    public UserService getUserService() {
        return userService;
    }
}