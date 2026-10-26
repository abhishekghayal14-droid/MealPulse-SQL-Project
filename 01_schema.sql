create database mealpulse_db;
use mealpulse_db;


CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    signup_date DATE NOT NULL,
    customer_segment VARCHAR(20) DEFAULT 'New',
    is_active BOOLEAN DEFAULT TRUE
);


INSERT INTO customers
    (customer_name, city, signup_date, customer_segment, is_active)
VALUES
    ('Aarav Shah', 'Aurangabad', '2026-01-10', 'Regular', TRUE),
    ('Priya Patil', 'Aurangabad', '2026-02-15', 'New', TRUE),
    ('Rohan Mehta', 'Aurangabad', '2026-01-20', 'Regular', TRUE),
    ('Sneha Kulkarni', 'Aurangabad', '2026-03-01', 'New', TRUE),
    ('Kabir Joshi', 'Aurangabad', '2026-02-05', 'At Risk', FALSE);
    
    
SELECT *
FROM customers;


SELECT
    customer_segment,
    COUNT(*) AS total_customers
FROM customers
GROUP BY customer_segment
ORDER BY total_customers DESC;


USE mealpulse_db;

CREATE TABLE delivery_zones (
    zone_id INT AUTO_INCREMENT PRIMARY KEY,
    zone_name VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    traffic_level VARCHAR(20) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE
);


INSERT INTO delivery_zones
    (zone_name, city, traffic_level, is_active)
VALUES
    ('Central Zone', 'Aurangabad', 'High', TRUE),
    ('North Zone', 'Aurangabad', 'Medium', TRUE),
    ('South Zone', 'Aurangabad', 'Low', TRUE),
    ('East Zone', 'Aurangabad', 'High', TRUE),
    ('West Zone', 'Aurangabad', 'Medium', TRUE);



SELECT * FROM delivery_zones;


CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    cuisine_type VARCHAR(50) NOT NULL,
    zone_id INT NOT NULL,
    average_prep_time INT NOT NULL,
    restaurant_rating DECIMAL(2,1),
    is_active BOOLEAN DEFAULT TRUE,

    CONSTRAINT fk_restaurant_zone
        FOREIGN KEY (zone_id)
        REFERENCES delivery_zones(zone_id),

    CONSTRAINT chk_prep_time
        CHECK (average_prep_time > 0),

    CONSTRAINT chk_restaurant_rating
        CHECK (restaurant_rating BETWEEN 1 AND 5)
);


INSERT INTO restaurants
    (restaurant_name, cuisine_type, zone_id,
     average_prep_time, restaurant_rating, is_active)
VALUES
    ('Spice Route', 'Indian', 1, 25, 4.5, TRUE),
    ('Pizza Corner', 'Italian', 2, 20, 4.2, TRUE),
    ('Green Bowl', 'Healthy', 3, 15, 4.7, TRUE),
    ('Wok Express', 'Chinese', 4, 22, 4.0, TRUE),
    ('Royal Biryani', 'Indian', 5, 30, 4.4, TRUE);


SELECT
    r.restaurant_name,
    r.cuisine_type,
    z.zone_name,
    z.traffic_level,
    r.average_prep_time,
    r.restaurant_rating
FROM restaurants r
JOIN delivery_zones z
    ON r.zone_id = z.zone_id;
    
    
USE mealpulse_db;

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_time DATETIME NOT NULL,
    order_amount DECIMAL(10,2) NOT NULL,
    order_status VARCHAR(20) NOT NULL DEFAULT 'Placed',

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_order_restaurant
        FOREIGN KEY (restaurant_id)
        REFERENCES restaurants(restaurant_id),

    CONSTRAINT chk_order_amount
        CHECK (order_amount > 0),

    CONSTRAINT chk_order_status
        CHECK (order_status IN
            ('Placed', 'Preparing', 'Delivered', 'Cancelled'))
);


INSERT INTO orders
    (customer_id, restaurant_id, order_time,
     order_amount, order_status)
VALUES
    (1, 1, '2026-10-20 12:10:00', 450.00, 'Delivered'),
    (2, 2, '2026-10-20 13:15:00', 320.00, 'Delivered'),
    (3, 3, '2026-10-20 19:05:00', 280.00, 'Delivered'),
    (4, 4, '2026-10-21 20:20:00', 520.00, 'Delivered'),
    (5, 5, '2026-10-21 14:00:00', 600.00, 'Cancelled'),
    (1, 2, '2026-10-22 13:30:00', 350.00, 'Delivered'),
    (2, 3, '2026-10-22 19:45:00', 240.00, 'Delivered'),
    (3, 1, '2026-10-23 12:40:00', 490.00, 'Preparing'),
    (4, 5, '2026-10-23 20:10:00', 700.00, 'Delivered'),
    (5, 4, '2026-10-24 18:25:00', 410.00, 'Placed');
    
    
SELECT
    o.order_id,
    c.customer_name,
    r.restaurant_name,
    o.order_time,
    o.order_amount,
    o.order_status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
ORDER BY o.order_time;


SELECT
    COUNT(*) AS total_orders,
    SUM(order_amount) AS total_order_value,
    ROUND(AVG(order_amount), 2) AS average_order_value,
    SUM(order_status = 'Cancelled') AS cancelled_orders
FROM orders;





