/*====================================================================================
	Script purpose:	
			This Query creates a view that deplays the category performance of the sales data. 
			it shows the revenue contribution percentage and other key metrics.
			The analysis excludes peak sales month to provide a more balanced
			view of typical sales performance

	Usage: execute this query: 	SELECT * FROM gold.category_overall_sales_report
								ORDER BY sales_amount_NGN DESC
======================================================================================
*/

IF OBJECT_ID('gold.category_overall_sales_report', 'V') IS NOT NULL
	DROP VIEW gold.category_overall_sales_report;
GO
CREATE VIEW gold.category_overall_sales_report AS							
WITH category_summary AS (
SELECT
	product_category,
	COUNT(DISTINCT part_number) AS product_count,
	ROUND(SUM(quantity), 2) AS quantity,
	ROUND(SUM(total_cost_NGN), 2) AS total_cost_NGN,
	ROUND(SUM(sales_amount_NGN), 2) AS sales_amount_NGN,
	ROUND(SUM(total_profit_NGN), 2) AS total_profit_NGN
FROM gold.beautyspot_sales_report
WHERE sales_date NOT IN ('2025-12-01')
GROUP BY product_category
)
SELECT
	product_category,
	product_count,
	quantity,
	total_cost_NGN,
	sales_amount_NGN ,
	total_profit_NGN,
	CONCAT(CAST(ROUND((sales_amount_NGN/SUM(sales_amount_NGN) OVER()) * 100, 2) AS NVARCHAR),'%') AS sales_percent_contribution
FROM category_summary


