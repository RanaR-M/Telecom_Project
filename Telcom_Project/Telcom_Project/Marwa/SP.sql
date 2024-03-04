--23 Display resolved and answered calls per agent
--This procedure displays the number of resolved and answered calls handled by a specific agent.
 
CREATE PROCEDURE GetResolved
    @agent_id INT
AS
BEGIN
    SELECT 
	COUNT(answered) '# Answered', 
	COUNT(resolution_status) '# Resolved'
    FROM Call_Customer_Agent
    WHERE agent_id = @agent_id
    AND answered = 1
    AND resolution_status = 1
END
 
 
--24 Display success rate per agent
--This procedure displays the success rate of calls handled by a specific agent.
GO 
CREATE PROCEDURE Agent_Success 
    @agent_id INT
AS
BEGIN
    SELECT 
	(SUM(resolution_status) / SUM(answered)) * 100 'Success Rate %'
    FROM Call_Customer_Agent
    WHERE agent_id = @agent_id
END

--2 Select customer based on ID
--This procedure selects a customer based on their ID. 
GO
CREATE PROCEDURE GetCustomer
@customer_id INT 
AS 
BEGIN 
	SELECT
	* 
	FROM 
	[dbo].[Customer] 
	WHERE 
	Customer_ID = @customer_id 
END


--5 Select customers based on location 
--This procedure returns customers' location data based on location id.
GO
CREATE PROCEDURE GetCustomer_loc 
@location_id INT 
AS 
BEGIN 
	SELECT 
	* 
	FROM 
	[dbo].[Location] 
	WHERE 
	[Location_ID] = @location_id 
END
