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