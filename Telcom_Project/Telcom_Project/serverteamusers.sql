---team users for server 
CREATE LOGIN [Asaeso] WITH PASSWORD = 'yalhwy'
CREATE LOGIN [memo] WITH PASSWORD = 'yalhwy'
CREATE LOGIN [ahmed] WITH PASSWORD = 'yalhwy'
CREATE LOGIN [hadikh] WITH PASSWORD = 'yalhwy'
CREATE LOGIN [salwa] WITH PASSWORD = 'yalhwy'

USE [Telecom]
CREATE USER [Asaeso] FOR LOGIN [Asaeso]
CREATE USER [memo] FOR LOGIN [memo]
CREATE USER [ahmed] FOR LOGIN [ahmed]
CREATE USER [hadikh] FOR LOGIN [hadikh]
CREATE USER [salwa] FOR LOGIN [salwa]


EXEC sp_addrolemember 'db_owner', 'Asaeso'
EXEC sp_addrolemember 'db_owner', 'memo'
EXEC sp_addrolemember 'db_owner', 'ahmed'
EXEC sp_addrolemember 'db_owner', 'hadikh'
EXEC sp_addrolemember 'db_owner', 'salwa'



SELECT role.name AS 'Role', member.name AS 'User'
FROM sys.database_role_members
JOIN sys.database_principals AS role ON role.principal_id = role_principal_id
JOIN sys.database_principals AS member ON member.principal_id = member_principal_id
WHERE role.name = 'db_owner';

USE Telecom

-- Grant SELECT, INSERT, UPDATE, DELETE on all tables in the database
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO Asaeso, memo, ahmed, hadikh, salwa

-- Grant EXECUTE on all stored procedures in the database
GRANT EXECUTE ON SCHEMA::dbo TO Asaeso, memo, ahmed, hadikh, salwa

-- Grant VIEW DEFINITION permission on all views in the database
GRANT VIEW DEFINITION ON SCHEMA::dbo TO Asaeso, memo, ahmed, hadikh, salwa
