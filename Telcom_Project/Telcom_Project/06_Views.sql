                   ---HADY---
--view Acqcithionchanel with #customer
go
CREATE OR ALTER VIEW Acqcithionchanelwithnumberofcustomer 
AS
SELECT ac.[Channel_Name], COUNT(c.Channel_ID) AS Number_of_Customers
FROM Customer c
JOIN [Aquisition_Channel] ac ON c.Channel_ID = ac.Channel_ID
GROUP BY ac.[Channel_Name];

select * from Acqcithionchanelwithnumberofcustomer 

go 
--Display Info About Customer For Agent  
 CREATE OR ALTER VIEW CustomerInternetInfo AS
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
	[dbo].[CustomerInternet] custInt ON custInt.[CustomerID] = nc.Customer_ID
JOIN 
    InternetService ins ON custInt.InternetServiceID = ins.InternetServiceID;
GO
select * from CustomerInternetInfo

GO
--Total Revenue Per Sta
 CREATE OR ALTER VIEW TotalRevenueStatus
AS
SELECT
C.[Status],
SUM(( CI.[TotalCharges] - CI.[TotalRefunds] ) +
(CI.totalExtraDataCharges + CI.TotalLongDistanceCharges)) AS Total_Revenue 
FROM [dbo].[CustomerInternet] CI join Customer C
ON C.Customer_ID = CI.CustomerID 
GROUP BY C.[Status]

SELECT * FROM TotalRevenueStatus
-- Rana

-- Get # customers by gender
GO
 CREATE OR ALTER VIEW countGenderCustomer
AS

	SELECT
	Gender,
	COUNT(Customer_ID) '# customer'
	FROM
	Customer
	GROUP BY Gender

SELECT * FROM countGenderCustomer

-- get revenue lost by customer churned

GO
 CREATE OR ALTER VIEW TotalRevenueLossChurn
AS
	SELECT
	CHCust.Customer_ID,
	SUM(CI.totalExtraDataCharges + CI.TotalLongDistanceCharges) AS Total_Revenue
	FROM
	Churn_Customer CHCust
	LEFT JOIN[CustomerInternet] CI
	ON CHCust.Customer_ID = CI.CustomerID
	GROUP BY CHCust.Customer_ID

	SELECT * FROM TotalRevenueLossChurn

-- get avg charge by servie type
GO
 CREATE OR ALTER VIEW AVGChargeService
AS
	SELECT
	ServiceType,
	AVG(MonthlyCharges) 'AVG Monthly Charges'
	FROM
	CustomerInternet CustInt
	LEFT JOIN InternetService Int
	ON Int.InternetServiceID = CustInt.InternetServiceID
	GROUP BY ServiceType
GO

SELECT * FROM AVGChargeService

-- Ahmed

	-- what is the number of customers per city?
GO
 CREATE OR ALTER VIEW V_Number_Of_Customers_Per_City
AS
SELECT L.City, COUNT(C.Customer_ID) 'Count Of Customers'
FROM Location L join Customer C 
ON L.Customer_ID = C.Customer_ID
GROUP BY L.City 
SELECT * FROM V_Number_Of_Customers_Per_City
GO

-- NO of calls answerd per agent and his satisfaction rate?
 CREATE OR ALTER VIEW V_#CallsAnswered_AndSatisfactionRate_PerCustomer
AS
SELECT 
	A.Agent_id,
	A.Name 'Agent Name',
	SUM(cast(CCA.answered as int)) 'No Of Answered Calls',
	SUM(cast(CCA.resolution_status as int)) 'No Of Resolved Calls',
	AVG(satisfaction_rating) 'Avg Satisfaction Rate'
FROM Agent A 
join Call_Customer_Agent CCA
ON A.Agent_id = CCA.agent_id
GROUP BY A.Agent_id, A.Name
SELECT * FROM V_#CallsAnswered_AndSatisfactionRate_PerCustomer
GO


-- Total Revenue Company Gain From Each City?
 CREATE OR ALTER VIEW V_Total_Revenue_Per_City
AS
SELECT 
	L.city,
	SUM(CI.totalExtraDataCharges + CI.TotalLongDistanceCharges) AS Total_Revenue TR
FROM CustomerInternet CI join [Location] L 
ON CI.customer_id = L.customer_id
GROUP BY L.city
ORDER BY TR DESC
GO


GO
-- Agent Performance 
 CREATE OR ALTER VIEW vw_AgentPerformance AS
SELECT
    a.Agent_ID,
    a.[Name] AS AgentName,
    a.[HANDLING_TIME] AS AvgHandlingTime,
    COUNT(cca.Call_ID) AS TotalCallsHandled,
    SUM(CAST(cca.Answered AS INT)) AS TotalAnsweredCalls,
    AVG(CAST(cca.satisfaction_rating AS FLOAT)) AS AvgSatisfactionRating,
    AVG(CAST(cca.speed_of_answer AS FLOAT)) AS AvgSpeedOfAnswer
FROM
    [dbo].[Agent] a
JOIN
    [dbo].[Call_Customer_Agent] cca ON a.Agent_ID = cca.Agent_ID
GROUP BY
    a.Agent_ID, a.[Name], a.[HANDLING_TIME]
                        -- VIEW CustomerSatisfaction 
GO
 CREATE OR ALTER view vw_CustomerSatisfaction
as
SELECT
    Customer_ID,
    AVG(Satisfaction_Rating) AS AvgSatisfaction
FROM
   [dbo].[Call_Customer_Agent]
GROUP BY
    Customer_ID
                          --TopPerformingAgents
GO
 CREATE OR ALTER VIEW vw_TopPerformingAgents 
AS
SELECT
    Agent_ID,
    COUNT(Call_ID) AS TotalCallsHandled
FROM
    Call_Customer_Agent
WHERE
    Answered = 1
GROUP BY
    Agent_ID
	                        ---AvgMonthlyCharge
GO
 CREATE OR ALTER VIEW vw_AvgMonthlyCharge AS
SELECT 
    ServiceType,
    AVG(MonthlyCharges) AS AvgMonthlyCharge
FROM InternetService  i
JOIN CustomerInternet c ON i.InternetServiceID = c.InternetServiceID
GROUP BY ServiceType

	            -- churn Customers by Age Group
GO
 CREATE OR ALTER VIEW vw_CustByAgeGroup AS
SELECT
    Customer_ID,  
    age,
    CASE
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 24 THEN 'Young  (18-24)'
        WHEN age BETWEEN 25 AND 34 THEN 'Adults (25-34)'
        WHEN age BETWEEN 35 AND 44 THEN 'Adults (35-44)'
        WHEN age BETWEEN 45 AND 54 THEN 'Adults (45-54)'
        WHEN age BETWEEN 55 AND 64 THEN 'old (55-64)'
        ELSE 'Seniors (65 and above)' 
    END AS AgeGroup,
    CASE
        WHEN Status = 'churn' THEN 'Churned'
        ELSE 'Not Churned'
    END AS ChurnStatus
FROM
    Customer

