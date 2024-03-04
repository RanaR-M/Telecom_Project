----Hady----

--Display Customer with Aquisition_Channel
CREATE PROCEDURE SelectAllCustomers
AS
BEGIN
    SELECT c.[Customer_ID] , c.[Status] , c.[Churn_Score]
    c.[No_of_Dependent] ,c.[No_of_Referrals]
    ,AC.[Channel_Name]
    FROM Customers c Join [Aquisition_Channel] AC 
    ON c.[Customer_ID] = AC.[Customer_ID];
END;

--Display Customer based on Value of ChurnStatus
CREATE PROCEDURE SelectCustomersByChurnStatus
    @ChurnStatus VARCHAR(50)
AS
BEGIN
    DECLARE @SQLQuery NVARCHAR(MAX);

    SET @SQLQuery = 'SELECT * FROM Customers WHERE ChurnStatus = @ChurnStatus';

    EXEC sp_executesql @SQLQuery, N'@ChurnStatus VARCHAR(50)', @ChurnStatus;
END;

--Display Churn Customer With Reason
CREATE PROCEDURE DisplayChurnCustomerWithReason
AS
BEGIN
    SELECT cc.Outer_ID, cc.Feedback, cc.Tenure_in_Month,
           cc.Churn_Date, cr.Reason_Description
    FROM Churn_Customer cc
    JOIN Churn_Reason cr ON cc.Outer_ID = cr.Churned_ID;
END;

--Form for Newcomers 
CREATE PROCEDURE CreateNewcomerForm
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

    INSERT INTO [Customer] ([No_of_Dependent], [DOB], [Has_Dependent], [Has_Referrals], [No_of_Referrals])
    VALUES (@No_of_Dependent, @DOB, @Has_Dependent, @Has_Referrals, @No_of_Referrals);

    SET @Customer_ID = IDENT_CURRENT('Customer') ; -- Get the last inserted Customer_ID

    DECLARE channel CURSOR FOR
    SELECT [Channel_ID], [Channel_Name]
    FROM [Acquisition_Channel];

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





