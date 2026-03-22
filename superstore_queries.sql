-- Query 1: Sales and Profit by Region
SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS Profit_Margin_Pct
FROM orders
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Query 2: Profit by Sub-Category
SELECT 
    Category,
    `Sub-Category`,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS Profit_Margin_Pct
FROM orders
GROUP BY Category, `Sub-Category`
ORDER BY Total_Profit ASC;

-- Query 3: Top Sub-Category per Region (Window Function)
WITH ranked AS (
    SELECT 
        Region,
        `Sub-Category`,
        ROUND(SUM(Sales), 2) AS Total_Sales,
        RANK() OVER (PARTITION BY Region 
                     ORDER BY SUM(Sales) DESC) AS Sales_Rank
    FROM orders
    GROUP BY Region, `Sub-Category`
)
SELECT * FROM ranked WHERE Sales_Rank = 1;

-- Query 4: RFM Customer Analysis
SELECT 
    `Customer Name`,
    COUNT(DISTINCT `Order ID`) AS Frequency,
    ROUND(SUM(Sales), 2) AS Monetary,
    MAX(`Order Date`) AS Last_Purchase_Date
FROM orders
GROUP BY `Customer Name`
ORDER BY Monetary DESC
LIMIT 10;

-- Query 5: Discount Impact on Profitability
SELECT 
    `Discount Tier`,
    COUNT(*) AS Total_Orders,
    ROUND(AVG(Discount) * 100, 2) AS Avg_Discount_Pct,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS Profit_Margin_Pct
FROM orders
GROUP BY `Discount Tier`
ORDER BY Avg_Discount_Pct ASC;