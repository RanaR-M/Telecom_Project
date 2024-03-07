----Hady----

--Display Customer with Aquisition_Channel
CREATE OR ALTER PROCEDURE SelectAllCustomers
AS
BEGIN
    SELECT c.[Customer_ID] , c.[Status] , c.[Churn_Score],
    c.[No_of_Dependent] ,c.[No_of_Referrals]
    ,AC.[Channel_Name]
    FROM Customer c Join [Aquisition_Channel] AC 
    ON c.[Channel_ID] = AC.[Channel_ID];
END;

GO
--Display Customer based on Value of ChurnStatus
CREATE OR ALTER PROCEDURE SelectCustomersByChurnStatus
    @ChurnStatus VARCHAR(50)
AS
BEGIN
    DECLARE @SQLQuery NVARCHAR(MAX);

    SET @SQLQuery = 'SELECT * FROM Customers WHERE ChurnStatus = @ChurnStatus';

    EXEC sp_executesql @SQLQuery, N'@ChurnStatus VARCHAR(50)', @ChurnStatus;
END;

GO
--Display Churn Customer With Reason
 CREATE OR ALTER PROCEDURE DisplayChurnCustomerWithReason
AS
BEGIN
    SELECT cc.Outer_ID, cc.Feedback, cc.Tenure_in_Month,
           cc.Churn_Date, cr.Reason_Description
    FROM Churn_Customer cc
    JOIN [Churn Reason] cr ON cc.Outer_ID = cr.Churned_ID;
END;

GO
--Form for Newcomers 
 CREATE OR ALTER PROCEDURE CreateNewcomerForm
    @No_of_Dependent INT,
    @DOB DATE,
    @Email VARCHAR(100),
    @Has_Dependent BIT,
    @Has_Referrals BIT,
    @No_of_Referrals INT,
    @ChannelName VARCHAR(50),
    @Contract_Type VARCHAR(30),
    @Acquisition_Date DATE
AS
BEGIN
    DECLARE @Customer_ID INT;

    INSERT INTO [Customer] ([No_of_Dependent], [Has_Dependent], [Has_Referrals], [No_of_Referrals])
    VALUES (@No_of_Dependent, @Has_Dependent, @Has_Referrals, @No_of_Referrals);

    SET @Customer_ID = IDENT_CURRENT('Customer') ; -- Get the last inserted Customer_ID

    DECLARE channel CURSOR FOR
    SELECT [Channel_ID], [Channel_Name]
    FROM [Aquisition_Channel];

    OPEN channel;

    DECLARE @Channel_ID INT,
            @Channel_Name NVARCHAR(100);

    FETCH NEXT FROM channel INTO @Channel_ID, @Channel_Name;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @Channel_Name = @ChannelName
        BEGIN
            INSERT INTO [Customer] ([Channel_ID]) VALUES (@Channel_ID);
        END

        FETCH NEXT FROM channel INTO @Channel_ID, @Channel_Name;
    END;

    CLOSE channel;
    DEALLOCATE channel;

    INSERT INTO [New_Comer] ([Customer_ID], [Contract_Type], [Acquisition_Date])
    VALUES (@Customer_ID, @Contract_Type, GETDATE());

    --  print the inserted data
    SELECT @Customer_ID AS Customer_ID,
           @No_of_Dependent AS No_of_Dependent,
           @DOB AS DOB,
           @Has_Dependent AS Has_Dependent,
           @Has_Referrals AS Has_Referrals,
           @No_of_Referrals AS No_of_Referrals,
           @ChannelName AS ChannelName,
           @Contract_Type AS Contract_Type,
           @Acquisition_Date AS Acquisition_Date;
END;
GO

-- # customers per city
 CREATE OR ALTER PROC PROC_NumOf_Customers_Per_City (@City varchar(50))
AS
BEGIN
	SELECT @City, COUNT(C.Customer_ID)
	FROM Customer C join [Location] L
	ON C.Customer_ID = L.Customer_ID
	WHERE L.City = @City
	GROUP BY L.City
END
GO

 CREATE OR ALTER PROC PROC_ChurnCustomers_Per_City (@City varchar(50))
AS
BEGIN
	SELECT @city AS City, COUNT(CC.Customer_ID) AS ChurnCount
	FROM Churn_Customer CC
	JOIN [Location] L ON CC.Customer_ID = L.Customer_ID
	WHERE L.City = @City
	GROUP BY City;
END
GO

-- # Churn Customers Per Churn Reason Category
 CREATE OR ALTER PROC PROC_ChurnCustomers_Per_Category (@Category varchar(100))
AS
BEGIN
	SELECT @Category, COUNT(CC.Customer_ID)
	FROM Churn_Customer CC join [Churn Reason] CR
	ON CC.Customer_ID = CR.Churned_ID join ChurnCategory C
	ON CR.Churn_Category_ID = C.ChurnCategoryID
	WHERE C.CategoryName = @Category
	GROUP BY C.CategoryName
END
GO

-- # Customers Per Aqisition Channle
 CREATE OR ALTER PROC PROC_Customers_Per_Aquisition_Channel (@Channel varchar(50))
AS
BEGIN
	SELECT @Channel, COUNT(Customer_ID)
	FROM Aquisition_Channel AC join customer C
	ON AC.Channel_ID = C.Channel_ID
	WHERE AC.Channel_Name = @Channel
	GROUP BY AC.Channel_Name
END
GO

