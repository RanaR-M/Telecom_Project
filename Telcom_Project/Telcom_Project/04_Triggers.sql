---TRIGGERS 
--- if churn score >80 send offers
select * from [dbo].[Offers]
GO
create or alter trigger trg_offers_churnnn
ON [Customer]
AFTER INSERT
AS
BEGIN
	DECLARE @Customer_ID int 
	DECLARE @Offer_ID int = 3
 
    
    SELECT @Customer_ID = i.Customer_ID 
    FROM inserted i
    WHERE i.Churn_Score >= 80
	INSERT INTO [Taking Offers] ([Customer_ID],[Offer_ID])
	VALUES (@Customer_ID,@Offer_ID)
    select 'Double the usual data allowance for the same price ' AS Offer
END
 
 
--if cltv 40000 send offers  
select * from Offers
GO
create or alter trigger trg_offers_cltv
on [Customer]
AFTER INSERT
AS
BEGIN
    INSERT INTO [Taking Offers] 
    SELECT o.Offer_ID, i.Customer_ID
    FROM inserted i
    CROSS JOIN Offers o
    WHERE i.CLTV >= 4000 and o.Offer_ID =1
	select '25% discount when paying three months in one transaction' AS Offer
END
---- usage prcnt (calc column) usage/quota * 100
ALTER TABLE CustomerInternet ADD usage_prct FLOAT --created done 
---w trg by7sbha 
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

--- if monthly GB download larger than 50 then send offer
select * from Offers
CREATE OR ALTER TRIGGER trg_MonthlyGBOffer
ON [CustomerInternet]
AFTER INSERT,UPDATE
AS
BEGIN
    INSERT INTO [Taking Offers] 
    SELECT
        o.Offer_ID,
        ci.CustomerID
    FROM inserted ci
    CROSS JOIN Offers o
    WHERE ci.[MonthlyGBDownload] > 50 and offer_id = 4
END
 

 
--- if TotalExTraData Not Equal  0 then send Offer 
CREATE or alter TRIGGER trg_TotalExtraDataOffer
ON [CustomerInternet]
AFTER INSERT
AS
BEGIN
    INSERT INTO [Taking Offers] 
    SELECT
        o.Offer_ID,
        ci.CustomerID
    FROM inserted ci
    CROSS JOIN Offers o
    WHERE ci.TotalExtraDataCharges <> 0 and Offer_ID=5
END