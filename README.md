# BeautySpot Sales Analytics Project


## Overview
This project transforms raw retail sales and inventory data into a structured format to support business analysis and reporting. It uses a layered data warehouse architecture and prepares datasets for visualization and decision-making with Power BI.

## Business Problem
The Beauty Spot section at XYZ Ultra Mart recently expanded its product offerings and requested an increase in procurement budget to ₦30,000,000. Management needed a data-driven approach to allocate the new budget across product categories based on historical sales performance.

## Project Objectives
-  A Bronze–Silver–Gold data warehouse built in SQL Server
-  Product categorization using SQL
-  Category performance and revenue contribution analysis
-  Allocate the ₦30 million procurement budget proportionally based on category performance
-  A Power BI dashboard for business reporting

## Tools Used
-  Excel Power Query: Extract and prepare data from PDF reports
-  SQL Server: Data storage, transformation, and analysis
-  Power BI: Data visualization and reporting

## Data Sources
Two datasets were used for this project.

1. **Monthly Sales Reports**
Five monthly PDF reports containing sales data with columns such as product description, quantity, discount, %, sales, cost, and profit. The product description column included both the part number and product name, which required splitting and cleaning for analysis.

2. **Inventory Product Dataset**
A CSV file containing product reference information (internal, part_no and details). This dataset provided more complete product descriptions than the sales reports, making it easier to identify keywords used to categorize products accurately.

## Data Preparation

Since the sales reports were provided in PDF format, the first step involved extracting and cleaning the data using Excel Power Query.

Each monthly report was imported and transformed using the same process.

**Transformations performed**:
-  Removed unnecessary columns such as discount and percentage fields
-  Split the Product Description column into: part_no and product_name
-  Added a sales_date column to identify the reporting month
-  Verified data types for all columns

Once the transformations were complete, the five datasets were appended into a single dataset.

The final dataset was exported as a CSV file and loaded into SQL Server.

## Data Warehouse Design

A layered data warehouse structure was implemented using Medallion Architecture.

The database created for the project: beauty_spot_DW

Schemas used: bronze, silver and gold

click to view script

Each layer serves a different purpose:
-  Bronze	Stores the raw data
-  Silver	Clean and standardize data
-  Gold	Create analytical views for reporting

### Bronze Layer

The Bronze layer stores the raw datasets exactly as they were received.

The CSV files were imported using the SQL Server Flat File Import Wizard.

Tables created:
-  bronze.beautyspot_sales_sls
-  bronze.beautyspot_prd_details_inv

No transformations were performed at this stage.
The goal was simply to preserve the original data for reference and traceability.

### Silver Layer: Data Cleaning and Structuring

The silver layer contains a clean and standardized data used for further analysis.

Two tables were created in this layer:

-  silver.beautyspot_sales_sls
-  silver.beautyspot_prd_details_inv

(click to view script)

Before loading data from bronze into the Silver layer, several data quality checks were performed to ensure consistency and accuracy. This checks included:

-  Identrifying duplicate part numbers
-  Checking for null values in text, numeric, and date columns
-  Removing unwanted spaces in string fields
-  Verifying consistent formatting across the dataset

(click to view the script).

**Data Discrepancy Investigation**

During validation, 15 part numbers from the sales dataset did not match records in the inventory dataset. After discussing the issue with the inventory officer, it was confirmed that Some products had previously shared the same part number and were later updated internally

The inventory officer provided complete product names for those records so they could still be categorized correctly

(click to view script)

**Data Insertion**
Once the data was cleaned, it was inserted into the Silver tables. Before loading the sales data, it was enriched with product information from the inventory dataset using a LEFT JOIN on part_no.
For matched records, product names from the inventory dataset were used. For unmatched records, the product names provided by the inventory officer were manually included.

(click to view script)

### Gold layer
The Gold Layer contains business ready viiews designed for analysis and reporting. This views apply business logic and prepare the data for use in SQL analysis and Power BI dashboards.

**Sales Report View**
A primary analytical view called "gold.beautyspot_sales_report was created in this layer. This view pulls the cleaned sales data from the silver layer and introduces a product category column to it which serves as the main dataset used for reporting and analysis.

It includes fields such as:
-  part_no
-  product_name
-  category
-  quantity_sold
-  cost_amount
-  sales_amount
-  profit_amount
-  sales_date
This view acts as the central dataset used for both SQL analysis and the Power BI dashboard.

#### Product categorization 
Product categorization was implemented directly within the sales report view. 
The process involved: 
1.  Identifying the business category groups
2.  Extracting distinct product names for identification of common keywords associated with each category.
3.  SQL CASE statement was then used to assign categories based on these keywords.
This approach allows products to be automatically categorized during query execution, ensuring consistent classification across the dataset.

(Click to view script)

### Monthly Sales Summary Validation

A monthly summary view was created to validate the transformed dataset against the original PDF sales reports. Key metrics such as total quantity sold, revenue, cost, and profit were aggregated by month and compared with the source reports to ensure the numbers matched

click to view script

## Analysis

### Category Performance Analysis
Using the gold.beautyspot_sales_report view, a category-level analysis was performed to evaluate the contribution of each product category.
The analysis calculated:
Number of products per category
Total quantity sold
Total cost
Total revenue
Total profit
Revenue contribution percentage
This analysis helps identify which product categories generate the most revenue and profit for the business.

(click to view script)

### Budget Allocation Model
A simple budget allocation model was developed based on category revenue contribution.
The idea was to distribute a marketing or purchasing budget across product categories according to their revenue performance.
**formula used**:
Revenue Allocation = New Budget × Revenue Contribution
This approach ensures that higher performing categories receive a proportionally larger share of the budget.

(click to view script).

## Power BI Dashboard

A Power BI dashboard was built on top of the Gold layer view gold.beautyspot_sales_report to visualize key business metrics.

**Key Performance Indicators:**
-  Unique Products
-  Total Quantity Sold
-  Total Cost
-  Total Revenue
-  Total Profit

**Visualizations**
-  The dashboard includes:
-  Monthly Revenue Trend
-  Category Performance
-  Profit Contribution (%)
-  Top Performing Products
-  Bottom Performing Products

These visuals allow stakeholders to quickly understand overall sales performance and identify high and low performing products.

(Insert dashboard screenshot here)

