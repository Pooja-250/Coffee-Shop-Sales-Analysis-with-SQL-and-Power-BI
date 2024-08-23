CREATE DATABASE coffee_shop_dp;
USE coffee_shop_dp;

-- CREATE A TABLE 

SELECT * FROM `coffee shop sales`;
DESCRIBE `coffee shop sales`;

-- CONVERT DATE (TRANSACTION DATE) COLUMN TO PROPER DATE TYPE

UPDATE `coffee shop sales`
SET Transaction_date = str_to_date(Transaction_date,'%d-%m-%Y');
SET SQL_SAFE_UPDATES = 0;
-- ALTER TABLE (TRANSACTION DATE) COLUMN TO PROPER DATE TYPE

ALTER TABLE `coffee shop sales`
MODIFY COLUMN Transaction_date  DATE;

-- CONVERT TIME (TRANSACTION DATE) COLUMN TO PROPER TIME TYPE

UPDATE `coffee shop sales`
SET Transaction_time = str_to_date(Transaction_time,'%d-%m-%Y');
SET SQL_SAFE_UPDATES = 0;

-- ALTER TABLE (TRANSACTION TIME) COLUMN TO TIME DATA TYPE

ALTER TABLE `coffee shop sales`
MODIFY COLUMN Transaction_time  TIME;
DESCRIBE `coffee shop sales`;

-- TOTAL SALES
 
SELECT ROUND(SUM(Unit_price * Transaction_qty)) as Total_Sales
from `coffee shop sales`
where
MONTH(Transaction_date)=5  ;  -- May Month

-- TOTAL SALES KPI - MOM DIFFERENCE AND MOM GROWTH
 
select 
  MONTH(Transaction_date) as month,    -- number of month
  ROUND(SUM(unit_price*Transaction_qty)) as total_sales,   -- total sales 
  (SUM(unit_price*Transaction_qty)) - LAG(SUM(unit_price*Transaction_qty),1)--  months sales difference 
  OVER(ORDER BY MONTH(Transaction_date)) / LAG(SUM(unit_price*Transaction_qty),1) -- division by previous month(PM) sales
  OVER(ORDER BY MONTH(Transaction_date)) * 100 as mom_increase_percentage -- percentage 
FROM
    `coffee shop sales`
WHERE 
	MONTH(Transaction_date) IN (4,5) -- for month of april(PM) and may(CM)
GROUP BY 
   	MONTH(Transaction_date) 
ORDER BY 
  MONTH(Transaction_date) ;  

-- TOTAL ORDERS

SELECT COUNT(Transaction_id) as Total_Orders 
from `coffee shop sales`
where
MONTH(Transaction_date)=5  ;  -- May Month

-- TOTAL ORDERS KPI - MOM DIFFERENCE AND MOM GROWTH

select 
  MONTH(Transaction_date) as month,    -- number of month
  ROUND(COUNT(Transaction_id)) as total_sales,   -- total sales 
  (COUNT(Transaction_id)) - LAG(COUNT(Transaction_id),1)--  months sales difference 
  OVER(ORDER BY MONTH(Transaction_date)) / LAG(COUNT(Transaction_id),1) -- division by previous month(PM) sales
  OVER(ORDER BY MONTH(Transaction_date)) * 100 as mom_increase_percentage -- percentage 
FROM
    `coffee shop sales`
WHERE 
	MONTH(Transaction_date) IN (4,5) -- for month of april(PM) and may(CM)
GROUP BY 
   	MONTH(Transaction_date) 
ORDER BY 
  MONTH(Transaction_date) ;  

 -- TOTAL QUANTITY SOLD ANALYSIS
 
SELECT sum(Transaction_qty) as total_quantity_sold
from `coffee shop sales`
where
MONTH(Transaction_date)=5  ;  -- May Month

-- TOTAL SALES KPI - MOM DIFFERENCE AND MOM GROWTH

select 
  MONTH(Transaction_date) as month,    -- number of month
  ROUND(SUM(unit_price*Transaction_qty)) as total_sales,   -- total sales 
  (SUM(unit_price*Transaction_qty)) - LAG(SUM(unit_price*Transaction_qty),1)--  months sales difference 
  OVER(ORDER BY MONTH(Transaction_date)) / LAG(SUM(unit_price*Transaction_qty),1) -- division by previous month(PM) sales
  OVER(ORDER BY MONTH(Transaction_date)) * 100 as mom_increase_percentage -- percentage 
FROM
    `coffee shop sales`
WHERE 
	MONTH(Transaction_date) IN (4,5) -- for month of april(PM) and may(CM)
GROUP BY 
   	MONTH(Transaction_date) 
ORDER BY 
  MONTH(Transaction_date) ;  
    
-- CALENDER  TABLE - DAILY SALES, QUANTITY AND TOTAL ORDERS

 SELECT 
 CONCAT(ROUND(SUM(Unit_price*Transaction_qty)/1000,1),'K') as Total_sales,
 CONCAT(ROUND(SUM(Transaction_qty)/1000,1),'K') as Total_qty_sold,
 CONCAT(ROUND(SUM(Transaction_id)/1000,1),'K') as Total_orders
 FROM `coffee shop sales`
 where 
 Transaction_date='2023-03-27';
 
 -- SALES TREND OVER PERIOD
 
 SELECT AVG(total_sales) AS average_sales
 FROM(
    SELECT
       SUM(Unit_price * Transaction_qty) as Total_Sales 
	 FROM `coffee shop sales`
where
MONTH(Transaction_date)=5   -- May Month
GROUP BY Transaction_date
) AS internal_query;

