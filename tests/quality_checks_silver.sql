/*
===============================================================================
Script Name : silver_quality_checks.sql
===============================================================================
Purpose:
    Validates data quality within the Silver layer after the ETL process.

Description:
    This script performs a series of validation checks to ensure that data
    loaded into the Silver layer is complete, accurate, standardized, and
    ready for downstream processing.

Validation Areas:
    - Primary Key Integrity
    - Duplicate Records
    - NULL Value Checks
    - Whitespace Validation
    - Data Standardization
    - Date Validation
    - Business Rule Validation
    - Data Consistency

Execution:
    Execute this script after running the Silver layer load procedure.
    Investigate and resolve any records returned by these queries.
===============================================================================
*/

-------------------------------------------------------------------------------
-- CRM CUSTOMER INFORMATION
-------------------------------------------------------------------------------

PRINT 'Validating: silver.crm_cust_info';

-- Check for Duplicate or NULL Customer IDs
-- Expected Result: No rows returned
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1
    OR cst_id IS NULL;

-- Check for Leading or Trailing Spaces
-- Expected Result: No rows returned
SELECT
    cst_key
FROM silver.crm_cust_info
WHERE cst_key <> TRIM(cst_key);

-- Validate Standardized Marital Status Values
SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info;

-- Validate Standardized Gender Values
SELECT DISTINCT
    cst_gndr
FROM silver.crm_cust_info;

-------------------------------------------------------------------------------
-- CRM PRODUCT INFORMATION
-------------------------------------------------------------------------------

PRINT 'Validating: silver.crm_prd_info';

-- Check for Duplicate or NULL Product IDs
-- Expected Result: No rows returned
SELECT
    prd_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1
    OR prd_id IS NULL;

-- Check Product Name Formatting
-- Expected Result: No rows returned
SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

-- Validate Product Cost
-- Expected Result: No rows returned
SELECT
    *
FROM silver.crm_prd_info
WHERE prd_cost IS NULL
   OR prd_cost < 0;

-- Validate Product Line Values
SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info;

-- Validate Product Date Range
-- Expected Result: No rows returned
SELECT
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-------------------------------------------------------------------------------
-- CRM SALES DETAILS
-------------------------------------------------------------------------------

PRINT 'Validating: silver.crm_sales_details';

-- Validate Raw Date Values
SELECT
    NULLIF(sls_due_dt,0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
   OR LEN(sls_due_dt) <> 8
   OR sls_due_dt < 19000101
   OR sls_due_dt > 20500101;

-- Validate Order Date Sequence
-- Expected Result: No rows returned
SELECT
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Validate Sales Calculations
-- Expected Result: No rows returned
SELECT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales <> sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY
    sls_sales,
    sls_quantity,
    sls_price;

-------------------------------------------------------------------------------
-- ERP CUSTOMER INFORMATION
-------------------------------------------------------------------------------

PRINT 'Validating: silver.erp_cust_az12';

-- Validate Birth Dates
-- Expected Result:
-- Birth date should be between 1924-01-01 and the current date.
SELECT
    DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();

-- Validate Gender Values
SELECT DISTINCT
    gen
FROM silver.erp_cust_az12;

-------------------------------------------------------------------------------
-- ERP CUSTOMER LOCATION
-------------------------------------------------------------------------------

PRINT 'Validating: silver.erp_loc_a101';

-- Validate Country Values
SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

-------------------------------------------------------------------------------
-- ERP PRODUCT CATEGORIES
-------------------------------------------------------------------------------

PRINT 'Validating: silver.erp_px_cat_g1v2';

-- Check for Leading or Trailing Spaces
-- Expected Result: No rows returned
SELECT
    *
FROM silver.erp_px_cat_g1v2
WHERE cat <> TRIM(cat)
   OR subcat <> TRIM(subcat)
   OR maintenance <> TRIM(maintenance);

-- Validate Maintenance Values
SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2;

-------------------------------------------------------------------------------
-- END OF QUALITY CHECKS
-------------------------------------------------------------------------------

PRINT '============================================================';
PRINT 'Silver Layer Quality Validation Completed';
PRINT 'Review any returned records before proceeding to the Gold Layer.';
PRINT '============================================================';
