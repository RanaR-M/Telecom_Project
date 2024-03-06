                   ---HADY---
--view Acqcithionchanel with #customer
go
CREATE VIEW Acqcithionchanelwithnumberofcustomer 
AS
SELECT COUNT(c.Channel_ID) AS Number_of_Customers, ac.[Channel_Name]
FROM Customer c
JOIN [Aquisition_Channel] ac ON c.Channel_ID = ac.Channel_ID
GROUP BY ac.[Channel_Name];

go 
--Display Info About Customer For Agent  
CREATE VIEW CustomerInternetInfo AS
SELECT 
    c.[Customer_ID],
    c.[Gender],
    nc.[Contract_Type],
    ins.[ServiceType],
    ins.[Quota]
FROM 
    Customer c
JOIN 
    [New_Comer] nc ON c.[Customer_ID] = nc.[Customer_ID]
JOIN 
    InternetService ins ON c.[Customer_ID] = ins.[CustomerID];
GO
--Total Revenue Per Sta
CREATE VIEW TotalRevenueStatus
AS
SELECT
C.[Status],
SUM(( CI.[TotalCharges] - CI.[TotalRefunds] ) +
(CI.totalExtraDataCharges + CI.TotalLongDistanceCharges)) AS Total_Revenue 
FROM [dbo].[CustomerInternet] CI join Customer C
ON C.Customer_ID = CI.CustomerID 
GROUP BY C.[Status]


-- salwa
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