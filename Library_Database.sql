-- This is a library database. It has 4 tables.
-- Table 1 has the data of all the library books.
-- Table 2 has the data of all the people who can borrow books.
-- Table 3 has the data of which books are currently on loan.
-- Table 4 has the data of all the overdue books.

CREATE DATABASE Library;
USE Library;

CREATE TABLE library_books
	(book_id INT NOT NULL PRIMARY KEY, book_name VARCHAR(50) NOT NULL, author VARCHAR(50) NOT NULL, book_condition VARCHAR(50) DEFAULT "Good");
    
CREATE TABLE books_borrowed
	(book_id INT REFERENCES library_books(book_id), borrow_start_date DATE NOT NULL, expected_return_date DATE NOT NULL, borrower_id INT NOT NULL REFERENCES borrower_details(borrower_id), overdue_y_or_n VARCHAR(1) DEFAULT "n");
    
CREATE TABLE overdue_books
	(book_id INT REFERENCES library_books(book_id), borrower_id INT REFERENCES borrower_details(borrower_id), days_overdue INT NOT NULL, fine DECIMAL(4,2));
    
CREATE TABLE borrower_details
	(borrower_id INT NOT NULL PRIMARY KEY, first_name VARCHAR(50) NOT NULL, last_name VARCHAR(50) NOT NULL, email_address VARCHAR(150), phone_number VARCHAR(11), address VARCHAR(200) NOT NULL);

INSERT INTO library_books
	(book_id, book_name, author, book_condition)
VALUES
	(1, "Deja Dead", "Kathy Reichs", DEFAULT),
    (2, "Death du Jour", "Kathy Reichs", DEFAULT),
    (3, "Deadly Decisions", "Kathy Reichs", DEFAULT),
    (4, "Fatal Voyage", "Kathy Reichs", DEFAULT),
    (5, "Grave Secrets", "Kathy Reichs", "Used"),
    (6, "Bare Bones", "Kathy Reichs", DEFAULT),
    (7, "Monday Mourning", "Kathy Reichs", DEFAULT),
    (8, "Break No Bones", "Kathy Reichs", DEFAULT),
    (9, "Bones to Ashes", "Kathy Reichs", "Needs replacing"),
    (10, "Devil Bones", "Kathy Reichs", DEFAULT),
    (11, "206 Bones", "Kathy Reichs", DEFAULT),
    (12, "Spider Bones", "Kathy Reichs", DEFAULT),
    (13, "Flash and Bones", "Kathy Reichs", "New"),
    (14, "Bones are Forever", "Kathy Reichs", DEFAULT),
    (15, "Bones in Her Pocket", "Kathy Reichs", DEFAULT),
    (16, "Bones of the Lost", "Kathy Reichs", DEFAULT),
    (17, "Swamp Bones", "Kathy Reichs", DEFAULT),
    (18, "Thursday Murder Club", "Richard Osman", "Needs replacing"),
    (19, "The Man Who Died Twice", "Richard Osman", "Used"),
    (20, "The Bullet That Missed", "Richard Osman", DEFAULT),
    (21, "The Last Devil to Die", "Richard Osman", DEFAULT);
    
INSERT INTO books_borrowed
	(book_id, borrow_start_date, expected_return_date, borrower_id, overdue_y_or_n)
VALUES
	(5, "2024-05-07", "2024-05-21", 106, "y"),
	(10, "2024-05-16", "2024-05-30", 104, "y"),
	(6, "2024-05-18", "2024-06-01", 101, "y"),
	(2, "2024-05-19", "2024-06-02", 108, "y"),
	(7, "2024-05-21", "2024-06-04", 105, "y"),
	(11, "2024-05-22", "2024-06-05", 102, "y"),
	(21, "2024-05-23", "2024-06-06", 109, "y"),
	(20, "2024-05-25", "2024-06-08", 103, "y"),
	(3, "2024-06-29", "2024-06-12", 109, DEFAULT),
	(14, "2024-06-03", "2024-06-17", 102, DEFAULT),
	(18, "2024-06-04", "2024-06-18", 101, DEFAULT),
	(13, "2024-06-06", "2024-06-20", 107, DEFAULT),
	(12, "2024-06-07", "2024-06-21", 102, DEFAULT),
	(17, "2024-06-08", "2024-06-22", 108, DEFAULT),
	(18, "2024-06-09", "2024-06-23", 103, DEFAULT),
	(19, "2024-06-09", "2024-06-23", 101, DEFAULT),
	(15, "2024-06-10", "2024-06-24", 108, DEFAULT),
	(4, "2024-06-11", "2024-06-25", 104, DEFAULT),
	(1, "2024-06-12", "2024-06-26", 105, DEFAULT);

INSERT INTO borrower_details
	(borrower_id, first_name, last_name, email_address, phone_number, address)
VALUES
    (101, "Laura", "Cliff", "l.cliff@hotmail.com", "07122896439", "3 Main Street, Belper, Derbyshire, DE56 2LD"),
	(102, "Lucy", "Smith", "l.smith.1994@hotmail.com", NULL, "9 Alder Lane, Belper, Derbyshire, DE56 2AA"),
	(103, "Martha", "James", "marthaj@hotmail.com", "07493564283", "32 Johnson Way, Belper, Derbyshire, DE56 9KW"),
	(104, "John", "Haroldson", "jharoldson65@hotmail.com", "07452387451", "54 Alder Lane, Belper, Derbyshire, DE56 7DW"),
	(105, "James", "Prince", "princejames96@hotmail.com", NULL, "90 Franklin Way, Belper, Derbyshire, DE56 1LF"),
	(106, "Alex", "Field", "afield@hotmail.com", "07483921234", "10 Longacre Road, Belper, Derbyshire, DE56 3GD"),
	(107, "Felicity", "Laurel", NULL, "07382998543", "15 Lord's Lane, Belper, Derbyshire, DE56 5KL"),
	(108, "Ethel", "Munroe", "munroe.ethel@hotmail.com", "07465748392", "83 Lauder Way, Belper, Derbyshire, DE56 9OL"),
	(109, "Maureen", "Davey", "maureend@hotmail.com", NULL, "38 Main Street, Belper, Derbyshire, DE56 5DF");


INSERT INTO overdue_books
	(book_id, borrower_id, days_overdue, fine)
VALUES
	(5, 106, 23, 11.50),
    (10, 104, 14, 7.00),      
    (6, 101, 12, 6.00),
    (2, 108, 11, 5.50),
    (7, 105, 9, 4.50),
    (11, 102, 8, 4.00),
    (21, 109, 7, 3.50),
    (20, 103, 6, 3.00);

SELECT * FROM books_borrowed;
SELECT * FROM borrower_details;
SELECT * FROM library_books;
SELECT * FROM overdue_books;
 
-- Add a unique value to borrower details
ALTER TABLE borrower_details
ADD UNIQUE (email_address);