-- DAILY SALES FOR MONTH SELECTED

SELECT 
DAY(transaction_date) AS day_of_month,
ROUND(SUM(Unit_price*Transaction_qty),1) AS Total_Sales
FROM `coffee shop sales`
where
MONTH(Transaction_date)=5   -- May Month
GROUP BY  DAY(Transaction_date)
ORDER BY  DAY(Transaction_date);

-- COMPARING DAILY SALES WITH AVERAGE SALES - IF GREATER THAN "ABOVE AVERAGE" AND LESSER THAN "BELOW AVERAGE"
SELECT 
   day_of_month,
   CASE 
     WHEN Total_Sales > avg_sales THEN 'ABOVE AVERAGE'
     WHEN Total_Sales < avg_sales THEN 'BELOW AVERAGE'
     ELSE 'AVERAGE'
  END AS Sales_status,
  Total_Sales
FROM( 
SELECT
   DAY(transaction_date) AS day_of_month,
   ROUND(SUM(Unit_price*Transaction_qty),1) AS Total_Sales,
   AVG(SUM(Unit_price*Transaction_qty)) OVER() AS avg_sales
FROM `coffee shop sales`
where
MONTH(Transaction_date)=5   -- May Month
GROUP BY  DAY(Transaction_date)
) AS sales_data
ORDER BY day_of_month;

-- SALES ANALYSIS BY WEEKDAY / WEEKEND

  SELECT 
    CASE WHEN DAYOFWEEK(Transaction_date) IN (1,7) THEN 'Weekends'
    ELSE 'Weekdays'
    END AS day_type,
    CONCAT(ROUND(SUM(Unit_price*Transaction_qty)/1000,1),'K') as Total_sales
FROM `coffee shop sales`
WHERE MONTH(Transaction_date)=3 -- march month
GROUP BY
	CASE WHEN DAYOFWEEK(Transaction_date) IN (1,7) THEN 'Weekends'
	ELSE 'Weekdays'  
	END;
    
-- SALES ANALYSIS BY STORE LOCATION

SELECT 
      Store_location,
      SUM(Unit_price * Transaction_qty) as total_sales
FROM `coffee shop sales`
WHERE MONTH(Transaction_date)=5
GROUP BY store_location
ORDER BY SUM(Unit_price * Transaction_qty) DESC;

    -- SALES BY PRODUCT CATEGORIES
   
   SELECT 
       product_category,
       SUM(Unit_price * Transaction_qty) as total_sales
	FROM `coffee shop sales`
    WHERE MONTH(Transaction_date)=5
    GROUP BY product_category
    ORDER BY SUM(Unit_price * Transaction_qty) DESC;
    
   -- SALES BY TOP 10 PRODUCT CATEGORIES
   SELECT 
       product_type,
       SUM(Unit_price * Transaction_qty) as total_sales
   FROM `coffee shop sales`
   WHERE MONTH(Transaction_date)=5
   GROUP BY product_type
   ORDER BY SUM(Unit_price * Transaction_qty) DESC
   LIMIT 10;
   
   -- SALES ANALYSIS BY DAYS | HOURS
   
   SELECT 
       SUM(Unit_price * Transaction_qty) as total_sales,
       SUM(Transaction_qty) as total_qty_sold,
       COUNT(*) as total_orders
   FROM `coffee shop sales`
   WHERE MONTH(Transaction_date)=5  -- May
   AND DAYOFWEEK(Transaction_date)=1 -- sunday
   AND HOUR(Transaction_time)=14; -- hour no 14
   
   -- TO GET SALES FOR ALL HOURS FOR MONTH OF MAY

SELECT
       HOUR(Transaction_time),	
       SUM(Unit_price * Transaction_qty) as total_sales
   FROM `coffee shop sales`
   WHERE MONTH(Transaction_date)=5 
   GROUP BY HOUR(Transaction_time)
   ORDER BY HOUR(Transaction_time);


-- TO GET SALES FROM MONDAY TO SUNDAY FOR MONTH OF MAY

   SELECT 
        CASE
          WHEN DAYOFWEEK(Transaction_date)=2 THEN 'MONDAY'
          WHEN DAYOFWEEK(Transaction_date)=3 THEN 'TUESDAY'
          WHEN DAYOFWEEK(Transaction_date)=4 THEN 'WEDNESDAY'
          WHEN DAYOFWEEK(Transaction_date)=5 THEN 'THURSDAY'
          WHEN DAYOFWEEK(Transaction_date)=6 THEN 'FRIDAY'
          WHEN DAYOFWEEK(Transaction_date)=7 THEN 'SATURDAY'
      ELSE 'SUNDAY'
	END AS Day_of_week,
    ROUND(SUM(unit_price*Transaction_qty)) as total_sales
FROM 
    `coffee shop sales`
WHERE 
   MONTH(Transaction_date)=5 -- filter for may
GROUP BY 
    CASE
       WHEN DAYOFWEEK(Transaction_date)=2 THEN 'MONDAY'
	   WHEN DAYOFWEEK(Transaction_date)=3 THEN 'TUESDAY'
	   WHEN DAYOFWEEK(Transaction_date)=4 THEN 'WEDNESDAY'
	   WHEN DAYOFWEEK(Transaction_date)=5 THEN 'THURSDAY'
	   WHEN DAYOFWEEK(Transaction_date)=6 THEN 'FRIDAY'
	   WHEN DAYOFWEEK(Transaction_date)=7 THEN 'SATURDAY'
	ELSE 'SUNDAY'
END;
   
   
   
   
   
   
    
    
    
    
    