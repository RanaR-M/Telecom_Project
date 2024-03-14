---QA 

                --create login for QA

use [master]
CREATE LOGIN QA WITH PASSWORD = '123456', 
CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF



               -- user associated with the login
CREATE USER QAUser FOR LOGIN QA

               -- Grant  on specified views 
USE Telecom
GRANT SELECT ON dbo.vw_AgentPerformance TO QAUser
GRANT SELECT ON dbo.V_#CallsAnswered_AndSatisfactionRate_PerCustomer TO QAUser
GRANT SELECT ON dbo.vw_CustomerSatisfaction TO QAUser
GRANT SELECT ON dbo.vw_TopPerformingAgents TO QAUser
GRANT SELECT ON dbo.vw_CustByAgeGroup TO QAUser

-- create proc to display welcome message and Views that QA allow to Query 
USE Telecom
CREATE OR ALTER PROCEDURE HI_QA
AS
BEGIN
    PRINT 'Welcome, QA Team!';
    PRINT 'Feel free to query the allowed views and gather valuable insights.';
END


--grant excute proc 
use Telecom
 GRANT EXECUTE ON dbo.HI_QA TO QAUser


