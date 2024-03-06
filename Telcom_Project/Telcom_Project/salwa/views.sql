CREATE VIEW CUST_CATEGORY_AND_REASON_CHURN
 AS SELECT CR.[Churned_ID],CC.[CategoryName],CR.[Reason_Description] FROM 
 [dbo].[Churn Reason] CR INNER JOIN [dbo].[ChurnCategory] CC ON CR.[Churn_Category_ID]=CC.[ChurnCategoryID]
 GO
 --2
 CREATE VIEW TOP10_CUSTOMER_REVENUE
 AS SELECT 
 TOP 10 Revenue,[Customer_ID]
 FROM [dbo].[Customer]
 ORDER BY Revenue DESC
 GO
 --3
 CREATE VIEW CUSTOMER_NUM_PER_OFFERAS
 AS
 SELECT [Offer_ID],COUNT([Customer_ID])AS [Number Of Customers] FROM [dbo].[Taking Offers]
 GROUP BY [Offer_ID]
 GO