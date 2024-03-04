--3

-- This procedure selects customers based on their gender.
GO
CREATE PROC CUS_BY_GENDER @GENDER VARCHAR(20)
AS
SELECT *FROM Customer WHERE Gender=@GENDER
 
EXEC CUS_BY_GENDER 'Male'
GO


--14
-- This procedure displays churned customers sorted by churn score.

CREATE PROC CUS_BY_Churnscore
AS
SELECT CH.[Customer_ID],C.Churn_Score FROM Churn_Customer CH INNER JOIN Customer C
ON C.[Customer_ID]=CH.[Customer_ID]
ORDER BY C.Churn_Score
 
EXEC CUS_BY_churnscore
GO
--

CREATE PROC CUS_BY_Churnscore_range @score1 int,@score2 int
AS
SELECT CH.[Customer_ID],C.Churn_Score FROM Churn_Customer CH INNER JOIN Customer C
ON C.[Customer_ID]=CH.[Customer_ID]
WHERE C.Churn_Score BETWEEN @score1 AND  @score2 
ORDER BY C.Churn_Score
GO

--19
-- This procedure displays the number of customers per service.
CREATE PROC _Agent_Calls_Num
AS
SELECT [agent_id],COUNT([Call_id]) AS [Number Of Calls] FROM [dbo].[Call_Customer_Agent]
GROUP BY [agent_id]
 
EXEC _Agent_Calls_Num
 
GO


--22
-- This procedure displays the average satisfaction rating for calls handled by a specific agent.

CREATE PROC [Average_Rate]
AS
SELECT [agent_id],AVG([satisfaction_rating]) AS [Average Rate] FROM [dbo].[Call_Customer_Agent]
GROUP BY [agent_id]
 
EXEC [Average_Rate]