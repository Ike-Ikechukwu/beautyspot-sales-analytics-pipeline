/*
=============================================================
Create Tables in the Silver layer
=============================================================
>> This  first checks if the tables ('silver.beautyspot_sales' and 
'silver.beautyspot_prd_details_inventory') exists in the database
'beauty_spot_DW', if so it deletes the tables then recreate it but 
if not it goes ahead to create the tables
*/

IF OBJECT_ID ('silver.beautyspot_sales_sls', 'U') IS NOT NULL
	DROP TABLE silver.beautyspot_sales_sls;
GO
CREATE TABLE silver.beautyspot_sales_sls (
	part_no NVARCHAR (50),
	product_name NVARCHAR (100),
	qty INT,
	sales_N FLOAT,
	cost_N FLOAT,
	profit_N FLOAT,
	sales_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO
IF OBJECT_ID ('silver.beautyspot_prd_details_inv', 'U') IS NOT NULL
	DROP TABLE silver.beautyspot_prd_details_inv;
CREATE TABLE silver.beautyspot_prd_details_inv (
	internal INT,
	part_no NVARCHAR (50),
	details NVARCHAR (100),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

