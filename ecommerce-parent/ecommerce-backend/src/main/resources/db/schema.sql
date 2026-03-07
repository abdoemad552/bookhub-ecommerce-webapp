CREATE TABLE users
(
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    username            VARCHAR(50)    NOT NULL UNIQUE,
    email               VARCHAR(100)   NOT NULL UNIQUE,
    password            VARCHAR(255)   NOT NULL,
    first_name          VARCHAR(50),
    last_name           VARCHAR(50),
    role                ENUM('ADMIN','USER') NOT NULL DEFAULT 'USER',
    profile_pic_url     TEXT,
    birth_date          DATE,
    job                 VARCHAR(100),
    credit_limit        DECIMAL(10, 2) NOT NULL DEFAULT 0.00 CHECK (credit_limit >= 0),
    email_notifications BOOLEAN        NOT NULL DEFAULT FALSE
);

CREATE TABLE categories
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE books
(
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    title          VARCHAR(255)   NOT NULL,
    description    TEXT,
    price          DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock_quantity INT            NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    publish_date   DATE,
    image_url      TEXT,
    isbn           VARCHAR(20)    NOT NULL UNIQUE,
    category_id    BIGINT,
    book_type      ENUM('PAPERBACK','HARDCOVER','EBOOK') NOT NULL DEFAULT 'PAPERBACK',
    pages          INT CHECK (pages > 0),
    sold_quantity  INT,

    FOREIGN KEY (category_id) REFERENCES categories (id)
        ON DELETE SET NULL
);

CREATE TABLE carts
(
    id      BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNIQUE,

    FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE
);

CREATE TABLE addresses
(
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id      BIGINT       NOT NULL,
    address_type ENUM('HOME','WORK','SHIPPING','BILLING') DEFAULT 'SHIPPING',
    government   VARCHAR(50)  NOT NULL,
    city         VARCHAR(50)  NOT NULL,
    street       VARCHAR(100) NOT NULL,
    building_no  VARCHAR(20)  NOT NULL,
    description  VARCHAR(255),

    FOREIGN KEY (user_id)
        REFERENCES users (id)
        ON DELETE CASCADE
);

CREATE TABLE orders
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT,
    total_price DECIMAL(10, 2) NOT NULL CHECK (total_price >= 0),
    status      ENUM('PENDING','PAID','CANCELLED','SHIPPED','DELIVERED') NOT NULL DEFAULT 'PENDING',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE
);

CREATE TABLE offers
(
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    book_id          BIGINT   NOT NULL,
    discount_percent DECIMAL(5, 2) CHECK (discount_percent > 0),
    start_date       DATETIME NOT NULL,
    end_date         DATETIME NOT NULL,
    active           BOOLEAN DEFAULT TRUE,

    FOREIGN KEY (book_id)
        REFERENCES books (id)
        ON DELETE CASCADE
);

CREATE TABLE cart_items
(
    cart_id  BIGINT,
    book_id  BIGINT,
    quantity INT NOT NULL CHECK (quantity > 0),

    PRIMARY KEY (cart_id, book_id),

    FOREIGN KEY (cart_id) REFERENCES carts (id)
        ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books (id)
        ON DELETE CASCADE
);

CREATE TABLE order_items
(
    order_id      BIGINT,
    book_id       BIGINT,
    quantity      INT            NOT NULL CHECK (quantity > 0),
    current_price DECIMAL(10, 2) NOT NULL CHECK (current_price >= 0),

    PRIMARY KEY (order_id, book_id),

    FOREIGN KEY (order_id) REFERENCES orders (id)
        ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books (id)
        ON DELETE CASCADE
);

CREATE TABLE reviews
(
    user_id    BIGINT,
    book_id    BIGINT,
    rating     INT CHECK (rating BETWEEN 1 AND 5),
    comment    TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id, book_id),

    FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books (id)
        ON DELETE CASCADE
);

CREATE TABLE wishlists
(
    user_id BIGINT,
    book_id BIGINT,

    PRIMARY KEY (user_id, book_id),

    FOREIGN KEY (user_id) REFERENCES users (id)
        ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books (id)
        ON DELETE CASCADE
);

CREATE TABLE tags
(
    id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE authors
(
    id    BIGINT AUTO_INCREMENT PRIMARY KEY,
    name  VARCHAR(100) NOT NULL,
    about TEXT
);

CREATE TABLE book_authors
(
    book_id   BIGINT,
    author_id BIGINT,

    PRIMARY KEY (book_id, author_id),

    FOREIGN KEY (book_id) REFERENCES books (id)
        ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors (id)
        ON DELETE CASCADE
);

CREATE TABLE book_tags
(
    book_id BIGINT,
    tag_id  BIGINT,

    PRIMARY KEY (book_id, tag_id),

    FOREIGN KEY (book_id) REFERENCES books (id)
        ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags (id)
        ON DELETE CASCADE
);

CREATE TABLE user_tags
(
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id     BIGINT       NOT NULL,
    name        VARCHAR(100) NOT NULL,
    description TEXT,

    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE user_book_tags
(
    user_tag_id BIGINT,
    book_id     BIGINT,
    PRIMARY KEY (user_tag_id, book_id),

    FOREIGN KEY (user_tag_id) REFERENCES user_tags (id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books (id) ON DELETE CASCADE
);

-- Books Table
CREATE INDEX idx_books_category ON books (category_id);
CREATE INDEX idx_books_title ON books (title);
CREATE INDEX idx_books_price ON books (price);
CREATE INDEX idx_books_publish_date ON books (publish_date);

-- Orders Table
CREATE INDEX idx_orders_user ON orders (user_id);

-- Carts Table
CREATE INDEX idx_cart_user ON carts (user_id);

-- Cart Items Table
CREATE INDEX idx_cart_items_cart ON cart_items (cart_id);
CREATE INDEX idx_cart_items_book ON cart_items (book_id);

-- Order Items Table
CREATE INDEX idx_order_items_order ON order_items (order_id);
CREATE INDEX idx_order_items_book ON order_items (book_id);

-- Reviews Table
CREATE INDEX idx_reviews_book ON reviews (book_id);
CREATE INDEX idx_reviews_book_created_at ON reviews (book_id, created_at);

-- Wishlists Table
CREATE INDEX idx_wishlists_user ON wishlists (user_id);
CREATE INDEX idx_wishlists_book ON wishlists (book_id);

-- Tags Table
CREATE INDEX idx_tags_name ON tags (name);
CREATE INDEX idx_book_tags_tag_book ON book_tags (tag_id, book_id);

-- Address Table
CREATE INDEX idx_addresses_user ON addresses(user_id);

-- Authors Table
CREATE INDEX idx_authors_name ON authors (name);
CREATE INDEX idx_book_authors_author_book ON book_authors (author_id, book_id);

-- User Tags Table
CREATE INDEX idx_user_tags_user ON user_tags (user_id);
CREATE INDEX idx_user_book_tags_user_tag ON user_book_tags (user_tag_id);
CREATE INDEX idx_user_book_tags_book ON user_book_tags (book_id);

-- Offers Table
CREATE INDEX idx_offers_product ON offers (book_id);
CREATE INDEX idx_offers_active ON offers (active);