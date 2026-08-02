# 📚 Gold Layer Data Catalog

## Overview

The **Gold Layer** represents the business-ready data model of the data warehouse. It contains curated, analytics-ready datasets designed to support reporting, business intelligence, and data-driven decision-making.

The Gold Layer is organized into **dimension tables**, which provide descriptive business attributes, and **fact tables**, which capture measurable business events and transactional data.

---

# 👥 gold.dim_customers

### Purpose

The **gold.dim_customers** table stores customer master data enriched with demographic and geographic information. It serves as the customer dimension for analytical reporting and enables customer-centric analysis across the data warehouse.

### Columns

| Column Name | Data Type | Description |
|------------|-----------|-------------|
| **customer_key** | INT | Surrogate key that uniquely identifies each customer record within the dimension table. |
| **customer_id** | INT | Business identifier assigned to each customer in the source system. |
| **customer_number** | NVARCHAR(50) | Customer reference number used for business tracking and identification. |
| **first_name** | NVARCHAR(50) | Customer's first name. |
| **last_name** | NVARCHAR(50) | Customer's last name or family name. |
| **country** | NVARCHAR(50) | Customer's country or region of residence. |
| **marital_status** | NVARCHAR(50) | Customer's marital status (e.g., Married, Single). |
| **gender** | NVARCHAR(50) | Customer's gender (e.g., Male, Female, n/a). |
| **birthdate** | DATE | Customer's date of birth. |
| **create_date** | DATE | Date when the customer record was originally created in the source system. |

---

# 📦 gold.dim_products

### Purpose

The **gold.dim_products** table contains product master data enriched with category, subcategory, and product classification details. It enables product-based analysis, reporting, and business intelligence.

### Columns

| Column Name | Data Type | Description |
|------------|-----------|-------------|
| **product_key** | INT | Surrogate key that uniquely identifies each product within the dimension table. |
| **product_id** | INT | Business identifier assigned to each product. |
| **product_number** | NVARCHAR(50) | Unique product code used for identification and inventory tracking. |
| **product_name** | NVARCHAR(50) | Descriptive name of the product. |
| **category_id** | NVARCHAR(50) | Identifier representing the product category. |
| **category** | NVARCHAR(50) | High-level product classification (e.g., Bikes, Accessories, Components). |
| **subcategory** | NVARCHAR(50) | More detailed product classification within the category. |
| **maintenance_required** | NVARCHAR(50) | Indicates whether the product requires maintenance (e.g., Yes, No). |
| **cost** | INT | Standard cost associated with the product. |
| **product_line** | NVARCHAR(50) | Product line or series (e.g., Road, Mountain, Touring). |
| **start_date** | DATE | Date when the product became available. |

---

# 💰 gold.fact_sales

### Purpose

The **gold.fact_sales** table stores sales transactions and business measures used for analytical reporting. It links customers and products through dimension keys while capturing important sales metrics.

### Columns

| Column Name | Data Type | Description |
|------------|-----------|-------------|
| **order_number** | NVARCHAR(50) | Unique identifier assigned to each sales order. |
| **product_key** | INT | Foreign key referencing the **gold.dim_products** table. |
| **customer_key** | INT | Foreign key referencing the **gold.dim_customers** table. |
| **order_date** | DATE | Date on which the order was placed. |
| **shipping_date** | DATE | Date on which the order was shipped. |
| **due_date** | DATE | Payment due date for the order. |
| **sales_amount** | INT | Total sales amount for the transaction. |
| **quantity** | INT | Number of product units sold. |
| **price** | INT | Unit selling price of the product. |

---

## 📌 Data Model Summary

| Table | Category | Description |
|--------|----------|-------------|
| **gold.dim_customers** | Dimension | Stores customer demographic and geographic information for customer analysis. |
| **gold.dim_products** | Dimension | Stores product master data and classification details for product analysis. |
| **gold.fact_sales** | Fact | Stores transactional sales data and business metrics for reporting and analytics. |

---

## 🎯 Business Purpose

The Gold Layer provides a trusted, business-ready data model optimized for:

- Customer Analytics
- Product Performance Analysis
- Sales Reporting
- Business Intelligence (BI)
- Dashboard Development
- KPI Reporting
- Executive Decision-Making
- Self-Service Analytics

The tables in this layer are designed using dimensional modeling principles to deliver consistent, high-quality data for enterprise reporting and analytical workloads.
