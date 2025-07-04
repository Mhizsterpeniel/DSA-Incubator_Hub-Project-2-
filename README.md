# DSA-Project-Documentation-2-
This is another journey towards my Portfolio building while taking my Data Analysis class with Incubator Hub.
I have gained alot of data driven insights and knowledge regarding data analysis process and 
more related skills to data analysis ranging from aquiring skills on the great impact of various
tools in this field,
Tool's Like:
- MS Excel.
- SQL (Simple Query Language).
- Power BI.

## Project Topic: Kultra Mega Stores Inventory.
### Project Overview
Kultra Mega Stores (KMS), headquartered in Lagos, specialises in offi ce supplies and furniture.
Its customer base includes individual consumers, small businesses (retail), and large corporate 
clients (wholesale) across Lagos, Nigeria. You have been engaged as a Business Intelligence Analyst 
to support the Abuja division of KMS. The Business Manager has shared an Excel fi le containing order 
data from 2009 to 2012 and has requested that you analyze the data and present your key insights and findings.

### Dataset Description
The dataset contains information scraped from Amazon product pages, 
including:
- Product details: name, category, price, discount, and ratings
- Customer engagement: user reviews, titles, and content
- Each row represents a unique product, with aggregated reviewer data stored as comma-separated values

Applying my SQL skills from the DSA Data Analysis class to solve both case scenarios as shared in the document.

## Case Scenario I
1. Which product category had the highest sales?
2. What are the Top 3 and Bottom 3 regions in terms of sales?
3. What were the total sales of appliances in Ontario?
4. Advise the management of KMS on what to do to increase the revenue from the bottom 10 customers
5. KMS incurred the most shipping cost using which shipping method?

## Case Scenario II
6. Who are the most valuable customers, and what products or services do they typically purchase?
7. Which small business customer had the highest sales?
8. Which Corporate Customer placed the most number of orders in 2009 – 2012?
9. Which consumer customer was the most profitable one?
10. Which customer returned items, and to which segment do they belong?
11. If the delivery truck is the most economical but the slowest shipping method, and Express Air 
is the fastest but the most expensive one, do you think the company appropriately spent shipping 
costs based on the Order Priority? Explain your answer

# Step-By-Step Guide 
## Using MS Excel and SQL;

