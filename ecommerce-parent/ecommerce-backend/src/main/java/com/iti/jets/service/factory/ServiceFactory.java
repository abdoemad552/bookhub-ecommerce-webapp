package com.iti.jets.service.factory;

import com.iti.jets.mapper.CategoryMapper;
import com.iti.jets.mapper.UserMapper;
import com.iti.jets.repository.implementation.BookRepositoryImpl;
import com.iti.jets.repository.implementation.CartRepositoryImpl;
import com.iti.jets.repository.implementation.CategoryRepositoryImpl;
import com.iti.jets.repository.implementation.ReviewRepositoryImpl;
import com.iti.jets.repository.implementation.UserRepositoryImpl;
import com.iti.jets.repository.implementation.WishlistRepositoryImpl;
import com.iti.jets.repository.interfaces.BookRepository;
import com.iti.jets.repository.interfaces.CartRepository;
import com.iti.jets.repository.interfaces.CategoryRepository;
import com.iti.jets.repository.interfaces.ReviewRepository;
import com.iti.jets.repository.interfaces.UserRepository;
import com.iti.jets.repository.interfaces.WishlistRepository;
import com.iti.jets.service.implementation.AuthServiceImpl;
import com.iti.jets.service.implementation.BookServiceImpl;
import com.iti.jets.service.implementation.CartServiceImpl;
import com.iti.jets.service.implementation.CategoryServiceImpl;
import com.iti.jets.service.implementation.ReviewServiceImpl;
import com.iti.jets.service.implementation.UserServiceImpl;
import com.iti.jets.service.implementation.WishlistServiceImpl;
import com.iti.jets.service.interfaces.AuthService;
import com.iti.jets.service.interfaces.BookService;
import com.iti.jets.service.interfaces.CartService;
import com.iti.jets.service.interfaces.CategoryService;
import com.iti.jets.service.interfaces.ReviewService;
import com.iti.jets.service.interfaces.UserService;
import com.iti.jets.service.interfaces.WishlistService;


public class ServiceFactory {

    private static volatile ServiceFactory instance;

    // Repository
    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final BookRepository bookRepository;
    private final ReviewRepository reviewRepository;
    private final WishlistRepository wishlistRepository;
    private final CartRepository cartRepository;

    // Service
    private final AuthService authService;
    private final UserService userService;
    private final CategoryService categoryService;
    private final BookService bookService;
    private final ReviewService reviewService;
    private final WishlistService wishlistService;
    private final CartService cartService;

    private ServiceFactory() {
        // Repository
        this.userRepository = new UserRepositoryImpl();
        this.categoryRepository = new CategoryRepositoryImpl();
        this.bookRepository = new BookRepositoryImpl();
        this.reviewRepository = new ReviewRepositoryImpl();
        this.wishlistRepository = new WishlistRepositoryImpl();
        this.cartRepository = new CartRepositoryImpl();

        // Service
        this.authService = new AuthServiceImpl(userRepository, categoryRepository, UserMapper.getInstance());
        this.userService = new UserServiceImpl(userRepository, categoryRepository, UserMapper.getInstance());
        this.categoryService = new CategoryServiceImpl(categoryRepository, CategoryMapper.getInstance());
        this.bookService = new BookServiceImpl(bookRepository);
        this.reviewService = new ReviewServiceImpl(reviewRepository, userRepository, bookRepository);
        this.wishlistService = new WishlistServiceImpl(wishlistRepository, userRepository, bookRepository);
        this.cartService = new CartServiceImpl(cartRepository);
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
}
