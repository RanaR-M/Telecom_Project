
-- proc 7
-- This procedure selects customers based on their payment method.

CREATE PROC ViewCustomerInfoPayment_Proc 
AS
BEGIN
	SELECT 
	  PayM.Payment_Type,
	  COUNT(CustPay.Customer_ID) '# Customers'
	FROM [dbo].[Customer_Paying] CustPay
	LEFT JOIN [dbo].[Payment_Method] PayM
	ON PayM.Payment_Method_ID = CustPay.Payment_ID	
	GROUP BY PayM.Payment_Type 
END


-- proc 15
--  This procedure compares a customer's churn rate with 
--  the average churn rate to determine if they are at high or low risk.

GO
CREATE PROC GetRiskLevelCustomer_Proc
(
	@Customer_ID INT
)
AS
BEGIN
	SELECT
		CASE
		WHEN [Churn_Score] > AVG(Churn_Score) THEN 'High'
		ELSE 'Low'
		END 
		AS RiskLevel
	FROM
	[dbo].[Customer]
	WHERE [Customer_ID] = @Customer_ID
END


-- PROC 18
-- This procedure displays services for a particular customer, taking their ID as a parameter.


GO
CREATE PROC GetServiceCustomer
(
	@Customer_ID INT
)
AS
BEGIN
	SELECT
	[StreamingTV],
	[StreamingMovies],
	[OnlineSecurity],
	[ServiceType],
	[OnlineBackup],
	[Quota],
	[DeviceProtection],
	[service_type] 'PhoneServiceType',
	[multiple_lines]
	FROM
	[dbo].[InternetService] INTServ
	LEFT JOIN [dbo].[Phone_Service] PHServ
	ON INTServ.CustomerID = PHServ.Customer_ID
	WHERE 
	INTServ.CustomerID = @Customer_ID
END



-- PROC 21
--     This procedure displays the number of calls related to a specific topic.

GO
CREATE PROC GetCountCallsTopic
(
	@topic varchar(30)
)
AS
BEGIN
	SELECT 
	COUNT(Call_id) '# calls',
	topic
	FROM [dbo].[Call_Customer_Agent]
	WHERE topic = @topic
END

--- this procs gets # of calls by topic
GO
CREATE PROC GetCountCallsALLTopic
AS
BEGIN
	SELECT 
	COUNT(Call_id) '# calls',
	topic
	FROM [dbo].[Call_Customer_Agent]
	GROUP BY topic
END
