# Supply Chain Analysis (SQL Server)

## Overview

This project implements a complete Supply Chain Analysis using a SQL Server-based Data Warehouse approach. It includes the design of an operational database, a dimensional data warehouse model, and analytical queries to extract business insights.

The goal is to analyze logistics performance, delivery efficiency, and cost optimization.

## Project Structure

```
/sql
   /source
      DB_Supply_All.sql
   /dwh
      DWH_ALL.sql
   /analysis
      03_ECommerce_DWH_Analysen.sql
```
## Data Architecture

### 1. Source System (OLTP)

* File: `DB_Supply_All.sql`
* Contains the operational database structure
* Includes entities such as:

  * Customers
  * Orders
  * Products
  * Shippers
  * Warehouses

### 2. Data Warehouse (OLAP)

* File: `DWH_ALL.sql`
* Implements a dimensional model (Star Schema)
* Includes:

  * Fact tables (e.g., sales, shipping)
  * Dimension tables (e.g., customer, product, time)

### 3. Analytics Layer

* File: `03_ECommerce_DWH_Analysen.sql`
* Contains SQL queries for KPI calculations and reporting

## Key Analyses

* Delivery performance (planned vs actual shipping time)
* Supplier reliability and error rates
* Cost efficiency by shipping method
* Warehouse and inventory insights

## Technologies Used

* Microsoft SQL Server
* T-SQL
* Data Warehouse Modeling (Star Schema)

## Future Improvements

* Implementation of a structured ETL pipeline
* Automation of data loading processes
* Integration with BI tools (e.g., Power BI)
* Advanced KPI dashboards

## Purpose

This project was developed as a group assignment for Data Engineering certification and as a hands-on exercise to demonstrate skills in:

* Database design
* Data warehousing
* SQL analytics
* Supply chain data analysis


## Author
Yasemin and Francesco



