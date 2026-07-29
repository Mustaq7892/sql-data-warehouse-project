/*
===============================================================================
Procedure Name : bronze.load_bronze
===============================================================================
Purpose:
    Loads raw data from CSV files into the 'Bronze' schema of the Data Warehouse.

Description:
    - Clears existing records from Bronze tables.
    - Imports the latest CRM and ERP datasets using BULK INSERT.
    - Captures execution time for each table load.
    - Displays a summary upon completion.
    - Reports detailed error information if the load fails.

Purpose:
    - This stored procedure does not accept any input parameters and does not return any values.

Usage Example:
    - EXEC bronze.load_bronze;

Warning:
    Update the file paths below if the source CSV files are stored in a
    different location.
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
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
        PRINT 'Starting Bronze Layer Data Load';
        PRINT '============================================================';

        -----------------------------------------------------------------------
        -- CRM DATA
        -----------------------------------------------------------------------

        PRINT '';
        PRINT 'Loading CRM Source Files...';

        -----------------------------------------------------------------------
        -- Customer Information
        -----------------------------------------------------------------------

        SET @TableStartTime = GETDATE();

        PRINT 'Refreshing Table : bronze.crm_cust_info';

        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\shaik\OneDrive\Desktop\SQL\data_warehouse_project\datasets\source_crm\cust_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @TableEndTime = GETDATE();

        PRINT 'Completed in '
            + CAST(DATEDIFF(SECOND, @TableStartTime, @TableEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '------------------------------------------------------------';

        -----------------------------------------------------------------------
        -- Product Information
        -----------------------------------------------------------------------

        SET @TableStartTime = GETDATE();

        PRINT 'Refreshing Table : bronze.crm_prd_info';

        TRUNCATE TABLE bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\shaik\OneDrive\Desktop\SQL\data_warehouse_project\datasets\source_crm\prd_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @TableEndTime = GETDATE();

        PRINT 'Completed in '
            + CAST(DATEDIFF(SECOND, @TableStartTime, @TableEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '------------------------------------------------------------';

        -----------------------------------------------------------------------
        -- Sales Details
        -----------------------------------------------------------------------

        SET @TableStartTime = GETDATE();

        PRINT 'Refreshing Table : bronze.crm_sales_details';

        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\shaik\OneDrive\Desktop\SQL\data_warehouse_project\datasets\source_crm\sales_details.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @TableEndTime = GETDATE();

        PRINT 'Completed in '
            + CAST(DATEDIFF(SECOND, @TableStartTime, @TableEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '------------------------------------------------------------';

        -----------------------------------------------------------------------
        -- ERP DATA
        -----------------------------------------------------------------------

        PRINT '';
        PRINT 'Loading ERP Source Files...';

        -----------------------------------------------------------------------
        -- Customer Data
        -----------------------------------------------------------------------

        SET @TableStartTime = GETDATE();

        PRINT 'Refreshing Table : bronze.erp_cust_az12';

        TRUNCATE TABLE bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\shaik\OneDrive\Desktop\SQL\data_warehouse_project\datasets\source_erp\CUST_AZ12.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @TableEndTime = GETDATE();

        PRINT 'Completed in '
            + CAST(DATEDIFF(SECOND, @TableStartTime, @TableEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '------------------------------------------------------------';

        -----------------------------------------------------------------------
        -- Location Data
        -----------------------------------------------------------------------

        SET @TableStartTime = GETDATE();

        PRINT 'Refreshing Table : bronze.erp_loc_a101';

        TRUNCATE TABLE bronze.erp_loc_a101;

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\shaik\OneDrive\Desktop\SQL\data_warehouse_project\datasets\source_erp\LOC_A101.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @TableEndTime = GETDATE();

        PRINT 'Completed in '
            + CAST(DATEDIFF(SECOND, @TableStartTime, @TableEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '------------------------------------------------------------';

        -----------------------------------------------------------------------
        -- Product Category
        -----------------------------------------------------------------------

        SET @TableStartTime = GETDATE();

        PRINT 'Refreshing Table : bronze.erp_px_cat_g1v2';

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\shaik\OneDrive\Desktop\SQL\data_warehouse_project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

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
        PRINT 'Bronze Layer Load Completed Successfully';
        PRINT 'Total Execution Time : '
            + CAST(DATEDIFF(SECOND, @BatchStartTime, @BatchEndTime) AS NVARCHAR)
            + ' second(s)';
        PRINT '============================================================';

    END TRY

    BEGIN CATCH

        PRINT '';
        PRINT '============================================================';
        PRINT 'Bronze Layer Load Failed';
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
