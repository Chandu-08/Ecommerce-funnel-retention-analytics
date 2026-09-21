-- ==============================================================================
-- 01_staging_load.sql
-- Description: Create staging tables for Olist E-Commerce Dataset and
--              load data from CSV files.
-- ==============================================================================

-- Drop existing tables if they exist
IF OBJECT_ID('stg_orders', 'U') IS NOT NULL DROP TABLE stg_orders;
IF OBJECT_ID('stg_order_items', 'U') IS NOT NULL DROP TABLE stg_order_items;
IF OBJECT_ID('stg_order_payments', 'U') IS NOT NULL DROP TABLE stg_order_payments;
IF OBJECT_ID('stg_order_reviews', 'U') IS NOT NULL DROP TABLE stg_order_reviews;
IF OBJECT_ID('stg_customers', 'U') IS NOT NULL DROP TABLE stg_customers;
IF OBJECT_ID('stg_products', 'U') IS NOT NULL DROP TABLE stg_products;
IF OBJECT_ID('stg_product_category_name_translation', 'U') IS NOT NULL DROP TABLE stg_product_category_name_translation;

-- 1. Orders
CREATE TABLE stg_orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(20),
    order_purchase_timestamp DATETIME2,
    order_approved_at DATETIME2,
    order_delivered_carrier_date DATETIME2,
    order_delivered_customer_date DATETIME2,
    order_estimated_delivery_date DATETIME2
);

-- 2. Order Items
CREATE TABLE stg_order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date DATETIME2,
    price DECIMAL(10, 2),
    freight_value DECIMAL(10, 2)
);

-- 3. Order Payments
CREATE TABLE stg_order_payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value DECIMAL(10, 2)
);

-- 4. Order Reviews
CREATE TABLE stg_order_reviews (
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title NVARCHAR(MAX),
    review_comment_message NVARCHAR(MAX),
    review_creation_date DATETIME2,
    review_answer_timestamp DATETIME2
);

-- 5. Customers
CREATE TABLE stg_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state VARCHAR(5)
);

-- 6. Products
CREATE TABLE stg_products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- 7. Product Category Translation
CREATE TABLE stg_product_category_name_translation (
    product_category_name VARCHAR(100),
    product_category_name_english VARCHAR(100)
);

-- Note: Data loading would typically be done via SQL Server Import Wizard, SSIS, 
-- or BULK INSERT. Example for BULK INSERT:
/*
BULK INSERT stg_orders
FROM 'C:\Path\To\Data\olist_orders_dataset.csv'
WITH (
    FORMAT='CSV',
    FIRSTROW=2,
    FIELDTERMINATOR=',',
    ROWTERMINATOR='\n'
);
*/
