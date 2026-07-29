/*
===============================================================================
Create Database and Schemas
===============================================================================
Script Purpose:
    Initializes the SQL Data Warehouse environment by creating the
    'DataWarehouse' database and the required schemas:
        - bronze
        - silver
        - gold

    If the 'DataWarehouse' database already exists, it will be dropped
    and recreated to ensure a clean development environment.

WARNING:
    Executing this script will permanently delete the existing
    'DataWarehouse' database, including all tables, data, and other
    database objects.

    Ensure that you have a valid backup before running this script in
    any environment containing important data.
===============================================================================
*/

USE master;
GO

-- Drop the existing 'DataWarehouse' database (if it exists)
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create a new 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

-- Switch to the 'DataWarehouse' database
USE DataWarehouse;
GO

-- Create Bronze Schema
CREATE SCHEMA bronze;
GO

-- Create Silver Schema
CREATE SCHEMA silver;
GO

-- Create Gold Schema
CREATE SCHEMA gold;
GO
