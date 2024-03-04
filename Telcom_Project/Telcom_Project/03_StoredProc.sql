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
