---TRIGGERS 
--- if churn score >80 send offers
select * from [dbo].[Offers]
GO
CREATE OR ALTER TRIGGER trg_offers_churnnn
ON [Customer]
AFTER INSERT
AS
BEGIN
    DECLARE @Customer_ID int 
    DECLARE @Offer_ID int = 3
	DECLARE @churn_score INT
    
    SELECT @Customer_ID = Customer_ID, @churn_score = Churn_Score
    FROM inserted;
    IF (@churn_score >= 80)
    BEGIN
        INSERT INTO [Taking Offers] ([Customer_ID],[Offer_ID]) 
        VALUES (@Customer_ID, @Offer_ID);
		PRINT('Double the usual data allowance for the same price ')
    END
END

 
GO
--if cltv 40000 send offers  
select * from Offers
GO
create or alter trigger trg_offers_cltv
on [Customer]
AFTER INSERT
AS
BEGIN
    DECLARE @Customer_ID int 
	DECLARE @CLTV INT
    
    SELECT @Customer_ID = Customer_ID, @CLTV = CLTV
    FROM inserted;
    IF (@CLTV >= 4000)
    BEGIN
		    INSERT INTO [Taking Offers] 
			SELECT o.Offer_ID, i.Customer_ID
			FROM inserted i
			CROSS JOIN Offers o
			WHERE i.CLTV >= 4000 and o.Offer_ID =1
			print('25% discount when paying three months in one transaction')
    END
END
---- usage prcnt (calc column) usage/quota * 100
ALTER TABLE CustomerInternet ADD usage_prct FLOAT --created done 
GO
 CREATE or ALTER TRIGGER trg_UsagePct
ON CustomerInternet
AFTER INSERT, UPDATE
AS
BEGIN 
    DECLARE @CUST_ID int
	DECLARE @Inter_serv int, @inter_usage INT 
    
    SELECT @CUST_ID = [CustomerID], @Inter_serv = [InternetServiceID], @inter_usage = [InternetUsage]
    FROM INSERTED

    UPDATE CustomerInternet
    SET usage_prct = CONVERT(FLOAT, @inter_usage) / i.Quota * 100
    FROM CustomerInternet ci
    INNER JOIN InternetService i ON ci.InternetServiceID = i.InternetServiceID
    WHERE i.Quota > 0 
      AND ci.CustomerID = @CUST_ID
END

go
 
--- if usage prcnt in |(50-75-100) then notification
CREATE or ALTER TRIGGER trg_UsageNoti
ON [CustomerInternet]
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @usageprcnt FLOAT
    DECLARE @CustomerID INT

    SELECT @usageprcnt = [usage_prct], @CustomerID = CustomerID
    FROM INSERTED

    IF @usageprcnt = 50
        INSERT INTO Receiving_Notification VALUES (3, @CustomerID)

    IF @usageprcnt = 75
        INSERT INTO Receiving_Notification VALUES (4, @CustomerID)

    IF @usageprcnt = 100
        INSERT INTO Receiving_Notification VALUES (5, @CustomerID)
END

------------------- ERROR ------
--- if monthly GB download larger than 50 then send offer
select * from Offers
go
CREATE OR ALTER TRIGGER trg_MonthlyGBOffer
ON [CustomerInternet]
AFTER INSERT,UPDATE
AS
BEGIN
	declare @customer_id int = (select [CustomerID] from inserted)
	DECLARE @GBdownload int = (SELECT [MonthlyGBDownload] FROM inserted)
	IF @GBdownload > 50
		INSERT INTO [Taking Offers] VALUES (4,@customer_id)
END
 

-----------ERROR------------------
 go
--- if TotalExTraData Not Equal  0 then send Offer 
CREATE or alter TRIGGER trg_TotalExtraDataOffer
ON [CustomerInternet]
AFTER INSERT, UPDATE
AS
BEGIN
	declare @customer_id int = (select [CustomerID] from inserted)
	IF ((SELECT TotalExtraDataCharges FROM inserted) <> 50)
		INSERT INTO [Taking Offers] 
		VALUES
		(5,@customer_id)
END