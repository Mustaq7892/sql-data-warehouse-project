/*
===============================================================================
Script Name :ddl_gold.sql
===============================================================================
Purpose:
    Creates the business-ready views for the Gold layer of the Data Warehouse.

Description:
    - Removes existing Gold views if they already exist.
    - Creates dimension and fact views following a Star Schema design.
    - Combines and transforms data from the Silver layer into analytical models.
    - Produces clean, enriched datasets optimized for reporting and Business Intelligence.

Execution:
    Execute this script after the Silver layer has been successfully loaded.
===============================================================================
*/

-------------------------------------------------------------------------------
-- CUSTOMER DIMENSION
-------------------------------------------------------------------------------

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers
AS

SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
    ci.cst_id           	AS customer_id,
    ci.cst_key         	    AS customer_number,
    ci.cst_firstname        AS first_name,
    ci.cst_lastname         AS last_name,
    la.cntry                AS country,
    ci.cst_marital_status   AS marital_status,
    CASE
        WHEN ci.cst_gndr <> 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END                     AS gender,
    ca.bdate                AS birthdate,
    ci.cst_create_date      AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
    ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
    ON ci.cst_key = la.cid;
GO

-------------------------------------------------------------------------------
-- PRODUCT DIMENSION
-------------------------------------------------------------------------------

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products
AS

SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id   		 AS product_id,
	pn.prd_key           AS product_number,
	pn.prd_nm            AS product_name,
	pn.cat_id            AS category_id,
	pc.cat               AS category,
	pc.subcat            AS subcategory,
	pc.maintenance       AS maintenance_required,
	pn.prd_cost          AS cost,
	pn.prd_line          AS product_line,
	pn.prd_start_dt      AS start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL;
GO

-------------------------------------------------------------------------------
-- SALES FACT
-------------------------------------------------------------------------------

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

CREATE VIEW gold.fact_sales
AS

SELECT
    sd.sls_ord_num      AS order_number,
    dp.product_key      AS product_key,
    dc.customer_key     AS customer_key,
    sd.sls_order_dt     AS order_date,
    sd.sls_ship_dt      AS shipping_date,
    sd.sls_due_dt       AS due_date,
    sd.sls_sales        AS sales_amount,
    sd.sls_quantity     AS quantity,
    sd.sls_price        AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products AS dp
    ON sd.sls_prd_key = dp.product_number
LEFT JOIN gold.dim_customers AS dc
    ON sd.sls_cust_id = dc.customer_id;
GO
