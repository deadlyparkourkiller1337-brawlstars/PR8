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


-- Удаляем таблицы, если они существуют, чтобы избежать ошибок при повторном выполнении
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;

-- Создание таблицы Покупателей
CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE NOT NULL,
    recommended_by INT,
    FOREIGN KEY (recommended_by) REFERENCES Customers(customer_id)
);

-- Создание таблицы Товаров
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Создание таблицы Заказов
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Создание таблицы Состава Заказа
CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Наполнение таблиц данными
INSERT INTO Customers (customer_id, full_name, email, registration_date, recommended_by) VALUES
(1, 'Иван Иванов', 'ivan.ivanov@example.com', '2023-01-15', NULL),
(2, 'Мария Петрова', 'maria.petrova@example.com', '2023-02-20', 1),
(3, 'Алексей Смирнов', 'alex.smirnov@example.com', '2023-03-10', 1),
(4, 'Елена Васильева', 'elena.v@example.com', '2023-04-01', 2),
(5, 'Андрей Николаев', 'andrey.n@example.com', '2023-05-01', NULL);

INSERT INTO Products (product_name, category, price) VALUES
('Смартфон', 'Электроника', 70000.00),
('Ноутбук', 'Электроника', 120000.00),
('Кофемашина', 'Бытовая техника', 25000.00),
('Книга "Основы SQL"', 'Книги', 1500.00),
('Фен', 'Бытовая техника', 4500.00),
('Пылесос', 'Бытовая техника', 15000.00);

INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2024-05-10', 'Доставлен'),
(2, '2024-05-12', 'В обработке'),
(1, '2024-05-15', 'Отправлен'),
(3, '2024-05-16', 'Доставлен');

INSERT INTO Order_Items (order_id, product_id, quantity, price_per_unit) VALUES
(1, 1, 1, 70000.00),  -- Иван купил Смартфон
(1, 4, 2, 1400.00),   -- и 2 книги
(2, 2, 1, 120000.00), -- Мария купила Ноутбук
(3, 3, 1, 25000.00),  -- Иван купил Кофемашину
(4, 1, 1, 70000.00),  -- Алексей купил Смартфон
(4, 5, 1, 4500.00);   -- и Фен

SELECT c.full_name, o.order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id;

SELECT c.full_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

SELECT p.product_name, oi.quantity, oi.price_per_unit
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
WHERE oi.order_id = 1;

SELECT full_name
FROM Customers
WHERE customer_id IN (
    SELECT o.customer_id
    FROM Orders o
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    WHERE p.product_name = 'Смартфон'
);

SELECT product_name, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

SELECT o.order_id, o.order_date
FROM Orders o
WHERE EXISTS (
    SELECT 1
    FROM Order_Items oi
    JOIN Products p ON oi.product_id = p.product_id
    WHERE oi.order_id = o.order_id AND p.price > 100000
);

SELECT DISTINCT c.full_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN Order_Items oi ON o.order_id = oi.order_id
LEFT JOIN Products p ON oi.product_id = p.product_id AND p.product_name = 'Ноутбук'
WHERE p.product_id IS NULL;

SELECT p.product_name
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

SELECT c.full_name, p.product_name, oi.quantity
FROM Customers c
FULL OUTER JOIN Orders o ON c.customer_id = o.customer_id
FULL OUTER JOIN Order_Items oi ON o.order_id = oi.order_id
FULL OUTER JOIN Products p ON oi.product_id = p.product_id;

SELECT c.full_name, p.product_name, oi.quantity
FROM Customers c
FULL OUTER JOIN Orders o ON c.customer_id = o.customer_id
FULL OUTER JOIN Order_Items oi ON o.order_id = oi.order_id
FULL OUTER JOIN Products p ON oi.product_id = p.product_id;

SELECT full_name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    WHERE order_id IN (
        SELECT order_id
        FROM Order_Items
        WHERE product_id IN (
            SELECT product_id
            FROM Products
            WHERE price = (SELECT MAX(price) FROM Products)
        )
    )
);

SELECT DISTINCT c.full_name, p.category
FROM Customers c
CROSS JOIN Products p;

SELECT 
    customer.full_name AS new_customer,
    recommender.full_name AS recommended_by
FROM Customers customer
JOIN Customers recommender ON customer.recommended_by = recommender.customer_id;
