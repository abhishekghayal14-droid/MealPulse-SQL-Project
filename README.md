# MealPulse — Food Delivery Delay & Customer Churn Analysis

## Project Overview
MealPulse is a SQL-based data analytics project that explores food delivery performance, customer feedback, and customer inactivity using MySQL.

## Business Problems
- How often are deliveries late?
- How do late deliveries relate to customer ratings?
- Which customers may be at risk of churning?
- How can delivery and customer data support better business decisions?

## Database Tables
- `customers` — customer information
- `delivery_zones` — delivery areas and traffic levels
- `restaurants` — restaurant details and preparation times
- `orders` — order details and statuses
- `deliveries` — promised and actual delivery times
- `customer_feedback` — ratings and feedback categories

## SQL Skills Demonstrated
- CREATE TABLE and INSERT INTO
- SELECT, filtering, sorting, and aggregation
- JOINs across related tables
- CASE expressions
- Date and time calculations with `DATEDIFF` and `TIMESTAMPDIFF`
- Customer inactivity classification
- Data constraints and relational keys

## Key Findings
- The sample contains delivery records with both on-time and late outcomes.
- Late deliveries can be compared with customer ratings.
- Customer inactivity can be used to identify customers who may need retention efforts.

## Methodology and Limitations
This project uses a small, simulated dataset for demonstration and learning. The 30-day inactivity rule is a proxy for potential churn, not confirmed customer churn. Results should not be treated as production business metrics.

## Files
- `01_schema.sql` — creates the database tables
- `02_sample_data.sql` — inserts sample data
- `03_analysis.sql` — contains analysis queries

## How to Run
1. Open MySQL Workbench.
2. Connect to your MySQL server.
3. Run `01_schema.sql` to create the tables.
4. Run `02_sample_data.sql` once to insert the sample data.
5. Run `03_analysis.sql` to explore the results.

Run the scripts in the order above. The sample data script is intended to be run once on a fresh schema to avoid duplicate records or key conflicts.

## Tools
- MySQL
- MySQL Workbench
- GitHub

## Author
SQL Data Analytics Portfolio Project
