--Hady----
 
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
-- TEST 
EXEC SelectAllCustomers
 
GO
--Display Customer based on Value of ChurnStatus
CREATE OR ALTER PROCEDURE SelectCustomersByChurnStatus
    @ChurnStatus VARCHAR(50)
AS
BEGIN
    DECLARE @SQLQuery NVARCHAR(MAX);
 
    SET @SQLQuery = 'SELECT * FROM Customer WHERE [Status] = @ChurnStatus';
 
    EXEC sp_executesql @SQLQuery, N'@ChurnStatus VARCHAR(50)', @ChurnStatus;
END;
-- TEST 
EXEC SelectCustomersByChurnStatus 'Churned'
 
GO
--Display Churn Customer With Reason
CREATE OR ALTER PROCEDURE DisplayChurnCustomerWithReason
AS
BEGIN
    SELECT cc.Outer_ID, cc.Tenure_in_Month,
           cc.Churn_Date, cr.Reason_Description
    FROM Churn_Customer cc
    JOIN [Churn Reason] cr ON cc.Outer_ID = cr.Churned_ID;
END;
-- TEST 
EXEC DisplayChurnCustomerWithReason
 
GO

CREATE OR ALTER PROCEDURE CreateNewcomerForm
    @No_of_Dependent INT,
    @age int,
    @Has_Dependent BIT,
    @Has_Referrals BIT,
    @No_of_Referrals INT,
    @ChannelName VARCHAR(50),
    @Contract_Type VARCHAR(30),
	@gender varchar(20),
	@married BIT	
AS
BEGIN
    DECLARE @Customer_ID INT = (SELECT MAX([Customer_ID]) FROM [dbo].[Customer]);
	SET @Customer_ID += 1 
	DECLARE @channelID INT = (SELECT [Channel_ID] FROM [dbo].[Aquisition_Channel] WHERE [Channel_Name] = @ChannelName)
 
    INSERT INTO [Customer] ([Customer_ID], [CLTV],[Gender], [Married], [No_of_Dependent], [Has_Dependent], 
	[Has_Referrals], [No_of_Referrals], [contract_type], [Age], [Channel_ID], [Status])
    VALUES 
	(@Customer_ID, 0, @gender, @married, @No_of_Dependent, @Has_Dependent,
	@Has_Referrals, @No_of_Referrals, @Contract_Type, @age, @channelID, 'Joined');
 
	
    INSERT INTO [New_Comer] ([Customer_ID], [Acquisition_Date])
    VALUES (@Customer_ID, GETDATE());
 
    --  print the inserted data
    SELECT * FROM [dbo].[Customer]
	WHERE [Customer_ID] = @Customer_ID
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
-- TEST 
EXEC PROC_NumOf_Customers_Per_City 'los angeles'
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
-- TEST 
EXEC PROC_ChurnCustomers_Per_City 'los angeles'
GO
 
 
-- # Churn Customers Per Churn Reason Category
CREATE OR ALTER PROC PROC_ChurnCustomers_Per_Category (@Category_ID int)
AS
BEGIN
	SELECT C.CategoryName, COUNT(CC.Customer_ID) 'No of customers'
	FROM Churn_Customer CC join [Churn Reason] CR
	ON CC.Customer_ID = CR.Churned_ID join ChurnCategory C
	ON CR.Churn_Category_ID = C.ChurnCategoryID
	WHERE CR.Churn_Category_ID = @Category_ID
	GROUP BY C.CategoryName
END
-- TEST 
EXEC PROC_ChurnCustomers_Per_Category 1
GO
 
 
-- # Customers Per Aqisition Channle
CREATE OR ALTER PROC PROC_Customers_Per_Aquisition_Channel (@Channel varchar(50))
AS
BEGIN
	SELECT @Channel 'Channel Name', COUNT(Customer_ID) 'No of customers'
	FROM Aquisition_Channel AC join customer C
	ON AC.Channel_ID = C.Channel_ID
	WHERE AC.Channel_Name = @Channel
	GROUP BY AC.Channel_Name
END
-- TEST 
EXEC PROC_Customers_Per_Aquisition_Channel 'Social Media'
GO
 
-- top 5 Reasons Causing Churn
CREATE OR ALTER PROC PROC_Top5_Churn_Reasons
AS
BEGIN
	SELECT TOP 5 CR.Reason_Description ,COUNT(CC.Customer_ID) 'No of customers'
	FROM Churn_Customer CC join [Churn Reason] CR
	ON CC.Customer_ID = CR.Churned_ID
	GROUP BY CR.Reason_Description
	ORDER BY 2 DESC
END
-- TEST 
EXEC PROC_Top5_Churn_Reasons
GO
--
 
---------------------------- as soon as possible ----------------
-- form for the churned customer
CREATE OR ALTER PROC Churned_Customer_Form (@Customer_ID int, @Feedback varchar(max), 
@Tenure int, @Churn_Date date, @Reason varchar(max))
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
	ORDER BY 2 DESC
END
 
-- TEST
EXEC ViewCustomerInfoPayment_Proc
 
-- proc 15
--  This procedure compares a customer's churn rate with 
--  the average churn rate to determine if they are at high or low risk.
 
