//CUSTOMER SEGMENTATION//
WITH total_amount AS (
  SELECT 
    a.customer_id, 
    COALESCE(SUM(b.amount), 0) AS TotalAmount
  FROM Customers a
  LEFT JOIN Orders b 
    ON a.customer_id = b.customer_id
  GROUP BY a.customer_id
)

SELECT 
  customer_id, 
  TotalAmount,
  CASE 
    WHEN TotalAmount = 0 THEN 'No Purchase'
    WHEN TotalAmount < 2000 THEN 'Low Spender'
    ELSE 'High Spender'
  END AS Category
FROM total_amount;

//CUSTOMER BEHAVIOUR//
SELECT 
  a.customer_id, 
  COUNT(b.order_id) AS No_of_orders, 
  COALESCE(AVG(b.amount), 0) AS AvgOrderValue
FROM Customers a 
LEFT JOIN Orders b 
  ON a.customer_id = b.customer_id
GROUP BY a.customer_id;

//FULL CUSTOMER DASHBOARD//
WITH cte_customer AS (
  SELECT 
    a.customer_id, 
    COUNT(b.order_id) AS No_of_orders, 
    COALESCE(AVG(b.amount), 0) AS AvgOrderValue, 
    COALESCE(SUM(b.amount), 0) AS TotalSpend
  FROM Customers a 
  LEFT JOIN Orders b 
    ON a.customer_id = b.customer_id
  GROUP BY a.customer_id
)

SELECT *, 
  CASE 
    WHEN TotalSpend = 0 THEN 'No Purchase'
    WHEN TotalSpend < 2000 THEN 'Low Spender'
    ELSE 'High Spender'
  END AS Customer_Category 
FROM cte_customer;


//CUSTOMER RANKING//
WITH cte_customer AS (
  SELECT 
    a.customer_id, 
    COALESCE(SUM(b.amount), 0) AS TotSpending
  FROM Customers a 
  LEFT JOIN Orders b 
    ON a.customer_id = b.customer_id
  GROUP BY a.customer_id
)

SELECT 
  *, 
  DENSE_RANK() OVER (ORDER BY TotSpending DESC) AS rn,
  (MAX(TotSpending) OVER () - TotSpending) AS DiffSpending
FROM cte_customer;


