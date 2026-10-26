
USE mealpulse_db;

CREATE TABLE customer_feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    customer_rating INT NOT NULL,
    feedback_category VARCHAR(30) NOT NULL,
    feedback_comment VARCHAR(255),
    feedback_date DATE NOT NULL,

    CONSTRAINT fk_feedback_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT chk_customer_rating
        CHECK (customer_rating BETWEEN 1 AND 5),

    CONSTRAINT chk_feedback_category
        CHECK (feedback_category IN (
            'Late Delivery',
            'Food Quality',
            'Packaging',
            'Good Experience',
            'Other'
        ))
);


INSERT INTO customer_feedback
    (order_id, customer_rating, feedback_category,
     feedback_comment, feedback_date)
VALUES
    (1, 5, 'Good Experience',
     'Delivered early and food was good', '2026-10-20'),
    (2, 2, 'Late Delivery',
     'Order arrived later than promised', '2026-10-20'),
    (3, 3, 'Late Delivery',
     'Delivery was slower than expected', '2026-10-20'),
    (4, 4, 'Good Experience',
     'Good food and service', '2026-10-21'),
    (6, 2, 'Late Delivery',
     'Long waiting time', '2026-10-22'),
    (7, 5, 'Good Experience',
     'Fast delivery', '2026-10-22'),
    (9, 1, 'Late Delivery',
     'Very late delivery', '2026-10-23');

SELECT * FROM customer_feedback;


SELECT
    CASE
        WHEN d.actual_delivery_time >
             d.promised_delivery_time
        THEN 'Late'
        ELSE 'On Time or Early'
    END AS delivery_performance,

    COUNT(*) AS feedback_count,
    ROUND(AVG(f.customer_rating), 2) AS average_rating

FROM customer_feedback f

JOIN deliveries d
    ON f.order_id = d.order_id

GROUP BY delivery_performance
ORDER BY average_rating;


SELECT
    c.customer_id,
    c.customer_name,
    MAX(o.order_time) AS last_order_time,
    COUNT(o.order_id) AS total_orders

FROM customers c

LEFT JOIN orders o
    ON c.customer_id = o.customer_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY last_order_time;



SELECT
    CASE
        WHEN d.actual_delivery_time >
             d.promised_delivery_time
        THEN 'Late'
        ELSE 'On Time or Early'
    END AS delivery_performance,

    COUNT(*) AS feedback_count,
    ROUND(AVG(f.customer_rating), 2) AS average_rating

FROM customer_feedback f

JOIN deliveries d
    ON f.order_id = d.order_id

GROUP BY delivery_performance
ORDER BY average_rating;



SELECT
    c.customer_id,
    c.customer_name,
    MAX(o.order_time) AS last_order_time,
    COUNT(o.order_id) AS total_orders

FROM customers c

LEFT JOIN orders o
    ON c.customer_id = o.customer_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY last_order_time;



INSERT INTO customers
    (customer_name, city, signup_date, customer_segment, is_active)
VALUES
    ('Neha Deshmukh', 'Aurangabad', '2026-06-01', 'At Risk', TRUE),
    ('Aditya Kulkarni', 'Aurangabad', '2026-05-15', 'Regular', TRUE),
    ('Isha Verma', 'Aurangabad', '2026-06-10', 'Regular', TRUE);



INSERT INTO orders
    (customer_id, restaurant_id, order_time,
     order_amount, order_status)
VALUES
    (6, 1, '2026-08-01 13:00:00', 350.00, 'Delivered'),
    (6, 3, '2026-08-15 19:00:00', 420.00, 'Delivered'),
    (7, 2, '2026-08-05 14:00:00', 300.00, 'Delivered'),
    (7, 4, '2026-08-20 20:00:00', 500.00, 'Delivered'),
    (8, 5, '2026-07-25 18:00:00', 650.00, 'Delivered'),
    (8, 1, '2026-08-10 12:30:00', 380.00, 'Delivered');


WITH customer_last_order AS (
    SELECT
        c.customer_id,
        c.customer_name,
        COUNT(o.order_id) AS total_orders,
        MAX(o.order_time) AS last_order_time
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
        AND o.order_status = 'Delivered'
    GROUP BY
        c.customer_id,
        c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_orders,
    last_order_time,
    DATEDIFF(
        '2026-10-26',
        DATE(last_order_time)
    ) AS days_since_last_order,
    CASE
        WHEN last_order_time IS NULL THEN 'No Order History'
        WHEN DATEDIFF(
            '2026-10-26',
            DATE(last_order_time)
        ) >= 30 THEN 'Churned'
        ELSE 'Active'
    END AS churn_status
FROM customer_last_order
ORDER BY days_since_last_order DESC;


WITH customer_last_order AS (
    SELECT
        c.customer_id,
        MAX(o.order_time) AS last_order_time
    FROM customers c
    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
        AND o.order_status = 'Delivered'
    GROUP BY c.customer_id
),
customer_status AS (
    SELECT
        customer_id,
        CASE
            WHEN last_order_time IS NULL
                THEN 'No Order History'
            WHEN DATEDIFF(
                '2026-10-26',
                DATE(last_order_time)
            ) >= 30
                THEN 'Churned'
            ELSE 'Active'
        END AS churn_status
    FROM customer_last_order
)
SELECT
    churn_status,
    COUNT(*) AS total_customers
FROM customer_status
GROUP BY churn_status
ORDER BY total_customers DESC;




CREATE OR REPLACE VIEW vw_delivery_performance AS
SELECT
    o.order_id,
    c.customer_id,
    c.customer_name,
    r.restaurant_name,
    z.zone_name,
    d.promised_delivery_time,
    d.actual_delivery_time,
    d.traffic_level,
    d.weather_condition,
    d.delivery_status,

    CASE
        WHEN d.delivery_status <> 'Delivered'
            THEN NULL
        WHEN d.actual_delivery_time >
             d.promised_delivery_time
            THEN 'Late'
        ELSE 'On Time or Early'
    END AS delivery_performance,

    CASE
        WHEN d.delivery_status <> 'Delivered'
            THEN NULL
        ELSE TIMESTAMPDIFF(
            MINUTE,
            d.promised_delivery_time,
            d.actual_delivery_time
        )
    END AS delay_minutes

FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
JOIN restaurants r
    ON o.restaurant_id = r.restaurant_id
JOIN delivery_zones z
    ON r.zone_id = z.zone_id
LEFT JOIN deliveries d
    ON o.order_id = d.order_id;
    
    
SELECT *
FROM vw_delivery_performance;


