CREATE TABLE Readers (
    reader_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20)
);

CREATE TABLE Books (
    isbn VARCHAR(20) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publication_year INT
);

CREATE TABLE Authors (
    author_id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL
);

CREATE TABLE Book_Authors (
    book_isbn VARCHAR(20),
    author_id INT,
    PRIMARY KEY (book_isbn, author_id),
    FOREIGN KEY (book_isbn) REFERENCES Books (isbn) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES Authors (author_id) ON DELETE CASCADE
);

CREATE TABLE Loans (
    loan_id SERIAL PRIMARY KEY,
    reader_id INT NOT NULL,
    book_isbn VARCHAR(20) NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    actual_return_date DATE,
    FOREIGN KEY (reader_id) REFERENCES Readers (reader_id),
    FOREIGN KEY (book_isbn) REFERENCES Books (isbn)
);

INSERT INTO Readers (full_name, phone) VALUES
('Анна Петрова', '+7-900-111-22-33'),
('Иван Соколов', '+7-900-222-33-44'),
('Мария Ким', '+7-900-333-44-55'),
('Олег Васильев', '+7-900-444-55-66'),
('Тестовый Читатель', '+7-900-555-66-77');

INSERT INTO Books (isbn, title, publication_year) VALUES
('978-5-17-118366-8', 'Мастер и Маргарита', 1967),
('978-5-389-06256-6', 'Преступление и наказание', 1866),
('978-5-04-116716-3', 'Война и мир', 1869),
('978-5-699-12014-7', 'Золотой теленок', 1931),
('978-5-389-03713-7', 'Пикник на обочине', 1972);

INSERT INTO Authors (full_name) VALUES
('Михаил Булгаков'),
('Федор Достоевский'),
('Лев Толстой'),
('Илья Ильф'),
('Евгений Петров'),
('Аркадий Стругацкий'),
('Борис Стругацкий');

INSERT INTO Book_Authors (book_isbn, author_id) VALUES
('978-5-17-118366-8', (SELECT author_id FROM Authors WHERE full_name = 'Михаил Булгаков')),
('978-5-389-06256-6', (SELECT author_id FROM Authors WHERE full_name = 'Федор Достоевский')),
('978-5-04-116716-3', (SELECT author_id FROM Authors WHERE full_name = 'Лев Толстой')),
('978-5-699-12014-7', (SELECT author_id FROM Authors WHERE full_name = 'Илья Ильф')),
('978-5-699-12014-7', (SELECT author_id FROM Authors WHERE full_name = 'Евгений Петров')),
('978-5-389-03713-7', (SELECT author_id FROM Authors WHERE full_name = 'Аркадий Стругацкий')),
('978-5-389-03713-7', (SELECT author_id FROM Authors WHERE full_name = 'Борис Стругацкий'));

INSERT INTO Loans (reader_id, book_isbn, loan_date, due_date, actual_return_date) VALUES
((SELECT reader_id FROM Readers WHERE full_name = 'Анна Петрова'), '978-5-17-118366-8', '2026-09-01', '2026-09-15', '2026-09-10'),
((SELECT reader_id FROM Readers WHERE full_name = 'Иван Соколов'), '978-5-389-06256-6', '2026-09-03', '2026-09-17', NULL),
((SELECT reader_id FROM Readers WHERE full_name = 'Мария Ким'), '978-5-04-116716-3', '2026-09-05', '2026-09-19', '2026-09-18'),
((SELECT reader_id FROM Readers WHERE full_name = 'Олег Васильев'), '978-5-699-12014-7', '2026-09-07', '2026-09-21', NULL),
((SELECT reader_id FROM Readers WHERE full_name = 'Анна Петрова'), '978-5-389-03713-7', '2026-09-09', '2026-09-23', NULL),
((SELECT reader_id FROM Readers WHERE full_name = 'Мария Ким'), '978-5-699-12014-7', '2026-08-20', '2026-09-03', '2026-09-01');

SELECT *
FROM Readers;

SELECT title, publication_year
FROM Books;

SELECT title, publication_year
FROM Books
WHERE publication_year BETWEEN 1801 AND 1900;

SELECT title, publication_year
FROM Books
WHERE publication_year BETWEEN 1917 AND 1991;

SELECT *
FROM Readers
WHERE phone = '+7-900-111-22-33';

SELECT *
FROM Readers
WHERE full_name LIKE '%Петрова%';