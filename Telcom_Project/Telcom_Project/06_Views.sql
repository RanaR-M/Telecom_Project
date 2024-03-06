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
-- Rana

-- Get # customers by gender
GO
CREATE VIEW countGenderCustomer
AS

	SELECT
	COUNT(Customer_ID) '# customer'
	, Gender
	FROM
	Customer
	GROUP BY Gender

-- get revenue lost by customer churned

GO
CREATE VIEW TotalRevenueLossChurn
AS
	SELECT
	CHCust.Customer_ID,
	SUM(Cust.) -- Revenue??
	FROM
	Churn_Customer CHCust
	LEFT JOIN Customer Cust
	ON CHCust.Customer_ID = Cust.Customer_ID


-- get avg charge by servie type
GO
CREATE VIEW AVGChargeService
AS
	SELECT
	AVG(MonthlyCharges) 'AVG Monthly Charges',
	ServiceType
	FROM
	CustomerInternet CustInt
	LEFT JOIN InternetService Int
	ON Int.InternetServiceID = CustInt.InternetServiceID
	GROUP BY ServiceType
GO

-- Ahmed

	-- what is the number of customers per city?
CREATE VIEW V_Number_Of_Customers_Per_City
AS
SELECT L.City, COUNT(C.Customer_ID) 'Count Of Customers'
FROM Location L join Customer C 
ON L.Customer_ID = C.Customer_ID
GROUP BY L.City
GO

-- NO of calls answerd per agent and his satisfaction rate?
CREATE VIEW V_#CallsAnswered_AndSatisfactionRate_PerCustomer
AS
SELECT 
	A.Agent_id,
	A.Name 'Agent Name',
	SUM(CCA.answered) 'No Of Answered Calls',
	AVG(satisfaction_rating) 'Avg Satisfaction Rate'
FROM Agent A join Call_Customer_Agent CCA
ON A.Agent_id = CCA.agent_id
GROUP BY A.Agent_id
GO

-- Total Revenue Company Gain From Each City?
CREATE VIEW V_Total_Revenue_Per_City
AS
SELECT 
	L.city,
	SUM(C.Total_Revenue) TR
FROM customer C join [Location] L 
ON C.customer_id = L.customer_id
GROUP BY SUM(C.Total_Revenue)
ORDER BY TR DESC
GO

-- Agent Performance 
CREATE VIEW vw_AgentPerformance AS
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
create view vw_CustomerSatisfaction
SELECT
    Customer_ID,
    AVG(Satisfaction_Rating) AS AvgSatisfaction
FROM
   [dbo].[Call_Customer_Agent]
GROUP BY
    Customer_ID
                          --TopPerformingAgents
CREATE VIEW vw_TopPerformingAgents AS
SELECT
    Agent_ID,
    COUNT(Call_ID) AS TotalCallsHandled
FROM
    Call_Customer_Agent
WHERE
    Answered = 1
GROUP BY
    Agent_ID
ORDER BY
    TotalCallsHandled DESC
	                        ---AvgMonthlyCharge
CREATE VIEW vw_AvgMonthlyCharge AS
SELECT 
    ServiceType,
    AVG(MonthlyCharges) AS AvgMonthlyCharge
FROM InternetService  i
JOIN CustomerInternet c ON i.InternetServiceID = c.InternetServiceID
GROUP BY ServiceType
                         -- Customer Age Brackets
CREATE VIEW CustAgeBrackets AS
SELECT
    Customer_ID,
    DOB,
    CASE
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) < 18 THEN 'Under 18'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 18 AND 24 THEN 'Young  (18-24)'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 25 AND 34 THEN 'Adults (25-34)'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 35 AND 44 THEN 'Adults (35-44)'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 45 AND 54 THEN 'Adults (45-54)'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 55 AND 64 THEN 'old (55-64)'
        ELSE 'Seniors (65 and above)'
    END AS AgeBracket
FROM
    Customer

	            -- churn Customers by Age Group
CREATE VIEW vw_CustByAgeGroup AS
SELECT
    Customer_ID,  
    DATEDIFF(YEAR, C.DOB, GETDATE()) AS Age,
    CASE
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) < 18 THEN 'Under 18'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 18 AND 24 THEN 'Young  (18-24)'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 25 AND 34 THEN 'Adults (25-34)'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 35 AND 44 THEN 'Adults (35-44)'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 45 AND 54 THEN 'Adults (45-54)'
        WHEN DATEDIFF(YEAR, DOB, GETDATE()) BETWEEN 55 AND 64 THEN 'old (55-64)'
        ELSE 'Seniors (65 and above)' 
    END AS AgeGroup,
    CASE
        WHEN Status = 'churn' THEN 'Churned'
        ELSE 'Not Churned'
    END AS ChurnStatus
FROM
    Customer