Tools Below:
- MS Excel[Download Here](https://www.Microsoftoffice.com)
- SQL Sever Management Studio 20[Download Here](https://www.sqlstudio20.com)

### Data Cleaning, Preparation and Database Creation.

1.Open your dataset in Excel.
2.Check for missing values:
   - Use `Filter` to find blanks in all columns.
   - Remove or fill missing values as appropriate.

3.Create Database on SQL:
```sql
CREATE DATABASE DSA_PROJECT_DB
```
4.Importing and Data call out on SQL:
Right click on the newly created database and select task, and the select "Import Flat Files".
Select my file and set the necessary data type to the following data like;(Row_ID as (integer) or (float), etc).
 
--Data call_out;
```sql
SELECT * FROM [KMS Sql Case Study]
```

### 📦 _Case Scenario I_

1. Which product category had the highest sales?
```sql
select top 1* from (
       select Product_category, Sales
	          from [KMS Sql Case Study]) AS Sales
order by Sales desc
```
-- OR

```sql
SELECT Category, SUM(Sales) AS TotalSales
FROM [KMS Sql Case Study]
GROUP BY Category
ORDER BY TotalSales DESC
LIMIT 1;
```
**✅ Assumes a `Category` and `Sales` columm**
**🧠 We’re summing up sales per category and picking the top one**

2. Top 3 and Bottom 3 regions in terms of sales.
```sql
select top 3* from (
       select Region, Sales
	          from [KMS Sql Case Study]) AS Region
order by Sales desc

select top 3 * from (
       select Region, Sales
	          from [KMS Sql Case Study]) AS Region
order by Sales asc
```
--OR

```sql
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
```
**📊 Use of `ORDER BY` both ways lets you find top and bottom**

3. Total sales of appliances in Ontario.
```sql
SELECT SUM(Sales) AS ApplianceSales
FROM [KMS Sql Case Study]
WHERE Category = 'Appliances'
  AND Region = 'Ontario';
```
- ✅ Simple filter on both category and region.

4. Advice for bottom 10 customers.
```sql
select top 10 * from (
       select Customer_Name, Product_Category, Product_Name, Product_Container, Region, Unit_Price, Shipping_Cost, Sales
	          from [KMS Sql Case Study]) AS Region
order by Sales asc
```

--OR

```sql
SELECT CustomerID, CustomerName, SUM(Sales) AS TotalSales
FROM [KMS Sql Case Study]
GROUP BY CustomerID, CustomerName
ORDER BY TotalSales ASC
LIMIT 10;
```
- 🚀 After identifying them, look into:
  - **Their purchase frequency**
  - **Types of products bought**
  - **Possible upselling/cross-selling strategies**

5. Shipping method with the highest total shipping cost.
```sql
select top 3 (Ship_Mode),
      SUM(Shipping_Cost) AS Total_Shipping_Cost
	  from [KMS Sql Case Study]
group by Ship_Mode
order by Total_Shipping_Cost desc
```

--OR

```sql
SELECT ShipMode, SUM(ShippingCost) AS TotalShippingCost
FROM [KMS Sql Case Study]
GROUP BY ShipMode
ORDER BY TotalShippingCost DESC
LIMIT 1;
```
- 💸 **Useful for analyzing cost efficiency**

---

### 🧑‍💼 _Case Scenario II_

6. Most valuable customers and what they bought.
```sql
SELECT CustomerID, CustomerName, SUM(Sales) AS TotalSales,
       STRING_AGG(DISTINCT ProductName, ', ') AS Products
FROM [KMS SQL Case Study]
GROUP BY CustomerID, CustomerName
ORDER BY TotalSales DESC
LIMIT 5;
```
- 💡 Modify `ProductName` based on the actual column.
- 📦 This shows both who they are and their preferences.

7. Small Business customer with the highest sales.
```sql
SELECT CustomerID, CustomerName, SUM(Sales) AS TotalSales
FROM [KMS SQL Case Study]
WHERE Segment = 'Small Business'
GROUP BY CustomerID, CustomerName
ORDER BY TotalSales DESC
LIMIT 1;
```

8. Corporate Customer with most orders (2009–2012).
```sql
SELECT CustomerID, CustomerName, COUNT(OrderID) AS OrderCount
FROM [KMS SQL Case Study]
WHERE Segment = 'Corporate'
  AND OrderDate BETWEEN '2009-01-01' AND '2012-12-31'
GROUP BY CustomerID, CustomerName
ORDER BY OrderCount DESC
LIMIT 1;
```

9. Most profitable (consumer) customer.
```sql
SELECT CustomerID, CustomerName, SUM(Profit) AS TotalProfit
FROM [KMS Sql Case Study]
WHERE Segment = 'Consumer'
GROUP BY CustomerID, CustomerName
ORDER BY TotalProfit DESC
LIMIT 1;
```

10. Customers who returned items and their segments.
```sql
SELECT * FROM [KMS Sql Case Study]

SELECT * FROM Order_Status

SELECT [KMS Sql Case Study].Order_ID,
       [KMS SQL Case Study].Customer_Name,
	   [KMS SQL Case Study].Customer_Segment,
	   Order_Status.Order_ID,
	   Order_Status.[Status]
from [KMS SQL Case Study]
join Order_Status
on Order_Status.Order_ID = [KMS SQL Case Study].Order_ID
```

--OR

```sql
SELECT DISTINCT CustomerID, CustomerName, Segment
FROM Returns
JOIN [KMS SQL Case Study] USING (OrderID);
```
- 📥 **Assumes you have a `Returns` table**
- 🔗 **Use a `JOIN` on OrderID to pull customer info**

11. Analyze shipping mode vs. order priority.
```sql
SELECT ShipMode, OrderPriority, COUNT(*) AS OrderCount,
       AVG(ShippingCost) AS AvgShippingCost
FROM [KMS SQL Case Study]
GROUP BY ShipMode, OrderPriority;
```
