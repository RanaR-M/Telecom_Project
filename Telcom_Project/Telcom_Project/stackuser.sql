---stackholder

                --create login for stackholder

use [master]
CREATE LOGIN stackholder WITH PASSWORD = 'telecom', 
CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF



USE Telecom
               -- user associated with the login
CREATE USER stackholderUser FOR LOGIN stackholder;

               -- Grant  on specified views 
GRANT SELECT ON dbo.Acqcithionchanelwithnumberofcustomer TO stackholderUser
GRANT SELECT ON dbo.CustomerInternetInfo TO stackholderUser
GRANT SELECT ON dbo.TotalRevenueStatus TO stackholderUser
GRANT SELECT ON dbo.countGenderCustomer TO stackholderUser
GRANT SELECT ON dbo.TotalRevenueLossChurn TO stackholderUser
GRANT SELECT ON dbo.AVGChargeService TO stackholderUser
GRANT SELECT ON dbo.V_Number_Of_Customers_Per_City TO stackholderUser
GRANT SELECT ON dbo.V_Total_Revenue_Per_City TO stackholderUser
GRANT SELECT ON dbo.vw_AvgMonthlyCharge TO stackholderUser
GRANT SELECT ON dbo.vw_CustByAgeGroup TO stackholderUser


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

use Telecom
 GRANT EXECUTE ON hi_telecom TO stackholderUser

