/* 
===================================================================================
Script purpose:
        The Query creates a view that displays the allocation of the new procurement 
        budget across product categories based on thier revenue contributions.
===================================================================================
Usage: execute this query:   SELECT * FROM gold.budget_allocation_model
                             ORDER BY new_allocation
*/

IF OBJECT_ID('gold.budget_allocation_model', 'V') IS NOT NULL
	DROP VIEW gold.budget_allocation_model;
GO
CREATE VIEW gold.budget_allocation_model AS
WITH category_performance AS (
SELECT
	product_category,
	revenue_percent_contribution,
	(sales_amount_NGN/SUM(sales_amount_NGN) OVER()) * 100 AS revenue_contribution
FROM gold.category_overall_sales_report
)
SELECT 
	product_category,
	30000000 AS new_budget,
	revenue_percent_contribution,
	ROUND(30000000*(revenue_contribution/100),2) AS new_allocation
FROM category_performance
