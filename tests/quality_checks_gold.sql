/*
===============================================================================
Script Name : gold_quality_checks.sql
===============================================================================
Purpose:
    Validates the integrity and consistency of the Gold layer to ensure that
    the dimensional model is accurate, complete, and ready for analytics.

Description:
    This script performs quality checks on the Gold layer, including:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Validation of relationships within the Star Schema.

Execution:
    Execute this script after creating the Gold layer views.
    Review and resolve any records returned by these validation queries.
===============================================================================
*/

-------------------------------------------------------------------------------
-- CUSTOMER DIMENSION
-------------------------------------------------------------------------------

PRINT 'Validating: gold.dim_customers';

-- Verify Customer Key Uniqueness
-- Expected Result: No rows returned
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-------------------------------------------------------------------------------
-- PRODUCT DIMENSION
-------------------------------------------------------------------------------

PRINT 'Validating: gold.dim_products';

-- Verify Product Key Uniqueness
-- Expected Result: No rows returned
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-------------------------------------------------------------------------------
-- SALES FACT
-------------------------------------------------------------------------------

PRINT 'Validating: gold.fact_sales';

-- Validate Relationships Between Fact and Dimension Tables
-- Expected Result: No rows returned
SELECT
    *
FROM gold.fact_sales AS fs
LEFT JOIN gold.dim_customers AS dc
    ON fs.customer_key = dc.customer_key
LEFT JOIN gold.dim_products AS dp
    ON fs.product_key = dp.product_key
WHERE dc.customer_key IS NULL
   OR dp.product_key IS NULL;

-------------------------------------------------------------------------------
-- END OF QUALITY CHECKS
-------------------------------------------------------------------------------

PRINT '============================================================';
PRINT 'Gold Layer Quality Validation Completed';
PRINT 'Review any returned records before using the data for reporting.';
PRINT '============================================================';
