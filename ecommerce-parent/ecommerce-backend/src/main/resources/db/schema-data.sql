
INSERT INTO categories (name, description) VALUES
('Fiction', 'Imaginary stories including novels and short stories'),
('Non-Fiction', 'Based on real facts and information'),
('Science Fiction', 'Futuristic concepts like space travel and AI'),
('Fantasy', 'Magic, mythical creatures, and imaginary worlds'),
('Mystery', 'Crime solving, detectives, and suspenseful plots'),
('Thriller', 'Fast-paced stories with tension and excitement'),
('Romance', 'Love stories and emotional relationships'),
('Horror', 'Scary stories intended to frighten readers'),
('Biography', 'Life stories of real people'),
('History', 'Books about past events and civilizations'),
('Self-Help', 'Personal development and improvement'),
('Business', 'Entrepreneurship, management, and finance'),
('Technology', 'Programming, AI, and modern tech topics'),
('Philosophy', 'Ideas about existence, knowledge, and ethics'),
('Psychology', 'Human behavior and mental processes'),
('Education', 'Academic and learning materials'),
('Children', 'Books for young readers'),
('Young Adult', 'Books targeted at teenagers'),
('Poetry', 'Collections of poems and verses'),
('Comics', 'Graphic novels and illustrated storytelling');

INSERT INTO authors (name, about) VALUES
('George Orwell', 'English novelist and essayist, critic of totalitarianism'),
('J.K. Rowling', 'British author, creator of the Harry Potter series'),
('Isaac Asimov', 'Science fiction writer and professor of biochemistry'),
('Stephen King', 'American author of horror, supernatural fiction'),
('Agatha Christie', 'Famous mystery writer, creator of Poirot'),
('Yuval Noah Harari', 'Historian and author of Sapiens'),
('Robert Kiyosaki', 'Businessman and author of Rich Dad Poor Dad'),
('Dale Carnegie', 'Pioneer of self-improvement and public speaking'),
('James Clear', 'Author of Atomic Habits'),
('Walter Isaacson', 'Biographer of Steve Jobs and Einstein'),
('Dan Brown', 'Thriller novelist, author of The Da Vinci Code'),
('J.R.R. Tolkien', 'Fantasy writer, author of The Lord of the Rings'),
('Suzanne Collins', 'Author of The Hunger Games'),
('Mark Twain', 'American writer and humorist'),
('Ernest Hemingway', 'Nobel Prize-winning novelist'),
('Malcolm Gladwell', 'Journalist and author of Outliers'),
('Jordan Peterson', 'Psychologist and author'),
('Neil Gaiman', 'Fantasy and comics writer'),
('Stan Lee', 'Marvel Comics legend'),
('Dr. Seuss', 'Children’s book author');

INSERT INTO books
(pages, price, publish_date, sold_quantity, stock_quantity, category_id, isbn, title, book_type, description, image_url, average_rating, rating_count)
VALUES

-- Fiction (1)
(328, 15.99, '1949-06-08', 5000, 120, 1, 'ISBN0001', '1984', 'PAPERBACK', 'Dystopian novel about surveillance and control', NULL, 4.8, 1200),

-- Fantasy (4)
(500, 22.50, '1997-06-26', 10000, 200, 4, 'ISBN0002', 'Harry Potter and the Sorcerer''s Stone', 'HARDCOVER', 'A young wizard begins his journey', NULL, 4.9, 2500),

-- Sci-Fi (3)
(255, 18.75, '1951-01-01', 3000, 80, 3, 'ISBN0003', 'Foundation', 'PAPERBACK', 'Epic science fiction saga of the galaxy', NULL, 4.7, 900),

-- Horror (8)
(400, 19.99, '1986-09-15', 4500, 60, 8, 'ISBN0004', 'It', 'HARDCOVER', 'A terrifying entity haunts children', NULL, 4.6, 1100),

-- Mystery (5)
(320, 14.99, '1920-01-01', 7000, 150, 5, 'ISBN0005', 'The Mysterious Affair at Styles', 'PAPERBACK', 'Detective Hercule Poirot investigates', NULL, 4.5, 800),

-- History (10)
(450, 21.00, '2011-01-01', 6000, 90, 10, 'ISBN0006', 'Sapiens', 'PAPERBACK', 'History of humankind', NULL, 4.8, 2000),

