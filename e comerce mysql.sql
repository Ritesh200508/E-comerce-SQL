use practice2;
 CREATE TABLE Customer2
( customer_id INT PRIMARY KEY, name VARCHAR(50), 
age INT, gender VARCHAR(10), 
country VARCHAR(30), membership VARCHAR(20));

 INSERT INTO Customer2 VALUES (1, 'Alice', 28, 'Female', 'USA', 'Premium'),
 (2, 'Bob', 35, 'Male', 'India', 'Normal'), 
 (3, 'Charlie', 22, 'Male', 'Canada', 'Premium'),
 (4, 'Diana', 30, 'Female', 'USA', 'Normal'),
 (5, 'Ethan', 40, 'Male', 'UK', 'Premium'),
 (6, 'Fatima', 26, 'Female', 'UAE', 'Normal'),
 (7, 'George', 33, 'Male', 'Germany', 'Premium'),
 (8, 'Hannah', 29, 'Female', 'Australia', 'Normal'),
 (9, 'Ivan', 31, 'Male', 'Russia', 'Premium'),
 (10, 'Julia', 27, 'Female', 'India', 'Normal');

CREATE TABLE Product2 (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10,2)
);

INSERT INTO Product2 VALUES
(101, 'Laptop', 'Electronics', 800.00),
(102, 'Phone', 'Electronics', 500.00),
(103, 'Shoes', 'Fashion', 60.00),
(104, 'Watch', 'Fashion', 120.00),
(105, 'Headphones', 'Electronics', 90.00),
(106, 'Tablet', 'Electronics', 300.00),
(107, 'T-shirt', 'Fashion', 25.00),
(108, 'Jeans', 'Fashion', 45.00),
(109, 'Camera', 'Electronics', 600.00),
(110, 'Backpack', 'Fashion', 70.00);

select * from product2;


CREATE TABLE Orders2 (
    order_id INT ,
    customer_id INT,
    order_date DATE,
    payment_method VARCHAR(20)
);

INSERT INTO Order2 VALUES
(1001, 1, '2023-09-01', 'Credit Card'),
(1002, 2, '2023-09-02', 'Cash'),
(1003, 3, '2023-09-03', 'Debit Card'),
(1004, 1, '2023-09-04', 'Credit Card'),
(1005, 4, '2023-09-05', 'UPI'),
(1006, 5, '2023-09-06', 'Credit Card'),
(1007, 6, '2023-09-07', 'Debit Card'),
(1008, 7, '2023-09-08', 'PayPal'),
(1009, 8, '2023-09-09', 'Credit Card'),
(1010, 9, '2023-09-10', 'UPI'),
(1011, 10, '2023-09-11', 'Credit Card'),
(1012, 2, '2023-09-12', 'UPI'),
(1013, 3, '2023-09-13', 'Cash'),
(1014, 4, '2023-09-14', 'Credit Card'),
(1015, 5, '2023-09-15', 'Debit Card');

select * from order2;

CREATE TABLE OrderDetail2 (
    orderdetail_id INT ,
    order_id INT,
    product_id INT,
    quantity INT);

INSERT INTO OrderDetail2 VALUES
(1, 1001, 101, 1),
(2, 1001, 104, 2),
(3, 1002, 103, 3),
(4, 1003, 102, 1),
(5, 1004, 105, 1),
(6, 1005, 110, 2),
(7, 1006, 101, 1),
(8, 1006, 103, 2),
(9, 1007, 106, 1),
(10, 1008, 109, 1),
(11, 1009, 107, 4),
(12, 1010, 108, 2),
(13, 1011, 101, 1),
(14, 1012, 105, 3),
(15, 1013, 104, 1),
(16, 1014, 109, 2),
(17, 1015, 102, 2),
(18, 1015, 103, 1);

select * from OrderDetail2;




-- Get all customers
SELECT * FROM Customers;

-- Get all products in Electronics category
SELECT * FROM Product2 WHERE category = 'Electronics';

-- Get all orders placed in September 2023
SELECT * FROM Order2 WHERE order_date BETWEEN '2023-09-01' AND '2023-09-30';

-- Customers from USA
SELECT name, country FROM Customer2 WHERE country = 'USA';

-- Customers older than 30
SELECT name, age FROM Customer2 WHERE age > 30;

-- Products priced between 50 and 200
SELECT product_name, price FROM Product2 WHERE price BETWEEN 50 AND 200;

-- Customers with Premium membership from India/USA
SELECT name, country, membership 
FROM Customer2
WHERE membership = 'Premium' AND country IN ('India','USA');

-- Search product by keyword
SELECT * FROM Product2 WHERE product_name LIKE '%Phone%';

