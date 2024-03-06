-- # customers per city
CREATE PROC PROC_NumOf_Customers_Per_City (@City varchar(50))
AS
BEGIN
	SELECT @City, COUNT(C.Customer_ID)
	FROM Customer C join [Location] L
	ON C.Customer_ID = L.Customer_ID
	WHERE L.City = @City
	GROUP BY L.City
END
GO

CREATE PROC PROC_ChurnCustomers_Per_City (@City varchar(50))
AS
BEGIN
	SELECT @city AS City, COUNT(CC.Customer_ID) AS ChurnCount
	FROM Churn_Customer CC
	JOIN [Location] L ON CC.Customer_ID = L.Customer_ID
	WHERE L.City = @City
	GROUP BY City;
END
GO

-- # Churn Customers Per Churn Reason Category
CREATE PROC PROC_ChurnCustomers_Per_Category (@Category varchar(100))
AS
BEGIN
	SELECT @Category, COUNT(CC.Customer_ID)
	FROM Churn_Customer CC join [Churn Reason] CR
	ON CC.Customer_ID = CR.Churned_ID join ChurnCategory C
	ON CR.Churn_Category_ID = C.ChurnCategoryID
	WHERE C.CategoryName = @Category
	GROUP BY C.CategoryName
END
GO

-- # Customers Per Aqisition Channle
CREATE PROC PROC_Customers_Per_Aquisition_Channel (@Channel varchar(50))
AS
BEGIN
	SELECT @Channel, COUNT(Customer_ID)
	FROM Aquisition_Channel AC join customer C
	ON AC.Channel_ID = C.Channel_ID
	WHERE AC.Channel_Name = @Channel
	GROUP BY AC.Channel_Name
END
GO

-- top 5 Reasons Causing Churn
CREATE PROC PROC_Top5_Churn_Reasons
AS
BEGIN
	SELECT TOP 5 CR.Reason_Description ,COUNT(CC.Customer_ID)
	FROM Churn_Customer CC join [Churn Reason] CR
	ON CC.Customer_ID = CR.Churned_ID
	GROUP BY CR.Reason_Description
	ORDER BY 2 DESC
END
GO
-- 

-- form for the churned customer
CREATE OR ALTER PROC Churned_Customer_Form (@Customer_ID int, @Feedback varchar(max), @Tenure int, @Churn_Date date, @Reason varchar(max))
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

-- Test
Execute Churned_Customer_Form 1,'this',5,'1-1-2015','Attitude of support person'