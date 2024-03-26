
DROP DATABASE IF EXISTS LibrarySystem;
CREATE DATABASE  LibrarySystem;
USE LibrarySystem;

CREATE TABLE Publisher(
    publisher_ID INT PRIMARY KEY ,
    Name VARCHAR(100),
    Address VARCHAR(100)
);

CREATE TABLE Books(
    book_ID INT PRIMARY KEY ,
    publisher_id INT,
    Title VARCHAR(100),
    Descriptions VARCHAR(200),
    CONSTRAINT FOREIGN KEY (publisher_id) REFERENCES Publisher(publisher_ID)
);

CREATE TABLE LoanBooks(
    loanBook_ID INT PRIMARY KEY ,
    Date DATE,
    book_id INT,
    CONSTRAINT FOREIGN KEY (book_id) REFERENCES Books(book_ID)
);

CREATE TABLE UserRole(
    userRole_ID INT PRIMARY KEY ,
    RoleName VARCHAR(100)
);

CREATE TABLE Users(
    user_ID INT PRIMARY KEY ,
    FullName VARCHAR(100),
    Egn VARCHAR(10),
    Pass INT,
    phone VARCHAR(10),
    email VARCHAR(50),
    role_Id INT,
    CONSTRAINT FOREIGN KEY (role_Id) REFERENCES UserRole(UserRole_ID)
);

CREATE TABLE Authors(
    author_ID INT PRIMARY KEY ,
    Name VARCHAR(100),
    Info VARCHAR(200)
);

ALTER TABLE authors
CHANGE Name FName VARCHAR(100);

CREATE TABLE BookAuthors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_ID),
    FOREIGN KEY (author_id) REFERENCES Authors(author_ID)
);

CREATE TABLE Genres(
    genre_ID INT PRIMARY KEY ,
    Name VARCHAR(100)
);

CREATE TABLE BookGenre(
    book_ID INT,
    genre_ID INT,
    PRIMARY KEY (book_ID,genre_ID),
    FOREIGN KEY (book_ID) REFERENCES Books(book_ID),
    FOREIGN KEY (genre_ID) REFERENCES Genres(genre_ID)
);

-- Insert data into Publisher table
INSERT INTO Publisher (publisher_ID, Name, Address) VALUES
(1, 'Penguin Random House', '1745 Broadway, New York, NY 10019, USA'),
(2, 'TU-Sofia', '195 Broadway, New York, NY 10007, USA'),
(3, 'TU-Sofia', '1230 Avenue of the Americas, New York, NY 10020, USA'),
(4, 'Macmillan Publishers', '120 Broadway, New York, NY 10271, USA'),
(5, 'TU-Sofia', '1290 Avenue of the Americas, New York, NY 10104, USA'),
(6, 'Scholastic Corporation', '557 Broadway, New York, NY 10012, USA'),
(7, 'TU-Sofia', '111 River St, Hoboken, NJ 07030, USA'),
(8, 'TU-Sofia', '330 Hudson St, New York, NY 10013, USA'),
(9, 'TU-Sofia', '198 Madison Ave, New York, NY 10016, USA'),
(10, 'Cambridge University Press', '32 Avenue of the Americas, New York, NY 10013, USA');

-- Insert data into Books table
INSERT INTO Books (book_ID, publisher_id, Title, Descriptions) VALUES
(1, 1, 'The Great Gatsby', 'A novel written by American author F. Scott Fitzgerald.'),
(2, 2, 'To Kill a Mockingbird', 'A novel by Harper Lee set in the American South during the 1930s.'),
(3, 3, '1984', 'A dystopian social science fiction novel by George Orwell.'),
(4, 4, 'Harry Potter and the Philosopher''s Stone', 'The first novel in the Harry Potter series written by J.K. Rowling.'),
(5, 5, 'The Catcher in the Rye', 'A novel by J.D. Salinger.'),
(6, 6, 'Harry Potter and the Chamber of Secrets', 'The second novel in the Harry Potter series written by J.K. Rowling.'),
(7, 7, 'The Hobbit', 'A fantasy novel by J.R.R. Tolkien.'),
(8, 8, 'Lord of the Flies', 'A novel by Nobel Prize-winning British author William Golding.'),
(9, 9, 'Pride and Prejudice', 'A romantic novel by Jane Austen.'),
(10, 10, 'The Da Vinci Code', 'A mystery thriller novel by Dan Brown.');

-- Insert data into LoanBooks table
INSERT INTO LoanBooks (loanBook_ID, Date, book_id) VALUES
(1, '2023-12-01', 1),
(2, '2023-12-02', 2),
(3, '2023-12-03', 3),
(4, '2023-12-04', 4),
(5, '2023-12-05', 5),
(6, '2023-12-06', 6),
(7, '2023-12-07', 7),
(8, '2023-12-08', 8),
(9, '2023-12-09', 9),
(10, '2023-12-10', 10);

-- Insert data into UserRole table
INSERT INTO UserRole (userRole_ID, RoleName) VALUES
(1, 'Admin'),
(2, 'User'),
(3, 'Editor'),
(4, 'Guest'),
(5, 'Moderator'),
(6, 'Subscriber'),
(7, 'Contributor'),
(8, 'Manager'),
(9, 'Reviewer'),
(10, 'Writer');

