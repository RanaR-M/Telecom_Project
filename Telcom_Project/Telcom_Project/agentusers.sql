-- Drop logins if they exist
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'Diane')
    DROP LOGIN Diane;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'Becky')
    DROP LOGIN Becky;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'Stewart')
    DROP LOGIN Stewart;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'Greg')
    DROP LOGIN Greg;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'Jim')
    DROP LOGIN Jim;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'Joe')
    DROP LOGIN Joe;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'Martha')
    DROP LOGIN Martha;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'Dan')
    DROP LOGIN Dan;






-- Create logins for each agent
CREATE LOGIN Diane WITH PASSWORD = 'Diane123', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
CREATE LOGIN Becky WITH PASSWORD = 'Becky123', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
CREATE LOGIN Stewart WITH PASSWORD = 'Stewart123', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
CREATE LOGIN Greg WITH PASSWORD = 'Greg123', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
CREATE LOGIN Jim WITH PASSWORD = 'Jim123', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
CREATE LOGIN Joe WITH PASSWORD = 'Joe123', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
CREATE LOGIN Martha WITH PASSWORD = 'Martha123', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
CREATE LOGIN Dan WITH PASSWORD = 'Dan123', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF

-- Create a user for each agent in Telecom 
USE Telecom;

CREATE USER DianeUser FOR LOGIN Diane
CREATE USER BeckyUser FOR LOGIN Becky
CREATE USER StewartUser FOR LOGIN Stewart
CREATE USER GregUser FOR LOGIN Greg
CREATE USER JimUser FOR LOGIN Jim
CREATE USER JoeUser FOR LOGIN Joe
CREATE USER MarthaUser FOR LOGIN Martha
CREATE USER DanUser FOR LOGIN Dan

-- Grant excute permissions on the Telecom 
GRANT EXECUTE ON dbo.GET_CUSTOMER_INFO TO DianeUser
GRANT EXECUTE ON dbo.GET_CUSTOMER_INFO TO BeckyUser
GRANT EXECUTE ON dbo.GET_CUSTOMER_INFO TO StewartUser
GRANT EXECUTE ON dbo.GET_CUSTOMER_INFO TO GregUser
GRANT EXECUTE ON dbo.GET_CUSTOMER_INFO TO JimUser
GRANT EXECUTE ON dbo.GET_CUSTOMER_INFO TO JoeUser
GRANT EXECUTE ON dbo.GET_CUSTOMER_INFO TO MarthaUser
GRANT EXECUTE ON dbo.GET_CUSTOMER_INFO TO DanUser

--Deny other for security
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO DianeUser
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO BeckyUser
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO StewartUser
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO GregUser
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO JimUser
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO JoeUser
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO MarthaUser
DENY SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO DanUser

go
-- create proc 
CREATE or alter PROCEDURE GET_CUSTOMER_INFO 
    @customer_id INT
AS
BEGIN
    
    IF NOT EXISTS (SELECT 1 FROM dbo.Customer WHERE Customer_ID = @customer_id)
    BEGIN
        PRINT 'Oops! Customer ID not found. Maybe they''re on a secret mission!';
        RETURN
    END

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
END
