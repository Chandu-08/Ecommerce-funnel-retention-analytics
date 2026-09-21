-- ==============================================================================
-- 06_funnel_analysis.sql
-- Description: Build an operational purchase funnel to understand drop-offs
--              at each stage: Purchased -> Approved -> Shipped -> Delivered -> Reviewed.
-- ==============================================================================

-- 1. Overall Funnel Definition
WITH funnel_stages AS (
    SELECT
        COUNT(order_id) AS total_purchased,
        COUNT(order_approved_at) AS total_approved,
        COUNT(order_delivered_carrier_date) AS total_shipped,
        COUNT(order_delivered_customer_date) AS total_delivered,
        -- Need to check if there is a review for the order
        SUM(CASE WHEN review_score IS NOT NULL THEN 1 ELSE 0 END) AS total_reviewed
    FROM analytical_orders
)
SELECT 
    '1. Purchased' AS funnel_stage, total_purchased AS orders FROM funnel_stages
UNION ALL
SELECT 
    '2. Approved' AS funnel_stage, total_approved FROM funnel_stages
UNION ALL
SELECT 
    '3. Shipped' AS funnel_stage, total_shipped FROM funnel_stages
UNION ALL
SELECT 
    '4. Delivered' AS funnel_stage, total_delivered FROM funnel_stages
UNION ALL
SELECT 
    '5. Reviewed' AS funnel_stage, total_reviewed FROM funnel_stages;

-- 2. Advanced Funnel Analysis with Conversion Rates
WITH funnel_counts AS (
    SELECT
        CAST(COUNT(order_id) AS FLOAT) AS purchased,
        CAST(COUNT(order_approved_at) AS FLOAT) AS approved,
        CAST(COUNT(order_delivered_carrier_date) AS FLOAT) AS shipped,
        CAST(COUNT(order_delivered_customer_date) AS FLOAT) AS delivered,
        CAST(SUM(CASE WHEN review_score IS NOT NULL THEN 1 ELSE 0 END) AS FLOAT) AS reviewed
    FROM analytical_orders
)
SELECT 
    'Purchased -> Approved' AS funnel_step,
    (purchased - approved) AS absolute_drop_off,
    100.0 - (approved / NULLIF(purchased, 0) * 100.0) AS drop_off_pct,
    (approved / NULLIF(purchased, 0)) * 100.0 AS conversion_pct
FROM funnel_counts
UNION ALL
SELECT 
    'Approved -> Shipped' AS funnel_step,
    (approved - shipped) AS absolute_drop_off,
    100.0 - (shipped / NULLIF(approved, 0) * 100.0) AS drop_off_pct,
    (shipped / NULLIF(approved, 0)) * 100.0 AS conversion_pct
FROM funnel_counts
UNION ALL
SELECT 
    'Shipped -> Delivered' AS funnel_step,
    (shipped - delivered) AS absolute_drop_off,
    100.0 - (delivered / NULLIF(shipped, 0) * 100.0) AS drop_off_pct,
    (delivered / NULLIF(shipped, 0)) * 100.0 AS conversion_pct
FROM funnel_counts
UNION ALL
SELECT 
    'Delivered -> Reviewed' AS funnel_step,
    (delivered - reviewed) AS absolute_drop_off,
    100.0 - (reviewed / NULLIF(delivered, 0) * 100.0) AS drop_off_pct,
    (reviewed / NULLIF(delivered, 0)) * 100.0 AS conversion_pct
FROM funnel_counts;

-- Note: A drop-off at the 'Delivered -> Reviewed' stage simply means the customer 
-- did not leave a review. It does NOT automatically imply dissatisfaction.

-- 3. Funnel by State
SELECT 
    customer_state,
    COUNT(order_id) AS purchased,
    COUNT(order_delivered_customer_date) AS delivered,
    CAST(COUNT(order_delivered_customer_date) AS FLOAT) / NULLIF(COUNT(order_id), 0) * 100.0 AS delivery_conversion_pct
FROM analytical_orders
GROUP BY customer_state
ORDER BY delivery_conversion_pct ASC;
