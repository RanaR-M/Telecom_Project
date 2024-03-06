-- Get # customers by gender

CREATE VIEW countGenderCustomer
AS

	SELECT
	COUNT(Customer_ID) '# customer'
	, Gender
	FROM
	Customer
	GROUP BY Gender

-- get revenue lost by customer churned

GO
CREATE VIEW TotalRevenueLossChurn
AS
	SELECT
	CHCust.Customer_ID,
	SUM(Cust.) -- Revenue??
	FROM
	Churn_Customer CHCust
	LEFT JOIN Customer Cust
	ON CHCust.Customer_ID = Cust.Customer_ID


-- get avg charge by servie type
GO
CREATE VIEW AVGChargeService
AS
	SELECT
	AVG(MonthlyCharges) 'AVG Monthly Charges',
	ServiceType
	FROM
	CustomerInternet CustInt
	LEFT JOIN InternetService Int
	ON Int.InternetServiceID = CustInt.InternetServiceID
	GROUP BY ServiceType