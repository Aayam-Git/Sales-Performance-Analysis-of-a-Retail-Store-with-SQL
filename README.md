# Sales-Performance-Analysis-of-a-Retail-Store-with-SQL
Deep-dive analysis of retail transaction data to uncover actionable business insights

## Project Overview
This project involves a deep-dive analysis of retail transaction data to uncover actionable business insights. As a Business Analyst, my goal was to transform raw sales records into a structured database, perform rigorous data cleaning, and execute complex SQL queries to identify trends, high-value customers, and departmental performance.

## Core Objectives
- Infrastructure: Architected a relational database schema to house 1,000+ retail transactions.

- Data Quality Assurance: Performed ETL (Extract, Transform, Load) processes to identify and handle missing values, ensuring data integrity for downstream reporting.

- Exploratory Data Analysis (EDA): Conducted descriptive statistics to understand customer demographics and purchasing power.

- Business Intelligence: Developed SQL scripts to solve real-world business problems regarding sales seasonality and customer segmentation.

## Key Business Findings
- Revenue Concentration: The 'Clothing' and 'Beauty' sectors contributed to over 60% of total revenue.

- Customer Loyalty: The top 5 customers contributed significantly to total sales, suggesting a need for a targeted retention program.

- Operational Efficiency: The 'Evening' shift consistently handles the highest volume of transactions, indicating a need for optimized staffing during these hours.

<img src = "presentation image.png" alt="Banner image" width="1000"/>

## Script Structure & Key Features
#### The SQL script is divided into three main operational phases:

1. Database Architecture
- Environment Setup: Checks for the existence of retail_analytics_db and creates it if missing.
- Table Definition: Defines the sales_transactions table using the columns listed above.

2. Data Cleaning & Integrity
- Null Value Audit: Scans critical fields (sale_date, customer_id, category, total_sale) for missing data.
- Data Pruning: Automatically removes records with null values in essential columns to maintain statistical accuracy.

3. Business Intelligence & Reporting

- The script executes 10 strategic queries to answer key business questions:
- Specific Date Audit: Performance check for specific high-traffic dates.
- High-Volume Sales: Identification of bulk purchases (4+ items) in the Clothing category.
- Category Revenue: Net revenue and order volume breakdown by product category.
- Demographic Analysis: Average age of customers in the Beauty sector.
- Premium Transactions: Isolation of high-value transactions (> $1000).
- Gender Analysis: Purchasing patterns broken down by gender and category.
- Seasonal Peaks: Identification of the highest-performing month for each year.
- Customer Loyalty: Top 5 customers based on lifetime value (LTV).
- Market Reach: Count of unique customers per product category.
- Operational Shift Analysis: Distribution of orders across Morning, Afternoon, and Evening shifts.

## Key SQL Concepts Used
- Aggregations: SUM, AVG, COUNT
- Window Functions: RANK() OVER (PARTITION BY ...) for year-over-year analysis.
- Date Functions: DATEPART, FORMAT, YEAR, MONTH.
- Conditional Logic: CASE statements for shift segmentation.
- Type Conversion: CAST for precise decimal arithmetic.
