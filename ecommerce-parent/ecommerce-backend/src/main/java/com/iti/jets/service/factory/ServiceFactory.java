package com.iti.jets.service.factory;

import com.iti.jets.mapper.CartMapper;
import com.iti.jets.mapper.CategoryMapper;
import com.iti.jets.mapper.UserMapper;
import com.iti.jets.repository.implementation.*;
import com.iti.jets.repository.interfaces.*;
import com.iti.jets.service.extra.EmailService;
import com.iti.jets.service.implementation.*;
import com.iti.jets.service.interfaces.*;


public class ServiceFactory {

    private static volatile ServiceFactory instance;

    // Repository
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final BookRepository bookRepository;
    private final ReviewRepository reviewRepository;
    private final WishlistRepository wishlistRepository;
    private final CartRepository cartRepository;
    private final OrderRepository orderRepository;

    // Service
    private final AuthService authService;
    private final UserService userService;
    private final CategoryService categoryService;
    private final BookService bookService;
    private final ReviewService reviewService;
    private final WishlistService wishlistService;
    private final CartService cartService;
    private final OrderService orderService;

    // Extra Services
    private final EmailService emailService;

    private ServiceFactory() {
        // Repository
        this.userRepository = new UserRepositoryImpl();
        this.categoryRepository = new CategoryRepositoryImpl();
        this.bookRepository = new BookRepositoryImpl();
        this.reviewRepository = new ReviewRepositoryImpl();
        this.wishlistRepository = new WishlistRepositoryImpl();
        this.cartRepository = new CartRepositoryImpl();
        this.orderRepository = new OrderRepositoryImpl();

        // Service
        this.authService = new AuthServiceImpl(userRepository, categoryRepository, UserMapper.getInstance());
        this.userService = new UserServiceImpl(userRepository, categoryRepository, UserMapper.getInstance());
        this.categoryService = new CategoryServiceImpl(categoryRepository, CategoryMapper.getInstance());
        this.bookService = new BookServiceImpl(bookRepository);
        this.reviewService = new ReviewServiceImpl(reviewRepository, userRepository, bookRepository);
        this.wishlistService = new WishlistServiceImpl(wishlistRepository, userRepository, bookRepository);
        this.cartService = new CartServiceImpl(cartRepository, bookRepository, CartMapper.getInstance());
        this.orderService = new OrderServiceImpl(orderRepository, userRepository, bookRepository, cartRepository);

        // Extra Services
        this.emailService = new EmailService();
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

    public CategoryService getCategoryService() {
        return categoryService;
    }

    public BookService getBookService() {
        return bookService;
    }

    public ReviewService getReviewService() {
        return reviewService;
    }

    public WishlistService getWishlistService() {
        return wishlistService;
    }

    public CartService getCartService() {
        return cartService;
    }

    public EmailService getEmailService() {
        return emailService;
    }

    public OrderService getOrderService() {
        return orderService;
    }
}