-- top 5 Reasons Causing Churn
 CREATE OR ALTER PROC PROC_Top5_Churn_Reasons
AS
BEGIN
	SELECT TOP 5 CR.Reason_Description ,COUNT(CC.Customer_ID)
	FROM Churn_Customer CC join [Churn Reason] CR
	ON CC.Customer_ID = CR.Churned_ID
	GROUP BY CR.Reason_Description
	ORDER BY 2 DESC
END
GO
-- 

-- form for the churned customer
 CREATE OR ALTER PROC Churned_Customer_Form (@Customer_ID int, @Feedback varchar(max), @Tenure int, @Churn_Date date, @Reason varchar(max))
AS
BEGIN
	INSERT INTO [Churn_Customer] (Customer_ID,Feedback,Tenure_in_Month,Churn_Date)
	VALUES (@Customer_ID,@Feedback,@Tenure,@Churn_Date);

	INSERT INTO [Churn Reason] (Reason_Description,Churned_ID,Churn_Category_ID)
	
	Select @Reason, @Customer_ID,
		CASE @Reason
		when 'Attitude of support person' then 1
		when 'Attitude of service provider' then 1
		when 'Competitor made better offer' then 2
		when 'Competitor had better devices' then 2
		when 'Competitor offered higher download speeds' then 2
		when 'Competitor offered more data' then 2
		when 'Lack of self-service on Website' then 3
		when 'Network reliability' then 3
		when 'Product dissatisfaction' then 3
		when 'Poor expertise of online support' then 3
		when 'Poor expertise of phone support' then 3
		when 'Limited range of services' then 3
		when 'Service dissatisfaction' then 3
		when 'Price too high' then 4
		when 'Lack of affordable download/upload speed' then 4
		when 'Long distance charges' then 4
		when 'Extra data charges' then 4
		else 'Other'
		End 
END



-- proc 7
-- This procedure selects customers based on their payment method.
GO
 CREATE OR ALTER PROC ViewCustomerInfoPayment_Proc 
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
 CREATE OR ALTER PROC GetRiskLevelCustomer_Proc
(
	@Customer_ID INT
)
AS
BEGIN
	SELECT
		CASE
		WHEN ([Churn_Score] > AVG(Churn_Score)) THEN 'High'
		ELSE 'Low'
		END 
		AS RiskLevel
	FROM
	[dbo].[Customer]
	WHERE [Customer_ID] = @Customer_ID
	GROUP BY [Customer_ID],[Churn_Score]
END


-- PROC 18
-- This procedure displays services for a particular customer, taking their ID as a parameter.


GO
 CREATE OR ALTER PROC GetServiceCustomer
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
	[multiple_lines]
	FROM
	[dbo].[CustomerInternet] CustINTServ
	LEFT JOIN [dbo].[InternetService] INTServ
	ON INTServ.InternetServiceID = CustINTServ.InternetServiceID
	LEFT JOIN [dbo].[Phone_Service] PHServ
	ON CustINTServ.CustomerID = PHServ.Customer_ID
	WHERE 
	CustINTServ.CustomerID = @Customer_ID
END



-- PROC 21
--     This procedure displays the number of calls related to a specific topic.

GO
 CREATE OR ALTER PROC GetCountCallsTopic
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
	GROUP BY topic
END

--- this procs gets # of calls by topic
GO
 CREATE OR ALTER PROC GetCountCallsALLTopic
AS
BEGIN
	SELECT 
	COUNT(Call_id) '# calls',
	topic
	FROM [dbo].[Call_Customer_Agent]
	GROUP BY topic
END


--23 Display resolved and answered calls per agent
--This procedure displays the number of resolved and answered calls handled by a specific agent.
 GO
 CREATE OR ALTER PROCEDURE GetResolved
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
 CREATE OR ALTER PROCEDURE Agent_Success 
    @agent_id INT
AS
BEGIN
    SELECT 
	(SUM(cast(resolution_status as int)) / SUM(cast(answered as int))) * 100 'Success Rate %'
    FROM Call_Customer_Agent
    WHERE agent_id = @agent_id
END

--2 Select customer based on ID
--This procedure selects a customer based on their ID. 
GO
 CREATE OR ALTER PROCEDURE GetCustomer
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
CREATE OR ALTER PROCEDURE GetCustomer_loc 
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


---NewcomersByContract
GO
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
----EXEC NewcomersByContract @ContractType = edylo type


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
        SUM(cast (resolution_status as int)) AS Calls_Handled
    FROM
	[dbo].[Call_Customer_Agent]
    WHERE
        agent_id = @AgentID
    GROUP BY Agent_id
END
EXEC CallsHandledByAgent @AgentID = edylo
GO

-- insert customers offers
CREATE OR ALTER PROC TAKING_OFFER @OFFER_ID INT,@CUSTOMER_ID INT
AS 
BEGIN TRY
INSERT INTO [dbo].[Taking Offers] VALUES (@OFFER_ID,@CUSTOMER_ID)
END TRY
BEGIN CATCH
SELECT'ERROR'
END CATCH

GO
--remove type column and change the label into varchar(200)
CREATE or alter PROC insertoffer @Label VARCHAR(200),@STARTDATE DATETIME,@ENDDATE DATETIME
AS
IF EXISTS(SELECT*FROM[dbo].[Offers] where Offer_Label = @Label)
SELECT'This Offer Is Already Existed'
else
INSERT INTO [dbo].[Offers] VALUES( @Label,@STARTDATE,@ENDDATE)
GO
