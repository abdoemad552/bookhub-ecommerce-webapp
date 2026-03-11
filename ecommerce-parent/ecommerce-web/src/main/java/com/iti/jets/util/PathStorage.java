package com.iti.jets.util;

public class PathStorage {

    // User Pages
    public static final String LOGIN_PAGE       = "/WEB-INF/views/login/login.jsp";
    public static final String SING_UP_PAGE     = "/WEB-INF/views/signup/signup.jsp";
    public static final String HOME_PAGE        = "/WEB-INF/views/home/home.jsp";
    public static final String PROFILE_PAGE     = "/WEB-INF/views/profile/profile.jsp";
    public static final String EXPLORE_PAGE     = "/WEB-INF/views/explore/explore.jsp";
    public static final String CART_PAGE        = "/WEB-INF/views/cart/cart.jsp";

    // Inner Components
    public static final String BOOK_CARD    = "/WEB-INF/views/common/book-card.jsp";
    public static final String HEADER       = "/WEB-INF/views/common/header.jsp";
    public static final String FOOTER       = "/WEB-INF/views/common/footer.jsp";

    // Admin Pages
    public static final String ADMIN_DASHBOARD_PAGE = "/WEB-INF/views/admin/dashboard/dashboard.jsp";

    // Servlet Mapping
    public static final String LOGIN_SERVLET = "login";
    public static final String SIGNUP_SERVLET = "signup";
    public static final String PROFILE_SERVLET = "profile";
    public static final String ADMIN_DASHBOARD_SERVLET = "admin/dashboard";
}
