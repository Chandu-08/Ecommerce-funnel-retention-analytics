-- ==============================================================================
-- 02_data_quality.sql
-- Description: Perform data quality checks to identify duplicates, missing values,
--              and anomalies before analysis.
-- ==============================================================================

-- 1. Check for Duplicate Order IDs in Orders table
SELECT order_id, COUNT(*) as record_count
FROM stg_orders
GROUP BY order_id
HAVING COUNT(*) > 1;
-- Problem: Duplicate order records.
-- Detection method: GROUP BY order_id HAVING COUNT > 1.
-- Business impact: Overstatement of orders and revenue.
-- Treatment: If duplicates exist, filter them out using ROW_NUMBER() in the modeling phase.

-- 2. Check for Duplicate Customer IDs
SELECT customer_id, COUNT(*) as record_count
FROM stg_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 3. Check for Missing Order Dates (Purchase Date)
SELECT COUNT(*) as missing_purchase_date
FROM stg_orders
WHERE order_purchase_timestamp IS NULL;

-- 4. Check for Missing Delivery Dates for Delivered Orders
SELECT COUNT(*) as missing_delivery_date
FROM stg_orders
WHERE order_status = 'delivered' 
  AND order_delivered_customer_date IS NULL;
-- Problem: Delivered orders without a delivery date.
-- Detection method: Filtering by status 'delivered' and NULL delivery date.
-- Business impact: Skews funnel analysis for the Delivery stage.
-- Treatment: Exclude these specific records from delivery-time metrics or investigate source system.

-- 5. Invalid Order Statuses
SELECT order_status, COUNT(*) as order_count
FROM stg_orders
GROUP BY order_status;
-- Treatment: Only consider 'delivered' (and potentially 'shipped'/'invoiced' depending on logic) 
-- for revenue. Ignore 'canceled' and 'unavailable' for revenue metrics.

-- 6. Zero or Negative Payment Values
SELECT COUNT(*) as invalid_payments
FROM stg_order_payments
WHERE payment_value <= 0;
-- Problem: Payments with zero or negative amounts.
-- Detection method: payment_value <= 0.
-- Business impact: Understates or distorts revenue calculations.
-- Treatment: Filter out payments <= 0 in the order grain consolidation.

-- 7. Missing Review Scores
SELECT COUNT(*) as missing_review_scores
FROM stg_order_reviews
WHERE review_score IS NULL OR review_score < 1 OR review_score > 5;
-- Problem: Missing or invalid review scores.
-- Detection method: review_score IS NULL or outside 1-5.
-- Business impact: Inaccurate satisfaction metrics.
-- Treatment: Exclude invalid scores when calculating average review scores.

-- 8. Check Referential Integrity (Orphaned Items)
SELECT COUNT(*) as orphaned_items
FROM stg_order_items i
LEFT JOIN stg_orders o ON i.order_id = o.order_id
WHERE o.order_id IS NULL;
