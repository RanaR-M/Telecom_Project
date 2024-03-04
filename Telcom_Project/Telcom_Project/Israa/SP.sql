---NewcomersByContract

CREATE OR ALTER PROC NewcomersByContract
    @ContractType VARCHAR(30)
AS
BEGIN
    SELECT
        Customer_ID,
        Contract_Type,
        Acquisition_Date
    FROM
        [dbo].[New_Comer]
    WHERE
        Contract_Type = @ContractType
END
----EXEC SelectNewcomersByContract @ContractType = edylo type
                              ----customers by CLTV
GO
CREATE OR ALTER PROC HighValueCustomers
AS
BEGIN
    
    SELECT
        Customer_ID,
        CLTV
    FROM
        [dbo].[Customer]
    WHERE
    CLTV > 4000 
END

GO
--EXEC HighValueCustomers
                -- offers to cust with low satisfaction ratings<3


------------ TODO ------------------------

/*
CREATE OR ALTER PROC OffersToLowSatisfactionCust
AS
BEGIN
     IF
	 Customer_ID IN 
	(
	SELECT 
	Customer_ID 
	FROM 
	[dbo].[Call_Customer_Agent] 
	WHERE 
	satisfaction_rating < 3
	)
	THEN 
	PRINT(offer_label)

END

*/
-- # of calls resolved

GO
CREATE OR ALTER PROC CallsHandledByAgent
    @AgentID INT
AS
BEGIN
    
    SELECT
        agent_id AS Agent_ID,
        SUM(resolution_status) AS Calls_Handled
    FROM
	[dbo].[Call_Customer_Agent]
    WHERE
        agent_id = @AgentID
    GROUP BY Agent_id
END
EXEC CallsHandledByAgent @AgentID = edylo