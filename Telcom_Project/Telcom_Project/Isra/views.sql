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
