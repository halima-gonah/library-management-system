-- Library Management System Database Design

-- Drop database if it exists (for clean setup)
DROP DATABASE IF EXISTS library_management;

-- Create database
CREATE DATABASE library_management;

-- Use the database
USE library_management;

-- Create Members table
CREATE TABLE Members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    address VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    membership_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    membership_status ENUM('Active', 'Expired', 'Suspended') NOT NULL DEFAULT 'Active',
    membership_type ENUM('Standard', 'Premium', 'Student') NOT NULL DEFAULT 'Standard'
);

-- Create Authors table
CREATE TABLE Authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    death_date DATE,
    nationality VARCHAR(50),
    biography TEXT
);

-- Create Publishers table
CREATE TABLE Publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone_number VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100)
);

-- Create Categories table
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    parent_category_id INT,
    description TEXT,
    FOREIGN KEY (parent_category_id) REFERENCES Categories(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Create Books table
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    publisher_id INT,
    publication_date DATE,
    edition VARCHAR(50),
    language VARCHAR(50) DEFAULT 'English',
    page_count INT,
    description TEXT,
    cover_image_url VARCHAR(255),
    FOREIGN KEY (publisher_id) REFERENCES Publishers(publisher_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Create BookCategories table (Many-to-Many relationship between Books and Categories)
CREATE TABLE BookCategories (
    book_id INT,
    category_id INT,
    PRIMARY KEY (book_id, category_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create BookAuthors table (Many-to-Many relationship between Books and Authors)
CREATE TABLE BookAuthors (
    book_id INT,
    author_id INT,
    role ENUM('Primary', 'Co-author', 'Editor', 'Translator') DEFAULT 'Primary',
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create BookCopies table to track individual copies of books
CREATE TABLE BookCopies (
    copy_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    barcode VARCHAR(50) UNIQUE NOT NULL,
    acquisition_date DATE NOT NULL,
    price DECIMAL(10, 2),
    status ENUM('Available', 'Checked Out', 'Reserved', 'In Repair', 'Lost', 'Retired') NOT NULL DEFAULT 'Available',
    condition ENUM('New', 'Good', 'Fair', 'Poor') NOT NULL DEFAULT 'New',
    location VARCHAR(50),
    notes TEXT,
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create Loans table to track book borrowing
CREATE TABLE Loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    copy_id INT NOT NULL,
    member_id INT NOT NULL,
    checkout_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date DATE NOT NULL,
    return_date DATETIME,
    renewal_count INT DEFAULT 0,
    fine_amount DECIMAL(10, 2) DEFAULT 0.00,
    fine_paid BOOLEAN DEFAULT FALSE,
    staff_id_checkout INT,
    staff_id_return INT,
    FOREIGN KEY (copy_id) REFERENCES BookCopies(copy_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create Reservations table
CREATE TABLE Reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expiration_date DATE NOT NULL,
    status ENUM('Pending', 'Fulfilled', 'Cancelled', 'Expired') NOT NULL DEFAULT 'Pending',
    notification_sent BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Create Staff table
CREATE TABLE Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    is_admin BOOLEAN DEFAULT FALSE
);

-- Create Fines table
CREATE TABLE Fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    reason TEXT NOT NULL,
    date_issued DATE NOT NULL DEFAULT (CURRENT_DATE),
    date_paid DATE,
    payment_method VARCHAR(50),
    staff_id INT,
    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Create Events table for library events
CREATE TABLE Events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    start_datetime DATETIME NOT NULL,
    end_datetime DATETIME NOT NULL,
    location VARCHAR(100),
    max_attendees INT,
    event_type VARCHAR(50),
    is_public BOOLEAN DEFAULT TRUE,
    staff_id INT,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Create EventAttendees table (Many-to-Many relationship between Events and Members)
CREATE TABLE EventAttendees (
    event_id INT,
    member_id INT,
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    attended BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (event_id, member_id),
    FOREIGN KEY (event_id) REFERENCES Events(event_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Test Data for Library Management System

USE library_management;

-- Insert data into Members table
INSERT INTO Members (first_name, last_name, email, phone_number, address, date_of_birth, membership_date, membership_status, membership_type) VALUES
('John', 'Smith', 'john.smith@email.com', '555-123-4567', '123 Main St, Anytown, AN 12345', '1985-06-15', '2023-01-10', 'Active', 'Standard'),
('Emma', 'Johnson', 'emma.j@email.com', '555-234-5678', '456 Oak Ave, Somecity, SC 23456', '1992-09-22', '2023-02-15', 'Active', 'Premium'),
('Michael', 'Brown', 'mbrown@email.com', '555-345-6789', '789 Pine Rd, Otherville, OV 34567', '1978-03-30', '2023-03-05', 'Active', 'Standard'),
('Sophia', 'Garcia', 'sgarcia@email.com', '555-456-7890', '101 Cedar Ln, Newtown, NT 45678', '2000-11-18', '2023-04-20', 'Active', 'Student'),
('William', 'Davis', 'wdavis@email.com', '555-567-8901', '202 Maple Dr, Oldcity, OC 56789', '1965-07-12', '2023-05-15', 'Expired', 'Standard');

-- Insert data into Authors table
INSERT INTO Authors (first_name, last_name, birth_date, death_date, nationality, biography) VALUES
('Jane', 'Austen', '1775-12-16', '1817-07-18', 'British', 'English novelist known primarily for her six major novels'),
('F. Scott', 'Fitzgerald', '1896-09-24', '1940-12-21', 'American', 'American novelist, essayist, and short story writer'),
('Gabriel', 'García Márquez', '1927-03-06', '2014-04-17', 'Colombian', 'Colombian novelist and Nobel Prize winner'),
('Chimamanda', 'Ngozi Adichie', '1977-09-15', NULL, 'Nigerian', 'Nigerian writer of novels, short stories, and nonfiction'),
('Haruki', 'Murakami', '1949-01-12', NULL, 'Japanese', 'Japanese writer of surrealist fiction and magical realism');

-- Insert data into Publishers table
INSERT INTO Publishers (name, address, phone_number, email, website) VALUES
('Penguin Random House', '1745 Broadway, New York, NY 10019', '212-782-9000', 'info@penguinrandomhouse.com', 'www.penguinrandomhouse.com'),
('HarperCollins', '195 Broadway, New York, NY 10007', '212-207-7000', 'info@harpercollins.com', 'www.harpercollins.com'),
('Simon & Schuster', '1230 Avenue of the Americas, New York, NY 10020', '212-698-7000', 'info@simonandschuster.com', 'www.simonandschuster.com'),
('Macmillan Publishers', '120 Broadway, New York, NY 10271', '646-307-5151', 'info@macmillan.com', 'www.macmillan.com'),
('Oxford University Press', 'Great Clarendon Street, Oxford OX2 6DP, UK', '+44-1865-353535', 'info@oup.com', 'www.oup.com');

-- Insert data into Categories table
INSERT INTO Categories (name, parent_category_id, description) VALUES
('Fiction', NULL, 'Literary works created from the imagination'),
('Non-Fiction', NULL, 'Writing that is based on facts, real events, and real people'),
('Science Fiction', 1, 'Fiction based on scientific discoveries or advanced technology'),
('Mystery', 1, 'Fiction focused on solving a crime or puzzle'),
('Biography', 2, 'Non-fiction account of a person\'s life');

-- Insert data into Books table
INSERT INTO Books (isbn, title, publisher_id, publication_date, edition, language, page_count, description) VALUES
('9780141439518', 'Pride and Prejudice', 1, '1813-01-28', 'Penguin Classics', 'English', 432, 'A romantic novel of manners by Jane Austen'),
('9780743273565', 'The Great Gatsby', 3, '1925-04-10', 'Scribner', 'English', 180, 'A novel by American writer F. Scott Fitzgerald'),
('9780060883287', 'One Hundred Years of Solitude', 2, '1967-05-30', 'Harper Perennial', 'English', 417, 'A landmark of magical realism'),
('9780307455925', 'Half of a Yellow Sun', 4, '2006-09-12', 'Anchor', 'English', 543, 'A novel set during the Biafran War'),
('9780307476463', 'Kafka on the Shore', 1, '2002-09-12', 'Vintage International', 'English', 505, 'A metaphysical journey by Haruki Murakami');

-- Insert data into BookCategories table
INSERT INTO BookCategories (book_id, category_id) VALUES
(1, 1), -- Pride and Prejudice - Fiction
(2, 1), -- The Great Gatsby - Fiction
(3, 1), -- One Hundred Years of Solitude - Fiction
(3, 3), -- One Hundred Years of Solitude - Science Fiction
(4, 1), -- Half of a Yellow Sun - Fiction
(5, 1), -- Kafka on the Shore - Fiction
(5, 3); -- Kafka on the Shore - Science Fiction

-- Insert data into BookAuthors table
INSERT INTO BookAuthors (book_id, author_id, role) VALUES
(1, 1, 'Primary'), -- Pride and Prejudice - Jane Austen
(2, 2, 'Primary'), -- The Great Gatsby - F. Scott Fitzgerald
(3, 3, 'Primary'), -- One Hundred Years of Solitude - Gabriel García Márquez
(4, 4, 'Primary'), -- Half of a Yellow Sun - Chimamanda Ngozi Adichie
(5, 5, 'Primary'); -- Kafka on the Shore - Haruki Murakami

-- Insert data into BookCopies table
INSERT INTO BookCopies (book_id, barcode, acquisition_date, price, status, condition, location) VALUES
(1, 'LIB-PP-001', '2022-01-15', 12.99, 'Available', 'Good', 'Fiction Section - Shelf A1'),
(1, 'LIB-PP-002', '2022-01-15', 12.99, 'Checked Out', 'Good', 'Fiction Section - Shelf A1'),
(2, 'LIB-GG-001', '2022-02-20', 10.99, 'Available', 'Good', 'Fiction Section - Shelf B2'),
(3, 'LIB-100S-001', '2022-03-10', 15.99, 'In Repair', 'Fair', 'Fiction Section - Shelf C3'),
(4, 'LIB-HYS-001', '2022-04-05', 14.99, 'Available', 'New', 'Fiction Section - Shelf D4'),
(5, 'LIB-KOS-001', '2022-05-12', 13.99, 'Checked Out', 'Good', 'Fiction Section - Shelf E5');

-- Insert data into Staff table
INSERT INTO Staff (first_name, last_name, email, phone_number, position, hire_date, username, password_hash, is_admin) VALUES
('Robert', 'Wilson', 'rwilson@library.org', '555-789-0123', 'Chief Librarian', '2020-06-01', 'rwilson', 'hashed_password_1', TRUE),
('Sarah', 'Martinez', 'smartinez@library.org', '555-890-1234', 'Librarian', '2021-03-15', 'smartinez', 'hashed_password_2', FALSE),
('David', 'Thompson', 'dthompson@library.org', '555-901-2345', 'Assistant Librarian', '2022-01-10', 'dthompson', 'hashed_password_3', FALSE);

-- Insert data into Loans table
INSERT INTO Loans (copy_id, member_id, checkout_date, due_date, return_date, staff_id_checkout) VALUES
(2, 1, '2023-06-01 14:30:00', '2023-06-15', NULL, 2),
(6, 2, '2023-06-05 10:15:00', '2023-06-19', NULL, 3);

-- Insert data into Reservations table
INSERT INTO Reservations (book_id, member_id, reservation_date, expiration_date, status) VALUES
(3, 3, '2023-06-07 09:45:00', '2023-06-21', 'Pending'),
(4, 4, '2023-06-08 16:20:00', '2023-06-22', 'Pending');

-- Insert data into Fines table
INSERT INTO Fines (loan_id, amount, reason, date_issued, staff_id) VALUES
(1, 5.00, 'Overdue by 5 days', '2023-06-20', 1);

-- Insert data into Events table
INSERT INTO Events (title, description, start_datetime, end_datetime, location, max_attendees, event_type, staff_id) VALUES
('Summer Reading Club', 'Join our summer reading program for all ages', '2023-07-01 10:00:00', '2023-07-01 12:00:00', 'Main Reading Room', 50, 'Reading Club', 1),
('Author Meet & Greet', 'Meet local authors and discuss their works', '2023-07-15 14:00:00', '2023-07-15 16:00:00', 'Conference Room A', 30, 'Special Event', 2);

-- Insert data into EventAttendees table
INSERT INTO EventAttendees (event_id, member_id, registration_date) VALUES
(1, 1, '2023-06-10 11:30:00'),
(1, 2, '2023-06-11 14:45:00'),
(2, 3, '2023-06-12 10:20:00');