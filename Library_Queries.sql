USE Library;

-- Updating a borrower's email address
UPDATE borrower_details SET email_address = "laura.cliff3@hotmail.com" WHERE first_name = "Laura";

-- A borrower would like to find which books the Library has by Richard Osman
SELECT book_id, book_name FROM library_books WHERE author = "Richard Osman" ORDER BY book_id;

-- Finding which books need replacing due to their condition
SELECT book_id, book_name, author FROM library_books WHERE book_condition = "Needs Replacing" GROUP BY book_id;

-- Adding a new book to the library
INSERT INTO library_books 
	(book_id, book_name, author, book_condition)
VALUES 
	(22, "To Kill a Mockingbird", "Fred Bloggs", "New");

select * from library_books;

-- The librarian realised she put the wrong author name in for To Kill a Mockingbird!
UPDATE library_books
SET author = "Harper Lee"
WHERE book_name = "To Kill a Mockingbird";

-- A new book borrower is joinging today!
INSERT INTO borrower_details
	(borrower_id, first_name, last_name, email_address, phone_number, address)
VALUES
	(110, "Elizabeth", "Fredrickson", "e.freddy@hotmail.co.uk", "07098231758", "12 Main Street, Belper, Derbyshire, DE56 2LD");
    
SELECT * FROM borrower_details;


-- The book that has been overdue the longest has been returned! First find the book ID for the book that has been overdue the longest
SELECT book_id FROM overdue_books WHERE days_overdue = (SELECT max(days_overdue) FROM overdue_books);
-- Then with that ID, delete that row from the table
DELETE FROM overdue_books
WHERE book_id = 5;
SELECT * FROM overdue_books;

-- Oh No! The book has been returned is in a terrible state! Update the book condition
UPDATE library_books SET book_condition = "Poor" WHERE book_id = 5;

-- Finding out how many books by the different authors are in the library
SELECT author, COUNT(author)
FROM Library_books
GROUP BY author;

-- Sum of how much is owed to the library in fines
SELECT SUM(fine)
FROM overdue_books;

-- Joining the information about who has a book out currently and when it's due back
SELECT CONCAT(bd.first_name, " ", bd.last_name), lb.book_name, bb.expected_return_date
FROM books_borrowed bb
LEFT JOIN borrower_details bd ON bb.borrower_id = bd.borrower_id LEFT JOIN library_books lb ON bb.book_id = lb.book_id ORDER BY bb.expected_return_date;

-- Elizabeth wants to take out "To Kill a Mockingbird". This will update the table with her return date
INSERT INTO books_borrowed
	(book_id, borrow_start_date, expected_return_date, borrower_id, overdue_y_or_n)
VALUES
	((SELECT book_id FROM library_books WHERE book_name = "To Kill a Mockingbird"), CURRENT_DATE, CURRENT_DATE + 14, (SELECT borrower_id FROM borrower_details WHERE first_name = "Elizabeth"), "n");

SELECT * FROM books_borrowed;

-- Stored procedure that will check which books are overdue and need adding to the overdue table, and then update their borrowed overdue status
DELIMITER //
CREATE PROCEDURE book_overdue()
BEGIN
INSERT INTO overdue_books 
	(book_id, borrower_id, days_overdue, fine)
VALUES
	(-- book_id of the book that is overdue
	(SELECT bb.book_id FROM books_borrowed bb WHERE bb.expected_return_date < CURRENT_DATE AND overdue_y_or_n = "n"), 
	-- borrower_id of that book
	(SELECT bb.borrower_id FROM books_borrowed bb WHERE bb.expected_return_date < CURRENT_DATE AND overdue_y_or_n = "n"),
	-- how many days overdue?
	(SELECT CURRENT_DATE - bb.expected_return_date FROM books_borrowed bb WHERE bb.expected_return_date < CURRENT_DATE AND overdue_y_or_n = "n"),
	-- what the fine is
	(SELECT CURRENT_DATE - bb.expected_return_date FROM books_borrowed bb WHERE bb.expected_return_date < CURRENT_DATE AND overdue_y_or_n = "n") * 0.5);
-- update the books borrowed table to say that a book is overdue and has been added to overdue table

UPDATE books_borrowed
SET overdue_y_or_n = "y"
WHERE expected_return_date < CURRENT_DATE AND overdue_y_or_n = "n";
END //
DELIMITER ;
    
CALL book_overdue();

SELECT * FROM overdue_books;

-- Joining the information about which book borrower has overdue books
SELECT CONCAT(bd.first_name, " ", bd.last_name), lb.book_name, ob.days_overdue, ob.fine
FROM overdue_books ob
LEFT JOIN borrower_details bd ON ob.borrower_id = bd.borrower_id LEFT JOIN library_books lb ON ob.book_id = lb.book_id ORDER BY ob.days_overdue DESC;
