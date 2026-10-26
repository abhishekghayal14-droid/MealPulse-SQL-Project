
USE mealpulse_db;

CREATE TABLE deliveries (
    delivery_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    promised_delivery_time DATETIME NOT NULL,
    actual_delivery_time DATETIME,
    weather_condition VARCHAR(20) NOT NULL,
    traffic_level VARCHAR(20) NOT NULL,
    distance_km DECIMAL(6,2) NOT NULL,
    delivery_status VARCHAR(20) NOT NULL DEFAULT 'Pending',

    CONSTRAINT fk_delivery_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT chk_delivery_distance
        CHECK (distance_km > 0),

    CONSTRAINT chk_delivery_status
        CHECK (delivery_status IN
            ('Delivered', 'Pending', 'Failed')),

    CONSTRAINT chk_weather
        CHECK (weather_condition IN
            ('Clear', 'Rain', 'Fog', 'Storm')),

    CONSTRAINT chk_traffic
        CHECK (traffic_level IN
            ('Low', 'Medium', 'High'))
);


INSERT INTO deliveries
    (order_id, promised_delivery_time, actual_delivery_time,
     weather_condition, traffic_level, distance_km, delivery_status)
VALUES
    (1, '2026-10-20 12:55:00', '2026-10-20 12:48:00', 'Clear', 'Low',    3.20, 'Delivered'),
    (2, '2026-10-20 14:00:00', '2026-10-20 14:25:00', 'Rain',  'High',   5.50, 'Delivered'),
    (3, '2026-10-20 19:45:00', '2026-10-20 20:05:00', 'Clear', 'Medium', 2.80, 'Delivered'),
    (4, '2026-10-21 21:00:00', '2026-10-21 20:55:00', 'Clear', 'High',  6.10, 'Delivered'),
    (6, '2026-10-22 14:10:00', '2026-10-22 14:45:00', 'Rain',  'High',   4.70, 'Delivered'),
    (7, '2026-10-22 20:25:00', '2026-10-22 20:20:00', 'Clear', 'Low',    2.10, 'Delivered'),
    (8, '2026-10-23 13:20:00', NULL,                  'Fog',   'High',   7.20, 'Pending'),
    (9, '2026-10-23 20:55:00', '2026-10-23 21:30:00', 'Storm', 'High',  8.50, 'Delivered'),
    (10,'2026-10-24 19:15:00', NULL,                  'Rain',  'Medium', 3.90, 'Pending');



SELECT * FROM deliveries;


SELECT
    order_id,
    promised_delivery_time,
    actual_delivery_time,
    TIMESTAMPDIFF(
        MINUTE,
        promised_delivery_time,
        actual_delivery_time
    ) AS delay_minutes
FROM deliveries
WHERE delivery_status = 'Delivered'
ORDER BY delay_minutes DESC;


SELECT
    COUNT(*) AS completed_deliveries,

    SUM(
        actual_delivery_time > promised_delivery_time
    ) AS late_deliveries,

    SUM(
        actual_delivery_time <= promised_delivery_time
    ) AS on_time_or_early,

    ROUND(
        100.0 * SUM(
            actual_delivery_time > promised_delivery_time
        ) / COUNT(*),
        2
    ) AS late_delivery_percentage

FROM deliveries
WHERE delivery_status = 'Delivered';


SELECT
    traffic_level,
    weather_condition,
    COUNT(*) AS completed_deliveries,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                MINUTE,
                promised_delivery_time,
                actual_delivery_time
            )
        ),
        2
    ) AS average_delay_minutes,

    SUM(
        actual_delivery_time > promised_delivery_time
    ) AS late_deliveries

FROM deliveries
WHERE delivery_status = 'Delivered'
GROUP BY traffic_level, weather_condition
ORDER BY average_delay_minutes DESC;

