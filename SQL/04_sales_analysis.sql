-- ==============================================================================
-- 04_sales_analysis.sql
-- Description: Calculate main business KPIs including Revenue, Orders, Customers, 
--              and Average Order Value.
-- ==============================================================================

-- Define valid orders for sales analysis
-- (Assuming 'delivered' and 'shipped' contribute to valid revenue)
WITH valid_orders AS (
    SELECT *
    FROM analytical_orders
    WHERE order_status IN ('delivered', 'shipped')
)

-- 1. High-Level KPIs
SELECT 
    SUM(payment_value) AS total_revenue,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_unique_id) AS total_customers,
    SUM(payment_value) / NULLIF(COUNT(DISTINCT order_id), 0) AS average_order_value,
    SUM(payment_value) / NULLIF(COUNT(DISTINCT customer_unique_id), 0) AS revenue_per_customer,
    CAST(COUNT(DISTINCT order_id) AS FLOAT) / NULLIF(COUNT(DISTINCT customer_unique_id), 0) AS orders_per_customer
FROM valid_orders;

-- 2. Monthly Revenue and Order Trends
SELECT 
    FORMAT(order_purchase_timestamp, 'yyyy-MM') AS order_month,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(payment_value) AS total_revenue
FROM valid_orders
GROUP BY FORMAT(order_purchase_timestamp, 'yyyy-MM')
ORDER BY order_month;

-- 3. Performance by State
SELECT 
    customer_state,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(payment_value) AS total_revenue,
    SUM(payment_value) / NULLIF(COUNT(DISTINCT order_id), 0) AS average_order_value
FROM valid_orders
GROUP BY customer_state
ORDER BY total_revenue DESC;

-- 4. Category Performance (Requires re-joining to items and products)
-- Note: Since our analytical_orders is order-grain, to get category revenue
-- we need to join order_items back, or build a separate item-grain view.
-- Here we demonstrate item-grain category revenue.
SELECT 
    COALESCE(t.product_category_name_english, p.product_category_name, 'Unknown') AS product_category,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price) AS total_item_revenue
FROM stg_order_items oi
JOIN valid_orders o ON oi.order_id = o.order_id
LEFT JOIN stg_products p ON oi.product_id = p.product_id
LEFT JOIN stg_product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY COALESCE(t.product_category_name_english, p.product_category_name, 'Unknown')
ORDER BY total_item_revenue DESC;
