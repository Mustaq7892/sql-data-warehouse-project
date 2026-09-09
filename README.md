# 🏢 SQL Data Warehouse Project

<p align="center">
  <img src="https://img.shields.io/badge/database-Microsoft%20SQL%20Server-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white">
  <img src="https://img.shields.io/badge/language-T--SQL-blue?style=flat-square">
  <img src="https://img.shields.io/badge/architecture-Medallion%20(Bronze--Silver--Gold)-8A6D3B?style=flat-square">
  <img src="https://img.shields.io/badge/license-MIT-lightgrey?style=flat-square">
</p>

An end-to-end **Microsoft SQL Server Data Warehouse**, built using the **Medallion Architecture** and industry-standard data engineering practices — from raw CSV ingestion through cleansing, dimensional modeling, and business-ready analytical views.

This repository is a practical, real-world example of the full data warehousing lifecycle: ETL development, data transformation, Star Schema modeling, data quality validation, and analytical reporting — not a tutorial followed to completion, but a system designed, tested, and documented end to end.

---

## 📑 Table of Contents

- [Data Architecture](#️-data-architecture)
- [What This Project Demonstrates](#-what-this-project-demonstrates)
- [Data Quality Validation](#-data-quality-validation)
- [Technology Stack](#️-technology-stack)
- [Repository Structure](#-repository-structure)
- [Getting Started](#-getting-started)
- [Documentation](#-documentation)
- [License](#️-license)
- [About Me](#-about-me)

---

## 🏗️ Data Architecture

This project follows the **Medallion Architecture**, organizing data into Bronze, Silver, and Gold layers.

![Project Architecture](docs/data_architecture.png)

| Layer | Purpose |
|---|---|
| 🥉 **Bronze** | Raw data extracted from CRM and ERP source systems, stored without modification for traceability and auditing. |
| 🥈 **Silver** | Cleansed, validated, and standardized data — deduplicated, formatted, and business-rule-checked. |
| 🥇 **Gold** | Business-ready data modeled as a **Star Schema** — dimension and fact views optimized for reporting and analytics. |

---

## 🎯 What This Project Demonstrates

| Skill | How it shows up in the repo |
|---|---|
| **ETL pipeline design** | Stored procedures load and transform Bronze → Silver → Gold, using `BULK INSERT` for raw ingestion |
| **Data quality engineering** | Dedicated validation scripts check primary-key integrity, duplicates, NULLs, whitespace, and business rules — see below |
| **Dimensional modeling** | Star Schema in the Gold layer, with fact and dimension views built for real analytical queries |
| **Documentation discipline** | A full data catalog, naming conventions standard, and architecture/flow diagrams accompany the code |

---

## 🧪 Data Quality Validation

Rather than trusting the pipeline by inspection, each layer is checked with dedicated SQL scripts that follow a consistent, documented pattern — every check states its expected result up front:

```sql
-- Check for Duplicate or NULL Customer IDs
-- Expected Result: No rows returned
SELECT
    cst_id,
    COUNT(*) AS duplicate_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;
```

`tests/quality_checks_silver.sql` and `tests/quality_checks_gold.sql` cover primary-key integrity, duplicate records, NULL checks, whitespace validation, data standardization, date validation, business-rule validation, and cross-layer consistency — run after each load to confirm the data is trustworthy before it reaches the Gold layer.

---

## 🛠️ Technology Stack

| Category | Technologies |
|---|---|
| Database | Microsoft SQL Server |
| Language | T-SQL |
| Architecture | Medallion Architecture (Bronze / Silver / Gold) |
| Data Modeling | Star Schema |
| ETL | Stored Procedures, `BULK INSERT` |
| Data Sources | CSV files (CRM & ERP) |
| Documentation | Markdown, Draw.io |
| Version Control | Git & GitHub |

---

## 📂 Repository Structure

```text
sql-data-warehouse-project/
│
├── datasets/
│   ├── source_crm/
│   └── source_erp/
│
├── docs/
│   ├── ETL.png
│   ├── Project_Notes_Pictures.pdf
│   ├── data_architecture.png
│   ├── data_catalog.md
│   ├── data_flow.png
│   ├── data_integration.png
│   ├── data_layers.pdf
│   ├── data_model.png
│   └── naming_conventions.md
│
├── scripts/
│   ├── bronze/
│   │   ├── ddl_bronze.sql
│   │   └── proc_load_bronze.sql
│   │
│   ├── silver/
│   │   ├── ddl_silver.sql
│   │   ├── proc_load_silver.sql
│   │   └── init_database.sql
│   │
│   └── gold/
│       └── ddl_gold.sql
│
├── tests/
│   ├── quality_checks_gold.sql
│   └── quality_checks_silver.sql
│
├── LICENSE
└── README.md
```

---

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/Mustaq7892/sql-data-warehouse-project
   ```
2. **Create the database** — run `scripts/silver/init_database.sql`
3. **Create Bronze tables** — run `scripts/bronze/ddl_bronze.sql`
4. **Load the Bronze layer** — run `scripts/bronze/proc_load_bronze.sql`
5. **Create Silver tables** — run `scripts/silver/ddl_silver.sql`
6. **Load the Silver layer** — run `scripts/silver/proc_load_silver.sql`
7. **Create Gold views** — run `scripts/gold/ddl_gold.sql`
8. **Run data quality checks** — run `tests/quality_checks_silver.sql` and `tests/quality_checks_gold.sql`, and confirm each returns no rows

---

## 📚 Documentation

| Document | Description |
|---|---|
| [Data Architecture](docs/data_architecture.png) | Overall Medallion Architecture diagram |
| [ETL Diagram](docs/ETL.png) | ETL process and workflow |
| [Data Flow](docs/data_flow.png) | End-to-end movement of data |
| [Data Model](docs/data_model.png) | Star Schema design |
| [Data Catalog](docs/data_catalog.md) | Business metadata for the Gold layer |
| [Naming Conventions](docs/naming_conventions.md) | Standards for database objects |

---

## 🛡️ License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 About Me

Hi, I'm **Shaik Mustaq** — a Software Developer with 2+ years of professional experience, focused on Python, SQL, data engineering, and enterprise application development.

This repository is where I taught myself how a production-style data warehouse actually comes together — the Medallion architecture, the ETL logic, the validation discipline — end to end, not just the modeling theory.

<p align="left">
  <a href="https://www.linkedin.com/in/skmustaq/">
    <img src="https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white">
  </a>
</p>

---

⭐ If this project is useful or interesting to you, a star is appreciated.