------------------error ----------------
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
 
-- TEST 
EXEC GetRiskLevelCustomer_Proc 119

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
 
-- TEST
EXEC GetServiceCustomer 119
 
 
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
	topic,
	COUNT(Call_id) '# calls'
	FROM [dbo].[Call_Customer_Agent]
	WHERE topic = @topic
	GROUP BY topic
END
-- TEST
EXEC GetCountCallsTopic 'Contract related'
 
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
	sum(cast(answered as int)) '# Answered', 
	SUM(cast(resolution_status as int)) '# Resolved'
    FROM Call_Customer_Agent
    WHERE agent_id = @agent_id
END
 
-- TEST
EXEC GetResolved 5010

--24 Display success rate per agent
--This procedure displays the success rate of calls handled by a specific agent.
GO
CREATE OR ALTER PROCEDURE Agent_Success 
    @agent_id INT
AS
BEGIN
    SELECT 
        CASE 
            WHEN SUM(CAST(answered AS INT)) > 0 
                THEN (SUM(CAST(resolution_status AS INT)) * 100 / SUM(CAST(answered AS INT)))
            ELSE 0
        END AS 'Success Rate %'
    FROM Call_Customer_Agent
    WHERE agent_id = @agent_id
END
 
-- TEST
EXEC Agent_Success 5010
 
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
 
-- TEST
EXEC GetCustomer 119
 
 
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
 
-- TEST
EXEC HighValueCustomers
GO
 

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
-- TEST
EXEC CallsHandledByAgent @AgentID = 5009
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
-- TEST
 
 
GO
--remove type column and change the label into varchar(200)
CREATE or alter PROC insertoffer @Label VARCHAR(200),@STARTDATE DATETIME,@ENDDATE DATETIME
AS
IF EXISTS(SELECT*FROM[dbo].[Offers] where Offer_Label = @Label)
SELECT'This Offer Is Already Existed'
else
INSERT INTO [dbo].[Offers] VALUES( @Label,@STARTDATE,@ENDDATE)
GO


GO
CREATE OR ALTER PROCEDURE GET_CUSTOMER_INFO 
    @customer_id INT
AS
BEGIN
    SELECT 
        c.*, 
        ci.*, 
        isv.*, 
        ps.*
    FROM
        dbo.Customer AS c
    LEFT JOIN 
        dbo.CustomerInternet AS ci ON c.Customer_ID = ci.CustomerID
    LEFT JOIN
        dbo.InternetService AS isv ON ci.InternetServiceID = isv.InternetServiceID
    LEFT JOIN
        dbo.Phone_Service AS ps ON ps.Customer_ID = c.Customer_ID
    WHERE 
        c.Customer_ID = @customer_id;
END;

GO
-- create proc to display welcome message and Views that stackholder allow to Query 
CREATE or alter PROCEDURE hi_telecom
AS
BEGIN
    PRINT 'Welcome, sir!';
    PRINT 'Feel free to explore the information and generate valuable insights.';
 
    -- list of views the user has access to
    PRINT 'List of Views:'
 
    DECLARE @ViewName NVARCHAR(255);
 
    DECLARE view_cursor CURSOR FOR
    SELECT TABLE_NAME
    FROM INFORMATION_SCHEMA.VIEWS
    WHERE TABLE_SCHEMA = 'dbo';
 
    OPEN view_cursor;
 
    FETCH NEXT FROM view_cursor INTO @ViewName;
 
    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT @ViewName;
        FETCH NEXT FROM view_cursor INTO @ViewName;
    END
 
    CLOSE view_cursor
    DEALLOCATE view_cursor
END

go
CREATE OR ALTER PROCEDURE HI_QA_Welcome
AS
BEGIN
    PRINT 'Welcome, QA Team!';
    PRINT 'Feel free to query the allowed views and gather valuable insights.';
END;
go

CREATE PROCEDURE UpdateCustomerStatus
AS
BEGIN
    DECLARE @customerId INT;
    DECLARE @acquisitionDate DATE;
    DECLARE @status VARCHAR(50);

    DECLARE customerCursor CURSOR FOR
    SELECT NC.[Acquisition_Date], NC.[Customer_ID]
    FROM [dbo].[New_Comer] NC
    JOIN customer c ON c.Customer_id = NC.Customer_id;

    OPEN customerCursor;

    FETCH NEXT FROM customerCursor INTO @acquisitionDate, @customerId;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF DATEDIFF(MONTH, @acquisitionDate, GETDATE()) <= 1
            SET @status = 'Joined';
        ELSE IF DATEDIFF(MONTH, @acquisitionDate, GETDATE()) > 1 
            AND NOT EXISTS (SELECT 1 FROM [dbo].[Churn_Customer] OC WHERE OC.Customer_id = @customerId)
            SET @status = 'stayed';
        ELSE
            SET @status = 'CHURN';

        -- Update status 
        UPDATE customer
        SET status = @status
        WHERE Customer_id = @customerId;

        -- Fetch the next row
        FETCH NEXT FROM customerCursor INTO @acquisitionDate, @customerId;
    END

    CLOSE customerCursor;
    DEALLOCATE customerCursor;
END;
