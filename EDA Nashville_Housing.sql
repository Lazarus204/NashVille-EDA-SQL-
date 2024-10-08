---  Working Data
SELECT *
FROM nash_ville



  --- A Stored Procedure for querying my data
  --CREATE PROCEDURE sp_nashville AS
  --(
  --SELECT *
  --FROM nash_ville
  --)
EXEC sp_nashville;


  --1.-- Total Revenue gerenerated
  -- 18,455,730,777
  SELECT
	SUM(SalePrice) revenue
  FROM nash_ville

  --2.- Total expense/costs
  -- 6,036,230,001
  SELECT 
	SUM(TotalValue) total_costs
  FROM nash_ville

  --3. Total Profits made from sales
  -- 12,419,500,776
  SELECT
	SUM(SalePrice) - SUM(TotalValue) as profits
  FROM nash_ville


  -- 4. Total sales made
  SELECT
	COUNT([UniqueID ]) totalSales
  FROM nash_ville

  ---- 5 Average SALE PRICE
  SELECT
	ROUND(AVG(SalePrice),2) avg_Price
  FROM nash_ville

  --6. Profits by saleAsVaccant
  SELECT
	SoldAsVacant
	,SUM(SalePrice) - SUM(TotalValue) as Profit
  FROM nash_ville
  GROUP BY SoldAsVacant
  ORDER BY SUM(SalePrice) - SUM(TotalValue) DESC

---7. Loss by SoldAsVaccant >>> yes or no
   SELECT TOP 10
	[UniqueID ]
	,SoldAsVacant
	,SUM(SalePrice) - SUM(TotalValue) as LOSS
  FROM nash_ville
  --WHERE SoldAsVacant like 'yes'
  GROUP BY [UniqueID ], SoldAsVacant
  HAVING SUM(SalePrice) - SUM(TotalValue) < 0
  ORDER BY SUM(SalePrice) - SUM(TotalValue)

-- EXEC sp_nashville;


--SELECT
--		[UniqueID ]
--		,SoldAsVacant
--		,SUM(SalePrice) - SUM(TotalValue) as Loss
--		,YearBuilt
--		,standardized_sale_date
--FROM nash_ville
--	--WHERE SoldAsVacant like 'yes'
--GROUP BY [UniqueID ],SoldAsVacant,YearBuilt,standardized_sale_date
--HAVING SUM(SalePrice) - SUM(TotalValue) < 0
--ORDER BY SUM(SalePrice) - SUM(TotalValue)

SELECT * 
FROM nash_ville 
WHERE [UniqueID ] = '9674' -- Caught my attention for having the highest loss

---8. Some data have yearBuilt freater then saleYear
--- Why???
-- Made me think that the buyers did a pre-payment and waited construction to complete
WITH CTE as(
 SELECT
	YearBuilt
	,DATEPART(YEAR,standardized_sale_date) saleYear
	,CASE
		WHEN YearBuilt > DATEPART(YEAR,standardized_sale_date) THEN 'pre-payment'
		ELSE 'normal'
	 END AS comparison
 FROM nash_ville
 )
 SELECT *
 FROM CTE

 --9. Count of Pre-Paid Buildings
 WITH counts as(
 SELECT
	YearBuilt
	,DATEPART(YEAR,standardized_sale_date) saleYear
	,CASE
		WHEN YearBuilt > DATEPART(YEAR,standardized_sale_date) THEN 'pre-paid'
		ELSE 'normal'
	 END AS comparison
 FROM nash_ville
 )
 SELECT COUNT(comparison) as 'Prepaid_Houses'
 FROM counts
 WHERE comparison LIKE 'pre-paid'


 --- 10. Sales by Day
 -- Seems like weekdays are best sellers
 -- Weekend are the worst sellers

 SELECT
	DATENAME(DW,standardized_sale_date) saleDay
	,COUNT([UniqueID ]) totalSales
 FROM nash_ville
 GROUP BY DATENAME(DW,standardized_sale_date)
 ORDER BY COUNT([UniqueID ]) DESC

 -- 11. Sales by Year
 SELECT
	DATEPART(YEAR,standardized_sale_date) saleYear
	,COUNT([UniqueID ]) totalSales
 FROM nash_ville
 GROUP BY DATEPART(YEAR,standardized_sale_date)
 ORDER BY COUNT([UniqueID ]) DESC

 -- 12. Revenue by Year
 SELECT
	DATEPART(YEAR,standardized_sale_date) as saleYear
	,SUM(SalePrice) totalRevenue
 FROM nash_ville
  GROUP BY DATEPART(YEAR,standardized_sale_date)
 ORDER BY SUM(SalePrice) - SUM(TotalValue) DESC

 -- 13. Profit by Year
 SELECT 
	DATEPART(YEAR,standardized_sale_date) saleYear
	,SUM(SalePrice) - SUM(TotalValue)  Profit
 FROM nash_ville
 GROUP BY DATEPART(YEAR,standardized_sale_date)
 ORDER BY SUM(SalePrice) - SUM(TotalValue) DESC



 --- 14 Average Price by number of Bedrooms
 -- 
 SELECT
	Bedrooms
	,AVG(SalePrice)  avgPrice
 FROM nash_ville
 WHERE Bedrooms IS NOT NULL
 GROUP BY Bedrooms
 ORDER BY AVG(SalePrice)

 -- Revenue generated by number of bedrooms
 SELECT
	Bedrooms
	,SUM(SalePrice) totalRevenue
 FROM nash_ville
 WHERE Bedrooms IS NOT NULL
 GROUP BY Bedrooms
 ORDER BY SUM(SalePrice) DESC

 -- profits by Bedrooms
  SELECT
	Bedrooms
	,SUM(SalePrice) - SUM(TotalValue) profits
 FROM nash_ville
 WHERE Bedrooms IS NOT NULL
 GROUP BY Bedrooms
 ORDER BY SUM(SalePrice) - SUM(TotalValue) DESC

 ------- BREAKDOWN BY CITY
 -- 1. COUNT OF CITIES
 SELECT
	COUNT(DISTINCT(split_property_city)) as NumberOfCities
 FROM nash_ville
 -- WHERE split_property_city IS NOT NULL

 --2. Revenue by City
  SELECT
	split_property_city
	,SUM(SalePrice) totalRevenue
 FROM nash_ville
 WHERE split_property_city IS NOT NULL
 GROUP BY split_property_city
 ORDER BY SUM(SalePrice) DESC

 --3 Profit by City
   SELECT
	split_property_city
	,SUM(SalePrice)- SUM(TotalValue) profit
 FROM nash_ville
 WHERE split_property_city IS NOT NULL
 GROUP BY split_property_city
 ORDER BY SUM(SalePrice)- SUM(TotalValue) DESC

 -- 4 Sales by City
 SELECT
	split_property_city
	,COUNT([UniqueID ]) totalSales
 FROM nash_ville
 WHERE split_property_city IS NOT NULL
 GROUP BY split_property_city
 ORDER BY COUNT([UniqueID ]) DESC

 --- 
 SELECT *
 FROM nash_ville
 WHERE split_property_city IN (' UNKNOWN',' FRANKLIN')



 -- YEAR BUILT---
 SELECT 
	COUNT(DISTINCT(YearBuilt)) noOfYears
 FROM nash_ville
 --ORDER BY (YearBuilt)


 -- Revenue
  SELECT
	YearBuilt
	,SUM(SalePrice) totalRevenue
 FROM nash_ville
 WHERE YearBuilt IS NOT NULL
 GROUP BY YearBuilt
 ORDER BY SUM(SalePrice) DESC