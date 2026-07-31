/*
===============================================================================
Script Name : load_silver.sql (Bronze -> Silver)
===============================================================================
Purpose:
    Loads transformed and cleansed data from Bronze layer into Silver layer.

Description:
    - Truncates existing Silver tables before loading.
    - Performs data cleansing and standardization operations.
    - Applies business rules and data quality transformations.
    - Handles deduplication using ROW_NUMBER() window function.
    - Normalizes values (marital status, gender, product lines, countries).
    - Validates and corrects date fields and numeric calculations.
    - Captures execution time for each table load.

Tables Processed:
    CRM Tables:
        - silver.crm_cust_info       (Customer master data)
        - silver.crm_prd_info        (Product master data)
        - silver.crm_sales_details   (Sales transaction data)
    
    ERP Tables:
        - silver.erp_cust_az12       (Customer extension data)
        - silver.erp_loc_a101        (Location data)
        - silver.erp_px_cat_g1v2     (Product category data)

Execution:
    EXEC silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN

    DECLARE
        @TableStartTime DATETIME,
        @TableEndTime DATETIME,
        @BatchStartTime DATETIME,
        @BatchEndTime DATETIME;

    BEGIN TRY

        SET @BatchStartTime = GETDATE();

        PRINT '============================================================';
        PRINT 'Starting Silver Layer Data Load';
        PRINT '============================================================';

        -----------------------------------------------------------------------
        -- CRM DATA
        -----------------------------------------------------------------------

        PRINT '';
        PRINT 'Loading CRM Tables...';

        -----------------------------------------------------------------------
        -- Customer Information
        -----------------------------------------------------------------------

        SET @TableStartTime = GETDATE();

        PRINT 'Refreshing Table : silver.crm_cust_info';

        TRUNCATE TABLE silver.crm_cust_info;

        INSERT INTO silver.crm_cust_info (
            cst_id, 
            cst_key, 
            cst_firstname, 
            cst_lastname, 
            cst_marital_status, 
            cst_gndr,
            cst_create_date
        )
        SELECT
            cst_id,
            cst_key,
            TRIM(cst_firstname) AS cst_firstname,
            TRIM(cst_lastname) AS cst_lastname,
            CASE 
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                ELSE 'n/a'
            END AS cst_marital_status,
            CASE 
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'n/a'
            END AS cst_gndr,
            cst_create_date
        FROM (
            SELECT
                *,
                ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) t
        WHERE flag_last = 1;

        SET @TableEndTime = GETDATE();

        PRINT 'Completed in '
            + CAST(DATEDIFF(SECOND, @TableStartTime, @TableEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '------------------------------------------------------------';

        -----------------------------------------------------------------------
        -- Product Information
        -----------------------------------------------------------------------

        SET @TableStartTime = GETDATE();

        PRINT 'Refreshing Table : silver.crm_prd_info';

        TRUNCATE TABLE silver.crm_prd_info;

        INSERT INTO silver.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT
            prd_id,
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
            SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
            prd_nm,
            ISNULL(prd_cost, 0) AS prd_cost,
            CASE 
                WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                ELSE 'n/a'
            END AS prd_line,
            CAST(prd_start_dt AS DATE) AS prd_start_dt,
            CAST(
                LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 
                AS DATE
            ) AS prd_end_dt
        FROM bronze.crm_prd_info;

        SET @TableEndTime = GETDATE();

        PRINT 'Completed in '
            + CAST(DATEDIFF(SECOND, @TableStartTime, @TableEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '------------------------------------------------------------';

        -----------------------------------------------------------------------
        -- Sales Details
        -----------------------------------------------------------------------

        SET @TableStartTime = GETDATE();

        PRINT 'Refreshing Table : silver.crm_sales_details';

        TRUNCATE TABLE silver.crm_sales_details;

        INSERT INTO silver.crm_sales_details (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        )
        SELECT 
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            CASE 
                WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
            END AS sls_order_dt,
            CASE 
                WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
            END AS sls_ship_dt,
            CASE 
                WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
                ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
            END AS sls_due_dt,
            CASE 
                WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
                    THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END AS sls_sales,
            sls_quantity,
            CASE 
                WHEN sls_price IS NULL OR sls_price <= 0 
                    THEN sls_sales / NULLIF(sls_quantity, 0)
                ELSE sls_price
            END AS sls_price
        FROM bronze.crm_sales_details;

        SET @TableEndTime = GETDATE();

        PRINT 'Completed in '
            + CAST(DATEDIFF(SECOND, @TableStartTime, @TableEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '------------------------------------------------------------';

        -----------------------------------------------------------------------
        -- ERP DATA
        -----------------------------------------------------------------------

        PRINT '';
        PRINT 'Loading ERP Tables...';

        -----------------------------------------------------------------------
        -- Customer Data
        -----------------------------------------------------------------------

        SET @TableStartTime = GETDATE();

        PRINT 'Refreshing Table : silver.erp_cust_az12';

        TRUNCATE TABLE silver.erp_cust_az12;

        INSERT INTO silver.erp_cust_az12 (
            cid,
            bdate,
            gen
        )
        SELECT
            CASE
                WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
                ELSE cid
            END AS cid, 
            CASE
                WHEN bdate > GETDATE() THEN NULL
                ELSE bdate
            END AS bdate,
            CASE
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'n/a'
            END AS gen
        FROM bronze.erp_cust_az12;

        SET @TableEndTime = GETDATE();

        PRINT 'Completed in '
            + CAST(DATEDIFF(SECOND, @TableStartTime, @TableEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '------------------------------------------------------------';

        -----------------------------------------------------------------------
        -- Location Data
        -----------------------------------------------------------------------

        SET @TableStartTime = GETDATE();

        PRINT 'Refreshing Table : silver.erp_loc_a101';

        TRUNCATE TABLE silver.erp_loc_a101;

        INSERT INTO silver.erp_loc_a101 (
            cid,
            cntry
        )
        SELECT
            REPLACE(cid, '-', '') AS cid, 
            CASE
                WHEN TRIM(cntry) = 'DE' THEN 'Germany'
                WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
                WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
                ELSE TRIM(cntry)
            END AS cntry
        FROM bronze.erp_loc_a101;

        SET @TableEndTime = GETDATE();

        PRINT 'Completed in '
            + CAST(DATEDIFF(SECOND, @TableStartTime, @TableEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '------------------------------------------------------------';

        -----------------------------------------------------------------------
        -- Product Category
        -----------------------------------------------------------------------

        SET @TableStartTime = GETDATE();

        PRINT 'Refreshing Table : silver.erp_px_cat_g1v2';

        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        INSERT INTO silver.erp_px_cat_g1v2 (
            id,
            cat,
            subcat,
            maintenance
        )
        SELECT
            id,
            cat,
            subcat,
            maintenance
        FROM bronze.erp_px_cat_g1v2;

        SET @TableEndTime = GETDATE();

        PRINT 'Completed in '
            + CAST(DATEDIFF(SECOND, @TableStartTime, @TableEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '------------------------------------------------------------';

        -----------------------------------------------------------------------
        -- Batch Summary
        -----------------------------------------------------------------------

        SET @BatchEndTime = GETDATE();

        PRINT '';
        PRINT '============================================================';
        PRINT 'Silver Layer Load Completed Successfully';
        PRINT 'Total Execution Time : '
            + CAST(DATEDIFF(SECOND, @BatchStartTime, @BatchEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '============================================================';

    END TRY

    BEGIN CATCH

        PRINT '';
        PRINT '============================================================';
        PRINT 'Silver Layer Load Failed';
        PRINT '============================================================';

        PRINT 'Message   : ' + ERROR_MESSAGE();
        PRINT 'Number    : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Severity  : ' + CAST(ERROR_SEVERITY() AS NVARCHAR);
        PRINT 'State     : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT 'Line      : ' + CAST(ERROR_LINE() AS NVARCHAR);
        PRINT 'Procedure : ' + ISNULL(ERROR_PROCEDURE(), 'N/A');

        PRINT '============================================================';

    END CATCH

END;
GO
