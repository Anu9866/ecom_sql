-- Create the database
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- Create tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data
INSERT INTO customers (customer_name, email, country) VALUES
('John Doe', 'john.doe@example.com', 'USA'),
('Jane Smith', 'jane.smith@example.com', 'Canada'),
('Alice Johnson', 'alice.johnson@example.com', 'UK');

INSERT INTO products (product_name, category, price) VALUES
('Laptop', 'Electronics', 1200.00),
('Headphones', 'Electronics', 200.00),
('Coffee Maker', 'Home Appliances', 50.00),
('Smartphone', 'Electronics', 800.00);

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-04-10'),
(2, '2024-04-12'),
(1, '2024-04-15');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1200.00),
(1, 2, 2, 200.00),
(2, 3, 1, 50.00),
(3, 4, 1, 800.00);

-- Sample Queries

-- 1. Select customers from the USA
SELECT * FROM customers;
select * from orders;
select * from customers WHERE country = 'USA';

-- 2. Top 5 most expensive products
SELECT * FROM products ORDER BY price DESC LIMIT 5;

-- 3. Total number of orders per customer
SELECT customer_id, COUNT(*) AS total_orders
FROM orders
GROUP BY customer_id;

-- 4. Average product price per category
SELECT category, AVG(price) AS avg_price
FROM products
GROUP BY category;

-- 5. Join orders with customer names
SELECT o.order_id, o.order_date, c.customer_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- 6. Join order details with product info
SELECT oi.order_id, p.product_name, oi.quantity, oi.unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id;

-- 7. Customers who ordered more than 1 time
SELECT customer_id 
FROM orders 
GROUP BY customer_id 
HAVING COUNT(order_id) > 1;

-- 8. Products more expensive than average
SELECT * FROM products
WHERE price > (SELECT AVG(price) FROM products);

-- 9. Create a view for customer spending
CREATE VIEW customer_spending AS
SELECT o.customer_id, SUM(oi.quantity * oi.unit_price) AS total_spent
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.customer_id;

-- 10. Show customer spending view
SELECT * FROM customer_spending;

-- 11. Create index for faster lookup
CREATE INDEX idx_customer_id ON orders(customer_id);
CREATE INDEX idx_product_id ON order_items(product_id);
