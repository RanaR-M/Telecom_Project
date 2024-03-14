-- get list of triggers
SELECT name AS 'Trigger Name', OBJECT_DEFINITION(OBJECT_ID) AS 'Trigger Definition'
FROM sys.triggers;


USE Telecom
 
SELECT 
    SPECIFIC_NAME AS 'Procedure Name',
    ROUTINE_DEFINITION AS 'Procedure Definition'
FROM 
    INFORMATION_SCHEMA.ROUTINES
WHERE 
    ROUTINE_TYPE = 'PROCEDURE';


USE Telecom
SELECT 
    name AS 'User Name'
FROM 
    sys.database_principals
WHERE 
    type_desc = 'SQL_USER';


-- 1) Stored Proc

-- insert customer 

EXEC CreateNewcomerForm 
	@No_of_Dependent = 0,
    @age = 27,
    @Has_Dependent = 0,
    @Has_Referrals = 0,
    @No_of_Referrals = 0,
    @ChannelName = 'Social Media',
    @Contract_Type  = 'Month-to-Month',
	@gender = 'Female',
	@married = 0

select * from Customer
-- churn customer form
EXEC Churned_Customer_Form 
@Customer_ID = 999322, @Feedback = 'had problems with connection', 
@Tenure = 9, @Churn_Date = '2024-01-01', @Reason = 'Attitude of support person'


-- # customer in channel
EXEC PROC_Customers_Per_Aquisition_Channel 'Social Media'

-- Top 5 churn reasons with # customers
EXEC PROC_Top5_Churn_Reasons

-- # calls per topic
EXEC GetCountCallsALLTopic

-- get risk level for customer
EXEC GetRiskLevelCustomer_Proc 119

-- # calls resolved for agent
EXEC GetResolved 5010

-- success rate for calls for agent
EXEC Agent_Success 5010

-- select all customers (status, churn score, no dependents, no referals, channel name)
EXEC SelectAllCustomers

-- select customer by status (status, churn score, no dependents, CLTV, has dependents,
-- has referals, no referals, channel id, gender, age, married, contract type)
EXEC SelectCustomersByChurnStatus 'Churned'

-- select chrun customer (tenure in month, churn date, reason description)
EXEC DisplayChurnCustomerWithReason


-- # customers in city
EXEC PROC_NumOf_Customers_Per_City 'los angeles'

-- # churned customers in city
EXEC PROC_ChurnCustomers_Per_City 'los angeles'

-- #churned customers in churn category
EXEC PROC_ChurnCustomers_Per_Category 1


-- # customers per payment method
EXEC ViewCustomerInfoPayment_Proc

-- get services for customer
EXEC GetServiceCustomer 119

-- get # calls in topic
EXEC GetCountCallsTopic 'Contract related'


-- get all data for customer 
EXEC GetCustomer 119

-- customer in location id
EXEC GetCustomer_loc 14087

-- get customers where cltv is bigger than 4000
EXEC HighValueCustomers

-- get number of calls handled for agent
EXEC CallsHandledByAgent @AgentID = 5009

-- ADD OFFER TO CUSTOMER
EXEC TAKING_OFFER 1, 119
SELECT * FROM [Taking Offers]


-- get customer info from all tables for services
EXEC GET_CUSTOMER_INFO 119 

-------------
-- 2) views

-- # customers with acqchannel
select * from Acqcithionchanelwithnumberofcustomer

-- get customer with gender, contract, internet service type, quota
select * from CustomerInternetInfo

-- get total revenue by status
SELECT * FROM TotalRevenueStatus

-- # customers by gender
SELECT * FROM countGenderCustomer

-- revenue lost by churned customer
SELECT * FROM TotalRevenueLossChurn

-- avg monthly charge by internet service type
SELECT * FROM AVGChargeService

-- # customers per city
SELECT * FROM V_Number_Of_Customers_Per_City

-- data of agent (name, no of calls, no of resolved, avg satisfaction)
SELECT * FROM V_#CallsAnswered_AndSatisfactionRate_PerCustomer

-- total revenue per city
SELECT * FROM V_Total_Revenue_Per_City

-- agent (avg handeling time, total calls handled, total answered calls, avg satisfaction, avg speed)
SELECT * FROM vw_AgentPerformance

-- satisfaction per customer
SELECT * FROM vw_CustomerSatisfaction

-- total calls handled per agent
SELECT * FROM vw_TopPerformingAgents

-- avg monthly charge per service
SELECT * FROM vw_AvgMonthlyCharge

-- age group of customers and status
SELECT * FROM vw_CustByAgeGroup



-- 3) TRIGGERS

-- trg_offers_churnnn (churn score > 80)

DECLARE @customer_id INT = (SELECT max([Customer_ID]) from [dbo].[Customer]) + 1
print(@customer_id)
INSERT INTO Customer 
([Customer_ID], [No_of_Dependent], 
[CLTV], [Has_Dependent], [Has_Referrals], [No_of_Referrals], [Gender], [Age], [Married], [Churn_Score])
VALUES
(
	@customer_id,
	0,
	0,
	0,
	0,
	0,
	'Female',
	23,
	0,
	90
)

select * from [Taking Offers] where [Customer_ID] = @customer_id


-- trg_offers_cltv (cltv > 4000)


DECLARE @customer_id_1 INT = (SELECT max([Customer_ID]) from [dbo].[Customer]) + 1
print(@customer_id_1)
-- 999320
INSERT INTO Customer 
([Customer_ID], [No_of_Dependent], 
[CLTV], [Has_Dependent], [Has_Referrals], [No_of_Referrals], [Gender], [Age], [Married])
VALUES
(
	@customer_id_1,
	0,
	5000,
	0,
	0,
	0,
	'Female',
	23,
	0
)

select * from [Taking Offers] where [Customer_ID] = @customer_id_1

-- trg_UsagePct
-- usage / quota * 100
select * from CustomerInternet
where usage_prct is not null

-- trg_UsageNoti
select * from CustomerInternet
where usage_prct is not null

update [dbo].[CustomerInternet]
set [usage_prct] = 75
where [CustomerID] = 8215

select * from [dbo].[Receiving_Notification]

