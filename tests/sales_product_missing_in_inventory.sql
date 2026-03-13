/*The query identifies products in the sales dataset 
that do not exists in the inventory dataset. 
*/

SELECT DISTINCT
	part_no,
	product_name
FROM bronze.beautyspot_sales_sls
WHERE part_no NOT IN (SELECT part_no FROM bronze.beautyspot_prd_details_inv);