-- Business (12)
(336, 17.99, '1997-04-01', 8000, 110, 12, 'ISBN0007', 'Rich Dad Poor Dad', 'PAPERBACK', 'Financial education and mindset', NULL, 4.4, 1700),

-- Self Help (11)
(288, 16.50, '1936-01-01', 9000, 130, 11, 'ISBN0008', 'How to Win Friends and Influence People', 'PAPERBACK', 'Classic guide to communication', NULL, 4.7, 2100),

-- Psychology (15)
(320, 20.00, '2018-01-01', 7500, 95, 15, 'ISBN0009', 'Atomic Habits', 'PAPERBACK', 'Small habits lead to big results', NULL, 4.9, 3000),

-- Biography (9)
(600, 25.00, '2011-10-24', 5000, 70, 9, 'ISBN0010', 'Steve Jobs', 'HARDCOVER', 'Biography of Apple founder', NULL, 4.6, 1500),

-- Thriller (6)
(380, 18.99, '2003-03-18', 8500, 100, 6, 'ISBN0011', 'The Da Vinci Code', 'PAPERBACK', 'Religious mystery thriller', NULL, 4.5, 1800),

-- Fantasy (4)
(1178, 30.00, '1954-07-29', 12000, 50, 4, 'ISBN0012', 'The Lord of the Rings', 'HARDCOVER', 'Epic fantasy adventure', NULL, 4.9, 4000),

-- Young Adult (18)
(374, 19.99, '2008-09-14', 9500, 140, 18, 'ISBN0013', 'The Hunger Games', 'PAPERBACK', 'Dystopian survival story', NULL, 4.7, 2200),

-- Fiction (1)
(300, 13.99, '1884-01-01', 4000, 60, 1, 'ISBN0014', 'Adventures of Huckleberry Finn', 'PAPERBACK', 'Classic American novel', NULL, 4.3, 600),

-- Fiction (1)
(280, 14.50, '1952-01-01', 3500, 75, 1, 'ISBN0015', 'The Old Man and the Sea', 'PAPERBACK', 'Story of struggle and perseverance', NULL, 4.4, 700),

-- Psychology (15)
(350, 21.99, '2008-11-18', 6200, 85, 15, 'ISBN0016', 'Outliers', 'PAPERBACK', 'Success factors analysis', NULL, 4.5, 1300),

-- Philosophy (14)
(410, 23.50, '2018-01-23', 5000, 65, 14, 'ISBN0017', '12 Rules for Life', 'PAPERBACK', 'Guide to responsibility and meaning', NULL, 4.6, 1400),

-- Comics (20)
(200, 15.00, '1963-03-01', 10000, 200, 20, 'ISBN0018', 'Spider-Man Vol. 1', 'PAPERBACK', 'Marvel superhero comic', NULL, 4.8, 2500),

-- Children (17)
(50, 10.00, '1960-08-12', 8000, 300, 17, 'ISBN0019', 'Green Eggs and Ham', 'PAPERBACK', 'Fun rhyming children story', NULL, 4.9, 3200),

-- Poetry (19)
(120, 12.00, '1855-01-01', 2000, 40, 19, 'ISBN0020', 'Leaves of Grass', 'PAPERBACK', 'Collection of poems', NULL, 4.2, 500);

INSERT INTO reviews (rating, book_id, user_id, created_at, comment) VALUES

-- Book 1
(5, 1, 1, '2024-01-10 10:15:00', 'Amazing and thought-provoking'),
(4, 1, 2, '2024-01-11 12:30:00', 'Very deep and interesting'),
(5, 1, 3, '2024-01-12 14:45:00', 'A masterpiece'),

-- Book 2
(5, 2, 1, '2024-01-13 09:20:00', 'Magical and engaging'),
(5, 2, 2, '2024-01-14 11:10:00', 'Loved every moment'),
(4, 2, 3, '2024-01-15 13:25:00', 'Great start to the series'),

-- Book 3
(4, 3, 1, '2024-01-16 10:00:00', 'Classic sci-fi'),
(5, 3, 2, '2024-01-17 15:40:00', 'Brilliant ideas'),
(4, 3, 3, '2024-01-18 17:50:00', 'Very enjoyable'),

-- Book 4
(5, 4, 1, '2024-01-19 18:00:00', 'Terrifying and gripping'),
(4, 4, 2, '2024-01-20 19:15:00', 'Creepy atmosphere'),
(5, 4, 3, '2024-01-21 20:30:00', 'One of the best horror novels'),

