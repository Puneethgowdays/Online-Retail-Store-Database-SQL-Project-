CREATE DATABASE retail_store;
USE retail_store;
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(80),
    email VARCHAR(80),
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(80),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1, 'Rahul Sharma', 'rahul@gmail.com', 'Bangalore'),
(2, 'Aditi Rao', 'aditi@gmail.com', 'Mumbai'),
(3, 'Kiran Gowda', 'kiran@gmail.com', 'Chennai');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 55000),
(102, 'Headphones', 'Electronics', 2500),
(103, 'Office Chair', 'Furniture', 6000);

INSERT INTO orders VALUES
(5001, 1, '2025-01-12', 57500),
(5002, 2, '2025-01-15', 2500);

INSERT INTO order_items VALUES
(1, 5001, 101, 1),
(2, 5001, 102, 1),
(3, 5002, 102, 1);

CREATE VIEW daily_sales AS
SELECT order_date, SUM(total_amount) AS total_sales
FROM orders
GROUP BY order_date;

DELIMITER //
CREATE PROCEDURE get_customer_orders(IN cust_id INT)
BEGIN
    SELECT orders.order_id, orders.order_date, orders.total_amount
    FROM orders
    WHERE orders.customer_id = cust_id;
END //
DELIMITER ;

CREATE TABLE order_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER trg_after_order
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    INSERT INTO order_log(order_id) VALUES (NEW.order_id);
END //
DELIMITER ;
SELECT customer_name, SUM(total_amount) AS total_spent
FROM customers
JOIN orders USING(customer_id)
GROUP BY customer_id
ORDER BY total_spent DESC;

SELECT product_name, SUM(quantity) AS total_sold
FROM order_items
JOIN products USING(product_id)
GROUP BY product_id
ORDER BY total_sold DESC;
