-- ==============================================================================
-- 03_order_grain.sql
-- Description: Consolidate one-to-many relationships (items, payments) into a 
--              single order-level analytical table. Target Grain: 1 Row = 1 Order.
-- ==============================================================================

IF OBJECT_ID('analytical_orders', 'U') IS NOT NULL DROP TABLE analytical_orders;

-- 1. Aggregate Order Items
WITH order_items_agg AS (
    SELECT 
        order_id,
        SUM(price) as total_items_value,
        SUM(freight_value) as total_freight_value,
        COUNT(order_item_id) as total_items_qty
    FROM stg_order_items
    GROUP BY order_id
),

-- 2. Aggregate Order Payments
order_payments_agg AS (
    SELECT 
        order_id,
        SUM(payment_value) as total_payment_value,
        COUNT(payment_sequential) as total_payment_installments
    FROM stg_order_payments
    WHERE payment_value > 0 -- Filter invalid payments
    GROUP BY order_id
),

-- 3. Aggregate Order Reviews (take latest review if multiple exist, or avg score)
order_reviews_agg AS (
    SELECT 
        order_id,
        MAX(review_score) as review_score -- Simplified: taking max score if multiple
    FROM stg_order_reviews
    GROUP BY order_id
)

-- 4. Final Order-Level Consolidation
SELECT 
    o.order_id,
    o.customer_id,
    c.customer_unique_id,
    c.customer_state,
    c.customer_city,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    
    -- Financials from Items
    ISNULL(oi.total_items_value, 0) as items_value,
    ISNULL(oi.total_freight_value, 0) as freight_value,
    (ISNULL(oi.total_items_value, 0) + ISNULL(oi.total_freight_value, 0)) as order_value_calculated,
    
    -- Financials from Payments
    ISNULL(op.total_payment_value, 0) as payment_value,
    
    -- Quantities and Scores
    ISNULL(oi.total_items_qty, 0) as items_qty,
    orv.review_score

INTO analytical_orders
FROM stg_orders o
LEFT JOIN stg_customers c 
    ON o.customer_id = c.customer_id
LEFT JOIN order_items_agg oi 
    ON o.order_id = oi.order_id
LEFT JOIN order_payments_agg op 
    ON o.order_id = op.order_id
LEFT JOIN order_reviews_agg orv 
    ON o.order_id = orv.order_id
WHERE o.order_purchase_timestamp IS NOT NULL;

-- Note on Revenue discrepancy: 
-- In Olist, sometimes total payment value != items_value + freight_value due to discounts/vouchers.
-- We will use payment_value as the definitive revenue metric for completed orders.