-- Book 5
(4, 5, 1, '2024-01-22 09:45:00', 'Classic mystery'),
(5, 5, 2, '2024-01-23 11:55:00', 'Loved Poirot'),
(4, 5, 3, '2024-01-24 14:05:00', 'Great plot twist'),

-- Book 6
(5, 6, 1, '2024-03-11 09:10:00', 'Excellent depth'),
(3, 6, 2, '2024-03-11 11:20:00', 'A bit heavy'),
(4, 6, 3, '2024-03-11 13:30:00', 'Good overall'),

-- Book 7
(2, 7, 1, '2024-03-12 10:00:00', 'Did not enjoy much'),
(4, 7, 2, '2024-03-12 12:10:00', 'Useful ideas'),
(3, 7, 3, '2024-03-12 14:20:00', 'Average'),

-- Book 8
(5, 8, 1, '2024-03-13 08:45:00', 'Life changing'),
(4, 8, 2, '2024-03-13 10:55:00', 'Very practical'),
(5, 8, 3, '2024-03-13 12:05:00', 'Highly recommended'),

-- Book 9
(5, 9, 1, '2024-03-14 09:15:00', 'Fantastic'),
(4, 9, 2, '2024-03-14 11:25:00', 'Great concepts'),
(2, 9, 3, '2024-03-14 13:35:00', 'Too repetitive'),

-- Book 10
(4, 10, 1, '2024-03-15 15:00:00', 'Solid read'),
(5, 10, 2, '2024-03-15 17:10:00', 'Very inspiring'),
(3, 10, 3, '2024-03-15 19:20:00', 'Decent'),

-- Book 11
(5, 11, 1, '2024-03-16 09:40:00', 'Could not stop reading'),
(4, 11, 2, '2024-03-16 11:50:00', 'Very engaging'),
(3, 11, 3, '2024-03-16 14:00:00', 'Okay story'),

-- Book 12
(5, 12, 1, '2024-03-17 10:10:00', 'Epic'),
(5, 12, 2, '2024-03-17 12:20:00', 'Legendary'),
(4, 12, 3, '2024-03-17 14:30:00', 'Very good'),

-- Book 13
(3, 13, 1, '2024-03-18 09:00:00', 'Slow start'),
(4, 13, 2, '2024-03-18 11:10:00', 'Gets better'),
(5, 13, 3, '2024-03-18 13:20:00', 'Loved it'),

-- Book 14
(2, 14, 1, '2024-03-19 10:30:00', 'Too long'),
(3, 14, 2, '2024-03-19 12:40:00', 'Average read'),
(4, 14, 3, '2024-03-19 14:50:00', 'Nice classic'),

-- Book 15
(5, 15, 1, '2024-03-20 09:15:00', 'Beautiful writing'),
(4, 15, 2, '2024-03-20 11:25:00', 'Emotional'),
(5, 15, 3, '2024-03-20 13:35:00', 'Fantastic'),

-- Book 16
(4, 16, 1, '2024-03-21 08:10:00', 'Good ideas'),
(2, 16, 2, '2024-03-21 10:20:00', 'Not my type'),
(4, 16, 3, '2024-03-21 12:30:00', 'Worth it'),

-- Book 17
(5, 17, 1, '2024-03-22 09:40:00', 'Deep thinking'),
(4, 17, 2, '2024-03-22 11:50:00', 'Very insightful'),
(3, 17, 3, '2024-03-22 14:00:00', 'Okay'),

-- Book 18
(5, 18, 1, '2024-03-23 15:10:00', 'Super fun'),
(5, 18, 2, '2024-03-23 17:20:00', 'Loved it'),
(4, 18, 3, '2024-03-23 19:30:00', 'Entertaining'),

-- Book 19
(4, 19, 1, '2024-03-24 09:00:00', 'Kids enjoyed'),
(5, 19, 2, '2024-03-24 11:10:00', 'Very fun'),
(3, 19, 3, '2024-03-24 13:20:00', 'Good'),

-- Book 20
(2, 20, 1, '2024-03-25 08:30:00', 'Not great'),
(4, 20, 2, '2024-03-25 10:40:00', 'Nice poetry'),
(3, 20, 3, '2024-03-25 12:50:00', 'Okay read');
