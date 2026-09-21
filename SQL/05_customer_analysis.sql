-- ==============================================================================
-- 05_customer_analysis.sql
-- Description: Create a customer-level analytical dataset to understand 
--              repeat purchases and time between purchases.
-- ==============================================================================

IF OBJECT_ID('analytical_customers', 'U') IS NOT NULL DROP TABLE analytical_customers;

-- 1. Create Customer-Level Analytical Dataset
WITH valid_orders AS (
    SELECT *
    FROM analytical_orders
    WHERE order_status IN ('delivered', 'shipped')
)
SELECT 
    customer_unique_id,
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date,
    COUNT(DISTINCT order_id) AS order_count,
    SUM(payment_value) AS total_revenue,
    SUM(payment_value) / NULLIF(COUNT(DISTINCT order_id), 0) AS average_order_value,
    CASE 
        WHEN COUNT(DISTINCT order_id) > 1 THEN 1 
        ELSE 0 
    END AS is_repeat_customer
INTO analytical_customers
FROM valid_orders
GROUP BY customer_unique_id;

-- 2. Repeat Purchase Rate
SELECT 
    COUNT(customer_unique_id) AS total_customers,
    SUM(is_repeat_customer) AS repeat_customers,
    CAST(SUM(is_repeat_customer) AS FLOAT) / COUNT(customer_unique_id) * 100 AS repeat_purchase_rate_pct
FROM analytical_customers;

-- 3. Number of Orders by Repeat Customers
SELECT 
    order_count,
    COUNT(customer_unique_id) AS number_of_customers
FROM analytical_customers
GROUP BY order_count
ORDER BY order_count;

-- 4. Time to Second Purchase
-- Calculate the time difference between first and second order for repeat customers
WITH customer_orders AS (
    SELECT 
        customer_unique_id,
        order_purchase_timestamp,
        ROW_NUMBER() OVER(PARTITION BY customer_unique_id ORDER BY order_purchase_timestamp) AS order_rank
    FROM analytical_orders
    WHERE order_status IN ('delivered', 'shipped')
),
first_second_orders AS (
    SELECT 
        customer_unique_id,
        MAX(CASE WHEN order_rank = 1 THEN order_purchase_timestamp END) AS first_order_date,
        MAX(CASE WHEN order_rank = 2 THEN order_purchase_timestamp END) AS second_order_date
    FROM customer_orders
    WHERE order_rank <= 2
    GROUP BY customer_unique_id
    HAVING MAX(CASE WHEN order_rank = 2 THEN order_purchase_timestamp END) IS NOT NULL
)
SELECT 
    customer_unique_id,
    first_order_date,
    second_order_date,
    DATEDIFF(day, first_order_date, second_order_date) AS days_to_second_purchase
FROM first_second_orders;

-- 5. Average Time to Second Purchase
WITH customer_orders AS (
    SELECT 
        customer_unique_id,
        order_purchase_timestamp,
        ROW_NUMBER() OVER(PARTITION BY customer_unique_id ORDER BY order_purchase_timestamp) AS order_rank
    FROM analytical_orders
    WHERE order_status IN ('delivered', 'shipped')
),
time_to_second AS (
    SELECT 
        customer_unique_id,
        DATEDIFF(day, 
                 MAX(CASE WHEN order_rank = 1 THEN order_purchase_timestamp END), 
                 MAX(CASE WHEN order_rank = 2 THEN order_purchase_timestamp END)) AS days_to_second_purchase
    FROM customer_orders
    WHERE order_rank <= 2
    GROUP BY customer_unique_id
    HAVING MAX(CASE WHEN order_rank = 2 THEN order_purchase_timestamp END) IS NOT NULL
)
SELECT 
    AVG(days_to_second_purchase) AS avg_days_to_second_purchase
FROM time_to_second;