-- Insert data into Users table
INSERT INTO Users (user_ID, FullName, Egn, Pass, phone, email) VALUES
(1, 'John Smith', '1234567890', 123456, '1234567890', 'john@example.com'),
(2, 'Emily Johnson', '0987654321', 654321, '0987654321', 'emily@example.com'),
(3, 'Michael Brown', '4567890123', 456789, '4567890123', 'michael@example.com'),
(4, 'Emma Davis', '5678901234', 567890, '5678901234', 'emma@example.com'),
(5, 'James Wilson', '6789012345', 678901, '6789012345', 'james@example.com'),
(6, 'Olivia Taylor', '7890123456', 789012, '7890123456', 'olivia@example.com'),
(7, 'William Martinez', '8901234567', 890123, '8901234567', 'william@example.com'),
(8, 'Sophia Anderson', '9012345678', 901234, '9012345678', 'sophia@example.com'),
(9, 'Alexander Thomas', '0123456789', 012345, '0123456789', 'alexander@example.com'),
(10, 'Isabella Garcia', '1029384756', 102938, '1029384756', 'isabella@example.com');

-- Insert data into Authors table
INSERT INTO Authors (author_ID, Name, Info) VALUES
(1, 'Stephen King', 'American author known for his horror and supernatural fiction.'),
(2, 'J.K. Rowling', 'British author best known for the Harry Potter fantasy series.'),
(3, 'Agatha Christie', 'English writer known for her detective novels and short story collections.'),
(4, 'George Orwell', 'English novelist, essayist, journalist, and critic.'),
(5, 'Jane Austen', 'English novelist known primarily for her six major novels, which interpret, critique, and comment upon the British landed gentry at the end of the 18th century.'),
(6, 'J.R.R. Tolkien', 'English writer, poet, philologist, and university professor, best known as the author of the classic high fantasy works The Hobbit, The Lord of the Rings, and The Silmarillion.'),
(7, 'Dan Brown', 'American author best known for his thriller novels, including the Robert Langdon novels Angels & Demons, The Da Vinci Code, The Lost Symbol, Inferno, and Origin.'),
(8, 'Mark Twain', 'American writer, humorist, entrepreneur, publisher, and lecturer.'),
(9, 'Leo Tolstoy', 'Russian writer who is regarded as one of the greatest authors of all time.'),
(10, 'Herman Melville', 'American novelist, short story writer, and poet of the American Renaissance period.');


-- Insert data into Genres table
INSERT INTO Genres (genre_ID, Name) VALUES
(1, 'Fiction'),
(2, 'Non-fiction'),
(3, 'Mystery'),
(4, 'Science Fiction'),
(5, 'Fantasy'),
(6, 'Thriller'),
(7, 'Romance'),
(8, 'Horror'),
(9, 'Historical Fiction'),
(10, 'Biography');

-- Insert data into BookGenre table
INSERT INTO BookGenre (book_ID, genre_ID) VALUES
(1, 5),
(2, 1),
(3, 8),
(4, 1),
(5, 1),
(6, 5),
(7, 5),
(8, 1),
(9, 7),
(10, 6);

-- Insert data into BookAuthors table
INSERT INTO BookAuthors (book_id, author_id) VALUES
(1, 1),  -- Book 1 is written by Author 1
(1, 2),  -- Book 1 is also written by Author 2
(2, 3),  -- Book 2 is written by Author 3
(3, 4),  -- Book 3 is written by Author 4
(3, 5),  -- Book 3 is also written by Author 5
(4, 6),  -- Book 4 is written by Author 6
(5, 7),  -- Book 5 is written by Author 7
(6, 8),  -- Book 6 is written by Author 8
(7, 9),  -- Book 7 is written by Author 9
(8, 10); -- Book 8 is written by Author 10

DROP VIEW BookDetail;
-- ex.1
CREATE VIEW BookDetail AS SELECT
 b.Title AS Title,b.Descriptions AS Descriptions,
a.FName AS Author ,G.Name AS Genre,P.Name AS Publisher
FROM Books b
JOIN BookAuthors ba on b.book_ID = ba.book_id
JOIN Authors a on ba.author_id = a.author_ID
JOIN BookGenre bg on b.book_ID = bg.book_ID
JOIN Genres G on bg.genre_ID = G.genre_ID
JOIN Publisher P on b.publisher_id = P.publisher_ID;

-- ex.2
SELECT b.Title AS Title,COALESCE(p.Name,'No publisher') AS Publisher
FROM Books b
JOIN Publisher P on b.publisher_id = P.publisher_ID;

-- ex.3
SELECT GROUP_CONCAT(A.FName ORDER BY B.Title SEPARATOR ',') AS Authors,
       B.Title AS Title
FROM BookAuthors AS ba
JOIN Authors A on ba.author_id = A.author_ID
JOIN Books B on ba.book_id = B.book_ID
GROUP BY b.Title
HAVING COUNT(*) >= 2;


-- ex.4
SELECT u.FullName AS Name,
u.email AS Email, u.phone AS Phone,COUNT(lb.loanBook_ID) AS Number
FROM Users AS u
JOIN LoanBooks AS lb ON u.user_ID = lb.user_id
JOIN Books B on lb.book_id = B.book_ID
JOIN Publisher P on B.publisher_id = P.publisher_ID
WHERE P.Name = 'TU-Sofia'
GROUP BY lb.user_id
HAVING Number = 1;




