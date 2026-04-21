# Inventory Data Pipeline & Analytics Dashboard

## Overview

This project demonstrates the design and implementation of a PostgreSQL-based data pipeline and Tableau dashboard to support inventory lookup and procurement workflows.

The system transforms raw inventory data into a structured, analysis-ready format using a normalized relational schema, SQL-based transformations, and bridge tables to manage many-to-many relationships between materials, vendors, and class categories.

## Dashboard

Live Dashboard: **[Link](https://public.tableau.com/app/profile/daniel.san.andres/viz/HHS_Inventory_Management/Dashboard2)**

The Tableau dashboard enables users to:

* Filter materials by type and class
* View item-level details, including descriptions, vendor information, and notes
* Quickly locate materials for procurement
* Trigger a streamlined purchase request workflow via prefilled forms

## Data Pipeline

The project follows a structured ETL approach:

**1. Staging Layer**
* Raw data is loaded into a staging_materials table
* Supports preprocessing of multi-value fields (e.g., additional classes)
  
**2. Transformation**  
* SQL logic used to clean and normalize data
* Multi-value fields expanded using string_to_array and unnest
* Data standardized with trimming and null handling
  
**3. Data Modeling**  
* Normalized schema with separate dimension tables:
  * materials
  * vendors
  * classes
* Bridge tables to support many-to-many relationships:
  * material_classes
  * material_vendor_items
    
**4. Load (ETL)**  
* Insert logic designed to prevent duplicate records using ON CONFLICT and WHERE NOT EXISTS
* Ensures clean, repeatable data loads
  
**5. Reporting Layer**
* A SQL view (vw_materials_details) combines all relevant data into a flattened structure
* Designed specifically for Tableau consumption

  **Note:** The reporting view intentionally returns multiple rows per material when associated with multiple classes or vendors.
  This denormalized structure supports flexible filtering and interaction within the dashboard.

## Tech Stack
* PostgreSQL (database design and ETL)
* SQL (data transformation and modeling)
* Tableau Public (data visualization and dashboarding)

## Repository Structure
``` 
data/        → sample dataset used for staging  
images/      → dashboard screenshots
sql_code/    → schema, staging, ETL, and view definitions 
```
## Key Features
* Normalized relational database design
* Handling of multi-value fields via SQL transformation
* Bridge table implementation for complex relationships
* ETL processes designed to prevent duplicate records and support repeatable data loads
* Tableau dashboard supporting real-world inventory lookup and procurement use
