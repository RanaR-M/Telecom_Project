use [Telcom]
---Ahmed----

CREATE TABLE [Aquisition_Channel] (
[Channel_ID] int PRIMARY KEY,
[Channel_Name] varchar(50) NOT NULL
)
GO

CREATE TABLE [Customer] (
  [Customer_ID] int PRIMARY KEY,
  [Status] varchar(30),
  [Churn_Score] int,
  [No_of_Dependent] int not null,
  [FName] varchar(50),
  [LName] varchar(50),
  [DOB] Date not null,
  [Email] varchar(Max),
  [CLTV] int not null,
  [Has_Dependent] bit not null,
  [Has_Referrals] bit not null,
  [No_of_Referrals] int not null,
  Channel_ID INT ,
	CONSTRAINT customer_aqu FOREIGN KEY (Channel_ID) REFERENCES Aquisition_Channel (Channel_ID),
	CONSTRAINT Email_Check Check (Email LIKE '%[a-zA-Z0-9_\-]+@([a-zA-Z0-9_\-]+\.) + (com|org|edu|nz|au])%'),
	CONSTRAINT Status_Check Check ([Status] in ('Stayed','Joined','Churned'))
)
GO
 
CREATE TABLE Churn_Customer(
  [Outer_ID] int PRIMARY KEY IDENTITY(1,1),
  [Customer_ID] int,
  [Feedback] varchar(Max),
  [Tenure_in_Month] int,
  [Churn_Date] date not null
 
  CONSTRAINT [Outer_Customer] FOREIGN KEY ([Customer_ID]) REFERENCES [Customer] ([Customer_ID])
)
GO


CREATE TABLE [New_Comer] (
  [Enter_ID] int PRIMARY KEY IDENTITY(1,1),
  [Customer_ID] int,
  [Acquisition_Channel_ID] int,
  [Contract_Type] varchar(30),
  [Acquisition_Date] Date
 
  CONSTRAINT [Enter_Customer] FOREIGN KEY ([Customer_ID]) REFERENCES [Customer] ([Customer_ID]),
  CONSTRAINT [Enter_Aquisition_Channel] FOREIGN KEY ([Acquisition_Channel_ID]) REFERENCES [Aquisition_Channel] ([Channel_ID])
)
GO
 

 
----- isra -----
--notification 
CREATE TABLE [Notification] (
    Notification_ID INT PRIMARY KEY,
    Notification_Text VARCHAR(255) NOT NULL
)
-- receiving notifications
CREATE TABLE Receiving_Notification (
    Notification_ID INT,
    Customer_ID INT,
    PRIMARY KEY (Notification_ID, Customer_ID),
    CONSTRAINT Customer_Notification FOREIGN KEY (Notification_ID) REFERENCES [Notification] (Notification_ID),
    CONSTRAINT Customer_Recieve_Notification FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID)
)

----- Rana ------

-- Internet service
CREATE TABLE InternetService
(
	InternetServiceID INT primary key identity(1,1),
	StreamingTV BIT DEFAULT 0,
	StreamingMovies BIT DEFAULT 0,
	OnlineSecurity BIT DEFAULT 0,
	ServiceType varchar(30) NOT NULL,
	OnlineBackup BIT DEFAULT 0,
	Quota INT NOT NULL,
	DeviceProtection BIT DEFAULT 0,
	CustomerID INT,
	CONSTRAINT InternetCustomer FOREIGN KEY (CustomerID) REFERENCES Customer(Customer_ID)
)

-- customer Internet
CREATE TABLE CustomerInternet
(
	CustomerID INT,
	InternetServiceID INT,
	PRIMARY KEY(CustomerID, InternetServiceID),
	TotalLongDistanceCharges FLOAT,
	MonthlyCharges FLOAT,
	MonthlyGBDownload INT,
	InternetUsage INT,
	TotalCharges FLOAT,
	TotalRefunds FLOAT DEFAULT 0, 
	TotalExtraDataCharges INT DEFAULT 0,
	CONSTRAINT customerIDInternet FOREIGN KEY (CustomerID) REFERENCES Customer(Customer_ID),
	CONSTRAINT InternetID FOREIGN KEY (InternetServiceID) REFERENCES InternetService(InternetServiceID)
)

