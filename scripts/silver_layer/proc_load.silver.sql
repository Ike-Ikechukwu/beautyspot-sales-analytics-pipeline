/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
DECLARE @Start_time DATETIME2, @End_time DATETIME2

	PRINT '=================================';
	PRINT ' Loading Silver layer';
	PRINT '=================================';

	SET @Start_time = GETDATE();
	PRINT '>> Truncating table: silver.beautyspot_prd_details_inv';
	TRUNCATE TABLE silver.beautyspot_prd_details_inv;

	PRINT '>> Inserting data into: silver.beautyspot_prd_details_inv';
	INSERT INTO silver.beautyspot_prd_details_inv(
		internal,
		part_no,
		details
	)
	SELECT 
		internal,
		part_no,
		details
	FROM(
		SELECT
			internal,
			UPPER(TRIM(part_no)) AS part_no,
			UPPER(TRIM(details)) AS details,
			ROW_NUMBER() OVER(PARTITION BY UPPER(TRIM(part_no)) ORDER BY UPPER(TRIM(part_no))) AS flag
		FROM bronze.beautyspot_prd_details_inv
		)t
	WHERE flag = 1;
	SET @End_time = GETDATE();
	PRINT '>> Load duration: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_Time) AS NVARCHAR) + ' Seconds';
	PRINT '---------------------------------------------------------';

	SET @Start_time = GETDATE();
	Print ' >> Truncating table: silver.beautyspot_sales_sls';
	TRUNCATE TABLE silver.beautyspot_sales_sls;

	PRINT ' >> Inserting data into: silver.beautyspot_sales_sls';
	INSERT INTO silver.beautyspot_sales_sls (
		part_no,
		product_name,
		qty,
		sales_N,
		cost_N,
		profit_N,
		sales_date
	)
	SELECT 
		UPPER(TRIM(bs.part_no)) AS part_no,
			CASE 
		-- Use full product description from inventory table when available.
		-- If NULL, apply manually mapped product names provided by inventory personnel.
		WHEN bp.details IS  NOT NULL THEN UPPER(TRIM(bp.details))
		WHEN bp.details IS NULL AND bs.part_no = '081555969691' THEN 'LA GIRL PRO CONCEALER'
		WHEN bp.details IS NULL AND bs.part_no = '3551440201191' THEN 'SWEETEST HEART POWDER 100g'
		WHEN bp.details IS NULL AND bs.part_no = '3551440203089' THEN 'SWEETEST HEART POWDER 50g'
		WHEN bp.details IS NULL AND bs.part_no = '5285002321840' THEN 'PASSION TALCUM POWDER'
		WHEN bp.details IS NULL AND bs.part_no = '650076816656' THEN 'BEAUTYLAND TRAVEL SET'
		WHEN bp.details IS NULL AND bs.part_no = '6902540752361' THEN 'DERMA ROLLER SYSTEM'
		WHEN bp.details IS NULL AND bs.part_no = '6942349709630' THEN 'SADOER ACNE PIMPLE (78) PATCHES'
		WHEN bp.details IS NULL AND bs.part_no = '6972591660250' THEN 'CPD MATTE CONTOUR STICK'
		WHEN bp.details IS NULL AND bs.part_no = '756000043546' THEN 'BABY & ME BABY POWDER 450g'
		WHEN bp.details IS NULL AND bs.part_no = '88821184' THEN 'ENCHANTEUR PERFUMED TALC POWDER 125g'
		WHEN bp.details IS NULL AND bs.part_no = '8901030638985' THEN 'PONDS OIL CONTROL POWDER 100g'
		WHEN bp.details IS NULL AND bs.part_no = '8906062419519' THEN 'MC ARCTIC BLUE POWDER 125g'
		WHEN bp.details IS NULL AND bs.part_no = 'BSGCW' THEN 'DESIGNER WEDGE FLAT'
		WHEN bp.details IS NULL AND bs.part_no = 'BSTWIZ' THEN 'TWIZZER SET'
		WHEN bp.details IS NULL AND bs.part_no = 'HHSANDB' THEN 'SAND DECOR BIG'
		ELSE NULL
	END AS product_name,
		bs.qty,
		bs.sales_N,
		ROUND(bs.cost_N, 2) AS cost_N,
		ROUND(bs.profit_N, 2) AS profit_N,
		bs.sales_date	
	FROM bronze.beautyspot_sales_sls bs
	LEFT JOIN bronze.beautyspot_prd_details_inv bp
	ON bs.part_no = bp.part_no;
	SET @End_time = GETDATE();
	PRINT ' >> Load duration: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' Seconds';
END;