-- Count total customers
SELECT COUNT(*) AS total_customers FROM Customer2;

-- Average price of products
SELECT AVG(price) AS avg_price FROM Product2;

-- Total revenue from all sales
SELECT SUM(p.price * od.quantity) AS total_revenue
FROM OrderDetail2 od
JOIN Product2 p ON od.product_id = p.product_id;

-- Most expensive product
SELECT product_name, price 
FROM Product2
ORDER BY price DESC 
LIMIT 1;

-- Total sales by category
SELECT p.category, SUM(p.price * od.quantity) AS category_sales
FROM OrderDetail2 od
JOIN Product2 p ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY category_sales DESC;

-- Customers grouped by membership
SELECT membership, COUNT(*) AS total_members 
FROM Customer2
GROUP BY membership
ORDER BY total_members DESC;

-- INNER JOIN: Orders with customer names
SELECT o.order_id, c.name, o.order_date, o.payment_method
FROM Order2 o
INNER JOIN Customer2 c ON o.customer_id = c.customer_id;

-- LEFT JOIN: All customers with orders (if any)
SELECT c.name, o.order_id, o.order_date
FROM Customer2 c
LEFT JOIN Order2 o ON c.customer_id = o.customer_id;

-- RIGHT JOIN (not supported in SQLite, but conceptually)
-- Show all orders even if customer details are missing
SELECT o.order_id, c.name
FROM Order2 o
LEFT JOIN Customer2 c ON o.customer_id = c.customer_id;

-- Orders with products (many-to-many join)
SELECT o.order_id, c.name, p.product_name, od.quantity
FROM Orders o
JOIN Customer2 c ON o.customer_id = c.customer_id
JOIN OrderDetail2 od ON o.order_id = od.order_id
JOIN Product2 p ON od.product_id = p.product_id;

-- Customers who spent more than $1000
SELECT name FROM Customer2
WHERE customer_id IN (
    SELECT o.customer_id
    FROM Order2 o
    JOIN OrderDetail2 od ON o.order_id = od.order_id
    JOIN Product2 p ON od.product_id = p.product_id
    GROUP BY o.customer_id
    HAVING SUM(p.price * od.quantity) > 1000
);

-- Find products more expensive than the average price
SELECT product_name, price
FROM Product2
WHERE price > (SELECT AVG(price) FROM Products);

-- Create view for total sales per customer
CREATE VIEW CustomerSales AS
SELECT c.customer_id, c.name, SUM(p.price * od.quantity) AS total_spent
FROM Customer2 c
JOIN Order2 o ON c.customer_id = o.customer_id
JOIN OrderDetail2 od ON o.order_id = od.order_id
JOIN Product2 p ON od.product_id = p.product_id
GROUP BY c.customer_id;

-- Query the view
SELECT * FROM CustomerSales ORDER BY total_spent DESC;

-- Create index on Orders.customer_id for faster joins
CREATE INDEX idx_orders_customer ON Order2(customer_id);

-- Create index on OrderDetails.product_id
CREATE INDEX idx_orderdetails_product ON OrderDetail2(product_id);

-- Rank customers by spending
SELECT c.name, SUM(p.price * od.quantity) AS total_spent,
       RANK() OVER (ORDER BY SUM(p.price * od.quantity) DESC) AS rank_spender
FROM Customer2 c
JOIN Order2 o ON c.customer_id = o.customer_id
JOIN OrderDetail2 od ON o.order_id = od.order_id
JOIN Product2 p ON od.product_id = p.product_id
GROUP BY c.customer_id;

-- Running total of sales by date
SELECT o.order_date, SUM(p.price * od.quantity) AS daily_sales,
       SUM(SUM(p.price * od.quantity)) OVER (ORDER BY o.order_date) AS running_total
FROM Orders o
JOIN OrderDetail2 od ON o.order_id = od.order_id
JOIN Product2 p ON od.product_id = p.product_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- Categorize customers by age group
SELECT name, age,
       CASE 
           WHEN age < 25 THEN 'Young'
           WHEN age BETWEEN 25 AND 35 THEN 'Adult'
           ELSE 'Senior'
       END AS age_group
FROM Customer2;

-- Categorize spending level
SELECT c.name, SUM(p.price * od.quantity) AS total_spent,
       CASE
           WHEN SUM(p.price * od.quantity) > 1500 THEN 'High Spender'
           WHEN SUM(p.price * od.quantity) BETWEEN 500 AND 1500 THEN 'Medium Spender'
           ELSE 'Low Spender'
       END AS spending_category
FROM Customer2 c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY c.customer_id;


