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
