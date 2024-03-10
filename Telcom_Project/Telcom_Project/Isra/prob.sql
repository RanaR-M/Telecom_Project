--select * from [dbo].[Churn Reason]

--select * from [dbo].[New_Comer]
--select * from [dbo].[Customer]
--de feha moshka hugeb acq date w churn date mneen?
GO
create or alter proc insert_TEANURE_IN_MONTHS @Custmer_Id int 
AS
BEGIN
	SELECT DATEDIFF(MONTH, n.[Acquisition_Date], c.[churn_Date]) AS [Tenure_in_Month]
	from New_Comer n join churn_customer c on n.[Customer_ID] = c.[Customer_ID]
END

insert into churn_customer ([Tenure_in_Month])
exec insert_TEANURE_IN_MONTHS @Custmer_Id=;
----e insert into customer hysm3 f new commer <hn  el acq date hwa get dat>
/*
GO
CREATE or alter TRIGGER trg_NewcomerCustomer
ON [Customer]
AFTER INSERT
AS
BEGIN
    INSERT INTO [New_Comer] ([Customer_ID],  [Acquisition_Date])
    SELECT [Customer_ID], GETDATE()
    FROM inserted
	where status = 'joined'
END
*/

--insert into Customer values (7044,'Joined',0,1,0,1,0,0,1,'Male',22,0)
--insert into Customer values (7045,'Joined',0,1,0,1,0,0,1,'Male',23,0)
--select * from [dbo].[New_Comer]
---hna insert f customer hysm3 f churn <Tenure_in_Month= get date as churn - acq date>

/*
GO
CREATE or alter Trigger trg_outer_tenure
ON [Customer]
AFTER INSERT
AS
BEGIN
    INSERT INTO [dbo].[Churn_Customer] ([Customer_ID], [Tenure_in_Month], [Churn_Date])
    SELECT 
        c.[Customer_ID],
        DATEDIFF(MONTH, nc.[Acquisition_Date], GETDATE()) AS [Tenure_in_Month],
        GETDATE() AS [Churn_Date]
    FROM 
        [dbo].[New_Comer] nc
    INNER JOIN 
        inserted c ON nc.[Customer_ID] = c.[Customer_ID]
      where status = 'churned'
END
*/
-- insert into Customer values (7046,'churned',0,1,0,1,0,0,1,'Male',23,0)

-- select * from Churn_Customer

--- if churn score 80> send offers
GO
create or alter trigger trg_offers_churn
ON [Customer]
AFTER INSERT, UPDATE
AS
BEGIN
    INSERT INTO [Taking Offers] 
    SELECT o.Offer_ID, i.Customer_ID
    FROM inserted i
    CROSS JOIN Offers o -- for eno y5ly kol id m3 kol offer da group lw7do 
    WHERE i.Churn_Score >= 80
END

--if cltv 40000 send offers  
GO
create or alter trigger trg_offers_cltv
on [Customer]
AFTER INSERT, UPDATE
AS
BEGIN
    INSERT INTO [Taking Offers] 
    SELECT o.Offer_ID, i.Customer_ID
    FROM inserted i
    CROSS JOIN Offers o
    WHERE i.CLTV >= 4000
END
-- usage prcnt (calc column) usage/quota * 100
ALTER TABLE CustomerInternet ADD usage_prct FLOAT 
---w trg by7sbha 
GO
CREATE TRIGGER trg_UsagePct
ON CustomerInternet
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE ci
    SET ci.usage_prct = CONVERT(FLOAT, ci.InternetUsage) / ci.Quota * 100
    FROM CustomerInternet ci
    INNER JOIN inserted i ON ci.CustomerID = i.CustomerID
    WHERE ci.Quota > 0;
END

--- if usage prcnt in (50,75,90,100) then notif

CREATE or alter TRIGGER trg_Usage%Noti
ON [CustomerInternet]
AFTER INSERT
AS
BEGIN
    INSERT INTO Receiving_Notification
    SELECT
        n.Notification_ID,
        ci.CustomerID
    FROM inserted ci
    CROSS JOIN [Notification] n
    WHERE ci.[usage prcnt] IN (50, 75, 90, 100);
END


--- if monthly GB download larger than 50 then send offer
GO
CREATE TRIGGER trg_MonthlyGBOffer
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
    WHERE ci.[MonthlyGBDownload] > 50
END;

--- if not (streamingTV, StreamingMovies) then send  offer
go
CREATE TRIGGER trg_StreamingOffer
ON [InternetService]
AFTER UPDATE
AS
BEGIN
    INSERT INTO [Taking Offers]
    SELECT
        o.Offer_ID,
        Intser.CustomerID
    FROM [InternetService] Intser
    JOIN Offers o 
	ON Intser.CustomerID = o.Customer_ID
    WHERE is.StreamingTV = 0 OR is.StreamingMovies = 0
END;

--- if TotalExTraData Not Equal  0 then send Offer 
CREATE TRIGGER trg_TotalExtraDataOffer
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
    WHERE ci.TotalExtraDataCharges <> 0
END
-- trigger by audit rana w ahmed w hadi by3mlo eh w homa sawa w bynso y2olo