-- churn category

CREATE TABLE ChurnCategory
(
	ChurnCategoryID INT primary key identity(1,1),
	CategoryName VARCHAR(100)
)

---Marwa----

CREATE TABLE [Location] (
  [Location_ID] int PRIMARY KEY,
  [Customer_ID] int ,
  [City] varchar(50),
  [Country] varchar(50),
  [State] varchar(50),
  [Longitude] varchar(MAX),
  [Latitude] varchar(MAX),
  CONSTRAINT customerLocation FOREIGN KEY (Customer_ID) REFERENCES [Customer] ([Customer_ID])
);

CREATE TABLE [Payment_Method] (
  [Payment_Method_ID] int PRIMARY KEY,
  [Payment_Type] varchar(30)
);

CREATE TABLE [Customer_Paying] (
  [Customer_ID] int ,
  [Payment_ID] int ,
  CONSTRAINT customerpayingid FOREIGN KEY (Customer_ID) REFERENCES [Customer] ([Customer_ID]),
  CONSTRAINT paymentCustomer FOREIGN KEY (Payment_ID) REFERENCES [Payment_Method] ([Payment_Method_ID])
);

CREATE TABLE [Population] (
   [Zip_Code] varchar(5) PRIMARY KEY,
   [Population_size] int,
   [Location_ID] int,
   CONSTRAINT populationlocation FOREIGN KEY (Location_ID) REFERENCES [Location] ([Location_ID])
);

---- hadi------

CREATE TABLE [Agent] (
  [Agent_id] int PRIMARY KEY,
  [HANDLING_TIME] decimal 
);

CREATE TABLE [Call_Customer_Agent] (
  [Call_id] int PRIMARY KEY,
  [customer_id] int,
  [agent_id] int,
  [answered] bit,
  [call_time] time,
  [call_date] date,
  [end_call_time] time,
  [satisfaction_rating] int,
  [resolution_status] bit,
  [topic] varchar(30),
  [speed_of_answer] int,
  FOREIGN KEY ([customer_id]) REFERENCES [Customer] ([Customer_ID]),
  FOREIGN KEY ([agent_id]) REFERENCES [Agent] ([Agent_id])
);

CREATE TABLE [Phone_Service] (
  [phone_service_ID] int PRIMARY KEY,
  [Customer_ID] int,
  [service_type] varchar(30),
  [multiple_lines] bit,
  FOREIGN KEY ([Customer_ID]) REFERENCES [Customer] ([Customer_ID])
);

---- Salwa -----

CREATE TABLE [Churn Reason] 
(Reason_ID INT PRIMARY KEY,
Reason_Description VARCHAR(200),
Churn_Category_ID INT,
Churned_ID INT,
CONSTRAINT ChurncategoryFK FOREIGN KEY
([Churn_Category_ID]) REFERENCES ChurnCategory ([ChurnCategoryID]),
CONSTRAINT Churnedcustomer FOREIGN KEY
([Churned_ID]) REFERENCES Churn_Customer ([Outer_ID])
)
GO
 
CREATE TABLE Offers
(
Offer_ID INT PRIMARY KEY,
Service_Type VARCHAR(50) NOT NULL,
Offer_Label VARCHAR(50),
[Start_Date] DATETIME NOT NULL,
[End_Date] DATETIME NOT NULL
)


CREATE TABLE [Taking Offers]
(Offer_ID INT,
Customer_ID INT,
PRIMARY KEY(Offer_ID,Customer_ID),
CONSTRAINT Offer_id
FOREIGN KEY ([Offer_ID]) REFERENCES [Offers] ([Offer_ID]),
CONSTRAINT Customer_ID FOREIGN KEY
(Customer_ID) REFERENCES [Customer] ([Customer_ID])
)
GO
