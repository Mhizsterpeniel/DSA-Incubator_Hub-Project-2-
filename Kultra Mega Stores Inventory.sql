create database DSA_PROJECT_DB

SELECT * FROM [KMS Sql Case Study]

ALTER TABLE [KMS Sql Case Study]



------- (1) Which product category had the highest sales?
---Product_Category	TotalSales
------Technology	5984248.17547321

select top 1* from (
       select Product_category, Sales
	          from [KMS Sql Case Study]) AS Sales
order by Sales desc

-- OR

SELECT TOP 1 Product_Category, SUM(Sales) AS TotalSales
FROM [KMS Sql Case Study]
GROUP BY Product_Category
ORDER BY TotalSales DESC

--------- (2) What are the Top 3 and Bottom 3 regions in terms of sales?
---Top 3 = Region	TotalSales
------------West	3597549.269871
-----------Ontario	3063212.47638369
-----------Prarie	2837304.60503292

---Bottom 3 = Region	TotalSales
--------------Nunavut	116376.48383522
--Northwest Territories	800847.330903053
---------------Yukon	975867.375723362
select top 3* from (
       select Region, Sales
	          from [KMS Sql Case Study]) AS Region
order by Sales desc

select top 3 * from (
       select Region, Sales
	          from [KMS Sql Case Study]) AS Region
order by Sales asc

--OR

-- Top 3
SELECT TOP 3 Region, SUM(Sales) AS TotalSales
FROM [KMS Sql Case Study]
GROUP BY Region
ORDER BY TotalSales DESC

-- Bottom 3
SELECT TOP 3 Region, SUM(Sales) AS TotalSales
FROM [KMS Sql Case Study]
GROUP BY Region
ORDER BY TotalSales ASC

----------- (3) What were the total sales of appliances in Ontario?
------Total_Appliance_Sales = 3063212.47638369

SELECT SUM(Sales) AS Total_Appliance_Sales
FROM [KMS Sql Case Study]
WHERE Region = 'Ontario';

----- (4) Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers
select top 10 * from (
       select Customer_Name, Product_Category, Product_Name, Product_Container, Region, Unit_Price, Shipping_Cost, Sales
	          from [KMS Sql Case Study]) AS Region
order by Sales asc

---OR

SELECT TOP 10 Product_Category, Product_Name, Region, Unit_Price, Shipping_Cost, Ship_Mode, Customer_Name, SUM(Sales) AS TotalSales
FROM [KMS Sql Case Study]
GROUP BY Product_Category, Product_Name, Region, Unit_Price, Shipping_Cost, Ship_Mode, Customer_Name
ORDER BY TotalSales ASC

----After identifying them, look into:
--Their purchase frequency=
--Types of products bought=
--Possible upselling/cross-selling strategies=


---------- (5) KMS incurred the most shipping cost using which shipping method?
----Ship_Mode	   Total_Shipping_Cost
---Delivery Truck	51971.9397373199
select top 3 (Ship_Mode),
      SUM(Shipping_Cost) AS Total_Shipping_Cost
	  from [KMS Sql Case Study]
group by Ship_Mode
order by Total_Shipping_Cost desc

--OR

SELECT Ship_Mode, SUM(Shipping_Cost) AS Total_Shipping_Cost
FROM [KMS Sql Case Study]
GROUP BY Ship_Mode
ORDER BY Total_Shipping_Cost DESC

---------- (6) Who are the most valuable customers, and what products or services do they typically purchase?

SELECT TOP 5 Customer_Name,
SUM(Sales) AS Total_Sales,
STRING_AGG(DISTINCT Product_Name)
FROM [KMS Sql Case Study]
GROUP BY Customer_Name,Product_Name
ORDER BY Total_Sales DESC

SELECT Order_ID,Customer_Name, SUM(Sales) AS Total_Sales
FROM [KMS Sql Case Study]
GROUP BY Order_ID, Customer_Name
ORDER BY Total_Sales DESC


---------- (7) Which small business customer had the highest sales?
---Customer_Name	Customer_Segment	Total_Sales
----Dennis Kane	     Small Business	  75967.5932159424

SELECT TOP 1 Customer_Name, Customer_Segment, SUM(Sales) AS Total_Sales
FROM [KMS Sql Case Study]
WHERE Customer_Segment = 'Small Business'
GROUP BY Customer_Segment, Customer_Name
ORDER BY Total_Sales DESC


---------- (8) Which Corporate Customer placed the most number of orders in 2009 – 2012?
---Order_Date	Order_ID	Customer_Segment	Customer_Name	Order_Count
---07/06/2009	 24132	       Corporate	    Justin Knight        6

SELECT Order_Date, Order_ID, Customer_Segment, Customer_Name, COUNT(Order_ID) AS Order_Count
FROM [KMS Sql Case Study]
WHERE Customer_Segment = 'Corporate'
  AND Order_Date BETWEEN '01/01/2009' AND '12/31/2012'
GROUP BY Order_Date, Order_ID, Customer_Segment, Customer_Name
ORDER BY Order_Count DESC

---------- (9) Which consumer customer was the most profitable one?
------Customer_Name	  Customer_Segment	    Total_Profit
-------Emily Phan	      Consumer	      34005.4392166138

SELECT TOP 1 Customer_Name, Customer_Segment, SUM(Profit) AS Total_Profit
FROM [KMS Sql Case Study]
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Name, Customer_Segment
ORDER BY Total_Profit DESC

----------(10) Which customer returned items, and what segment do they belong to?
---customer returned items= 872 RETURNED
---what segment do they belong to = Corporate, Home Office, Small Business & Consumer

SELECT * FROM [KMS Sql Case Study]

SELECT * FROM Order_Status

SELECT [KMS Sql Case Study].Order_ID,
       [KMS Sql Case Study].Customer_Name,
	   [KMS Sql Case Study].Customer_Segment,
	   Order_Status.Order_ID,
	   Order_Status.[Status]
from [KMS Sql Case Study]
join Order_Status
on Order_Status.Order_ID = [KMS Sql Case Study].Order_ID

----------(11) If the delivery truck is the most economical but the slowest shipping method and 
---------Express Air is the fastest but the most expensive one, do you think the company appropriately 
--------spent shipping costs based on the Order Priority?
---not really.

SELECT Ship_Mode, Order_Priority, COUNT(*) AS Order_Count,
       AVG(Shipping_Cost) AS Avg_Shipping_Cost
FROM [KMS Sql Case Study] 
GROUP BY Ship_Mode, Order_Priority
ORDER BY Order_Count DESC;

------Explain your answer.
----🔎From this, assess if Express Air is used mostly for Critical/High Priority orders 
---and Delivery Truck for Low Priority.
--🤔 If costs and priorities are mismatched,that’s your cue to optimize the shipping policy!