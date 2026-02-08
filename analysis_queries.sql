/* =============================================================================
RETAIL ANALYTICS - MS SQL SERVER (T-SQL) SCRIPT
Description: Database setup, data cleaning, and business intelligence queries.
=============================================================================
*/

-- 1. DATABASE ARCHITECTURE & SCHEMA DESIGN
-- ========================================

-- Check if database exists, if not create it (Best practice for re-running scripts)
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'retail_analytics_db')
BEGIN
    CREATE DATABASE retail_analytics_db;
END
GO

USE retail_analytics_db;
GO

-- Designing the transaction table
-- Note: Dropping table if it exists to allow fresh creation
IF OBJECT_ID('dbo.sales_transactions', 'U') IS NOT NULL
DROP TABLE dbo.sales_transactions;
GO

CREATE TABLE sales_transactions (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(15),
    age INT,
    product_category VARCHAR(50),
    quantity_sold INT,
    price_per_unit DECIMAL(10,2),	
    cogs DECIMAL(10,2),
    total_revenue DECIMAL(10,2)
);
GO

-- 2. DATA CLEANING & INTEGRITY AUDIT
-- ==================================

-- Identifying records with missing critical information
SELECT * FROM sales_transactions
WHERE 
    sale_date IS NULL OR 
    customer_id IS NULL OR 
    product_category IS NULL OR 
    total_revenue IS NULL;
GO

-- Removing incomplete records to maintain data accuracy
DELETE FROM sales_transactions
WHERE 
    sale_date IS NULL OR 
    customer_id IS NULL OR 
    product_category IS NULL OR 
    total_revenue IS NULL;
GO

-- 3. BUSINESS ANALYSIS & INTELLIGENCE (FULL REPORT)
-- =================================================

-- I. Specific Date Transaction Audit
-- Objective: Retrieve all transaction details for '2022-11-05'.
SELECT * FROM sales_transactions 
WHERE sale_date = '2022-11-05';
GO

-- II. High-Volume Clothing Sales (Nov-2022)
-- Objective: Identify bulk transactions in 'Clothing' (4+ units) in Nov 2022.
-- Note: Used FORMAT function for date string matching in MS SQL.
SELECT *
FROM sales_transactions
WHERE product_category = 'Clothing'
    AND FORMAT(sale_date, 'yyyy-MM') = '2022-11'
    AND quantity_sold >= 4;
GO

-- III. Revenue Contribution by Category
-- Objective: Calculate total revenue and order count per category.
SELECT 
    product_category,
    SUM(total_revenue) as net_revenue,
    COUNT(*) as total_orders
FROM sales_transactions
GROUP BY product_category
ORDER BY net_revenue DESC;
GO

-- IV. Beauty Category Demographic Study
-- Objective: Average age of consumers in 'Beauty'.
-- Note: Cast 'age' to DECIMAL because MS SQL returns an Integer average for Integer columns.
SELECT
    ROUND(AVG(CAST(age AS DECIMAL(10,2))), 2) as avg_customer_age
FROM sales_transactions
WHERE product_category = 'Beauty';
GO

-- V. High-Value Transaction Identification
-- Objective: Isolate transactions where revenue > 1000.
SELECT * FROM sales_transactions 
WHERE total_revenue > 1000;
GO

-- VI. Gender Distribution by Product Category
-- Objective: Analyze transaction volume by gender.
SELECT 
    product_category,
    gender,
    COUNT(*) as transaction_count
FROM sales_transactions
GROUP BY product_category, gender
ORDER BY product_category;
GO

-- VII. Sales Seasonality & Peak Month Analysis
-- Objective: Identify the highest-performing month for each year.
-- Note: Replaced EXTRACT with YEAR() and MONTH().
WITH MonthlyPerformance AS (
    SELECT 
        YEAR(sale_date) as sales_year,
        MONTH(sale_date) as sales_month,
        AVG(total_revenue) as avg_monthly_sale,
        RANK() OVER(
            PARTITION BY YEAR(sale_date) 
            ORDER BY AVG(total_revenue) DESC
        ) as performance_rank
    FROM sales_transactions
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT 
    sales_year, 
    sales_month, 
    avg_monthly_sale
FROM MonthlyPerformance
WHERE performance_rank = 1;
GO

-- VIII. Top Tier Customer Analysis
-- Objective: Identify top 5 customers by spend.
-- Note: Replaced LIMIT with TOP.
SELECT TOP 5
    customer_id,
    SUM(total_revenue) as lifetime_value
FROM sales_transactions
GROUP BY customer_id
ORDER BY lifetime_value DESC;
GO

-- IX. Market Penetration: Unique Customers per Category
-- Objective: Count unique customers per category.
SELECT 
    product_category,    
    COUNT(DISTINCT customer_id) as unique_consumer_count
FROM sales_transactions
GROUP BY product_category;
GO

-- X. Operational Efficiency: Shift-Based Order Volume
-- Objective: Segment orders into Morning, Afternoon, and Evening.
-- Note: Replaced EXTRACT(HOUR) with DATEPART(HOUR, ...).
WITH ShiftData AS (
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END as operational_shift
    FROM sales_transactions
)
SELECT 
    operational_shift,
    COUNT(*) as total_order_volume
FROM ShiftData
GROUP BY operational_shift;
GO
