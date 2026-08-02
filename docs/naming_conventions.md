# 📖 Naming Conventions

## Overview

This document defines the naming standards used throughout the SQL Data Warehouse project. Consistent naming conventions improve readability, maintainability, and collaboration while ensuring a standardized structure across all database objects.

---

# Table of Contents

1. [General Principles](#general-principles)
2. [Schema Naming Conventions](#schema-naming-conventions)
3. [Table Naming Conventions](#table-naming-conventions)
   - [Bronze Layer](#bronze-layer)
   - [Silver Layer](#silver-layer)
   - [Gold Layer](#gold-layer)
4. [Column Naming Conventions](#column-naming-conventions)
   - [Business Keys](#business-keys)
   - [Surrogate Keys](#surrogate-keys)
   - [Technical Columns](#technical-columns)
5. [View Naming Conventions](#view-naming-conventions)
6. [Stored Procedure Naming Conventions](#stored-procedure-naming-conventions)

---

# General Principles

The following standards apply to every database object in this project.

- Use **snake_case** for all object names.
- Use lowercase letters with underscores (`_`) to separate words.
- Use clear, meaningful, and descriptive names.
- Use English for all database objects.
- Avoid SQL reserved keywords.
- Maintain consistent naming across all layers of the data warehouse.

---

# Schema Naming Conventions

The project follows the **Medallion Architecture**, where each schema represents a stage in the data pipeline.

| Schema | Purpose |
|---------|---------|
| **bronze** | Stores raw data exactly as received from source systems. |
| **silver** | Stores cleansed, validated, and standardized data. |
| **gold** | Stores business-ready dimensional models for analytics and reporting. |

---

# Table Naming Conventions

## Bronze Layer

Bronze tables preserve the original source structure without renaming entities.

### Naming Pattern

```text
<source_system>_<entity_name>
```

### Examples

| Table | Description |
|---------|-------------|
| `crm_cust_info` | Customer information extracted from the CRM system. |
| `crm_prd_info` | Product information extracted from the CRM system. |
| `crm_sales_details` | Sales transaction data from the CRM system. |
| `erp_cust_az12` | Customer information from the ERP system. |
| `erp_loc_a101` | Customer location information from the ERP system. |
| `erp_px_cat_g1v2` | Product category information from the ERP system. |

---

## Silver Layer

Silver tables retain the same naming convention as the Bronze layer while storing cleansed and transformed data.

### Naming Pattern

```text
<source_system>_<entity_name>
```

### Examples

| Table | Description |
|---------|-------------|
| `crm_cust_info` | Standardized customer information. |
| `crm_prd_info` | Cleaned product information. |
| `crm_sales_details` | Validated sales transaction data. |
| `erp_cust_az12` | Standardized ERP customer information. |
| `erp_loc_a101` | Standardized customer location information. |
| `erp_px_cat_g1v2` | Standardized product category information. |

---

## Gold Layer

Gold objects use business-friendly names following dimensional modeling principles.

### Naming Pattern

```text
<category>_<entity_name>
```

### Examples

| Object | Description |
|---------|-------------|
| `dim_customers` | Customer dimension. |
| `dim_products` | Product dimension. |
| `fact_sales` | Sales fact table. |

### Category Prefixes

| Prefix | Meaning | Example |
|---------|---------|---------|
| `dim_` | Dimension table | `dim_customers` |
| `fact_` | Fact table | `fact_sales` |
| `report_` | Reporting object | `report_sales_monthly` |

---

# Column Naming Conventions

## Business Keys

Business identifiers should clearly describe the entity they represent.

### Examples

- `customer_id`
- `product_id`
- `category_id`
- `order_number`

---

## Surrogate Keys

Dimension tables use surrogate keys ending with the `_key` suffix.

### Naming Pattern

```text
<entity_name>_key
```

### Examples

| Column | Description |
|---------|-------------|
| `customer_key` | Surrogate key for the customer dimension. |
| `product_key` | Surrogate key for the product dimension. |

---

## Technical Columns

System-generated metadata columns begin with the `dwh_` prefix.

### Naming Pattern

```text
dwh_<column_name>
```

### Examples

| Column | Description |
|---------|-------------|
| `dwh_create_date` | Date and time when the record was created in the data warehouse. |
| `dwh_load_date` | Date and time when the record was loaded into the data warehouse. |
| `dwh_modified_date` | Date and time when the record was last modified (if implemented). |

---

# View Naming Conventions

Business-ready views follow the same naming conventions as dimensional models.

### Naming Pattern

```text
<category>_<entity_name>
```

### Examples

| View | Description |
|------|-------------|
| `gold.dim_customers` | Customer dimension view. |
| `gold.dim_products` | Product dimension view. |
| `gold.fact_sales` | Sales fact view. |

---

# Stored Procedure Naming Conventions

Stored procedures responsible for loading data follow a simple and consistent naming convention.

### Naming Pattern

```text
load_<layer_name>
```

### Examples

| Stored Procedure | Description |
|------------------|-------------|
| `load_bronze` | Loads raw source data into the Bronze layer. |
| `load_silver` | Cleanses and transforms Bronze data into the Silver layer. |
| `load_gold` | Loads business-ready data into the Gold layer (if implemented). |

---

# Summary

Following these naming conventions ensures:

- Consistent and readable database object names.
- Clear separation between Bronze, Silver, and Gold layers.
- Improved maintainability and collaboration.
- Better scalability as the project grows.
- Alignment with industry-standard SQL Server and Data Engineering practices.
