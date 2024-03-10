CREATE  TABLE DIM_CHURN_REASON (
    CHURN_REASON_SK INT IDENTITY(1,1) PRIMARY KEY,
    REASON_ID_BK INT NOT NULL,
    CATEGORY_ID_BK INT NOT NULL,
    REASON_DESCRIPTION VARCHAR(200),
    CATEGORY_NAME VARCHAR(100),
    START_DATE DATETIME NULL,
    END_DATE DATETIME NULL,
    IS_CURRENT INT NULL
);
 
CREATE TABLE DIM_PAYMENT_METHOD (
    PAYMENT_METHOD_ID_SK INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    PAYMENT_METHOD_ID INT,
    PAYMENT_METHOD_NAME VARCHAR(30),
    START_DATE DATETIME NULL,
    END_DATE DATETIME NULL,
    IS_CURRENT INT NULL
)

CREATE TABLE DIM_CUSTOMER (
    CUSTOMER_SK INT IDENTITY(1,1) PRIMARY KEY,
    CUSTOMER_ID_BK INT NOT NULL,
    CHANNEL_ID_BK INT NOT NULL,
    SK_CHURN_REASON_FK INT NOT NULL,
    SK_PAYMENT_METHOD_ID_FK INT NOT NULL,
    STATUS VARCHAR(30),
    CHURN_SCORE INT,
    NO_OF_DEPENDANT INT,
    CLTV INT,
    HASDEP BIT,
    HAS_REF BIT,
    NO_OF_REFE BIT,
    ACQ_CHANNEL_ID INT,
    ACQ_CHANNEL_NAME VARCHAR(50),
    GENDER VARCHAR(20),
    AGE INT,
    MARRIED BIT,
    FEEDBACK VARCHAR(MAX),
    TENURE_IN_MONTHS INT,
    CONTRACT VARCHAR(30),
    START_DATE DATETIME NULL,
    END_DATE DATETIME NULL,
    IS_CURRENT INT NULL,
    CONSTRAINT FK_CHURN_REASON FOREIGN KEY (SK_CHURN_REASON_FK) REFERENCES DIM_CHURN_REASON(CHURN_REASON_SK),
    CONSTRAINT FK_PAYMENT_METHOD FOREIGN KEY (SK_PAYMENT_METHOD_ID_FK) REFERENCES DIM_PAYMENT_METHOD(PAYMENT_METHOD_ID_SK)
);
 
CREATE TABLE DIM_NOTIFICATION
(
	NOTIFICATION_SK INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	NOTIFICATION_ID_BK INT NOT NULL,
	NOTIFICATION_TEXT VARCHAR(255)
)
 
CREATE TABLE DIM_LOCATION (
    LOCATION_ID_SK INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
    LOCATION_ID_BK INT NOT NULL,
    CITY VARCHAR(50),
    COUNTRY VARCHAR(50),
    STATE VARCHAR(50),
    LONG VARCHAR(MAX),
    LAT VARCHAR(MAX),
    ZIP_CODE_BK INT,
    POPULATION_SIZE INT,
    START_DATE DATETIME NULL,
    END_DATE DATETIME NULL,
    IS_CURRENT INT NULL
);
 
CREATE TABLE DIM_SERVICES (
    SERVICESID_SK INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    INTERNET_SERVICES_ID_BK INT NOT NULL,
    CUSTOMER_INTERNET_BK INT NOT NULL,
    STREAMING_TV BIT,
    STREAMING_MOVIES BIT,
    ONLINE_SECURITY BIT,
    ONLINE_BACKUP BIT,
    DEVICE_PRODUCAITN BIT,
    STREAMING_MUSIC BIT,
    PERIEMUM_TAKE_SUPPORT BIT,
    UNLIMMITED_DATA BIT,
    SERVICE_INTERNET_TYPE NVARCHAR(255),
    PHONE_SERVICE_BK INT,
    MULTI_LINE BIT,
    START_DATE DATETIME NULL,
    END_DATE DATETIME NULL,
    IS_CURRENT INT NULL
);
 
CREATE TABLE DIM_OFFERS (
    OFFERS_SK INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    OFFERS_BK INT NOT NULL,
    OFFERS_LABEL VARCHAR(200),
    START_DATE DATETIME NULL,
    END_DATE DATETIME NULL,
    IS_CURRENT INT NULL
);
 
CREATE TABLE FACT_CUSTOMER_EXPENSES_AND_REVENUE (
    FACT_CUSTOMER_SK INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    FK_OFFERS_SK INT,
    FK_NOTIFICATION_SK INT,
    FK_SERVICESID_SK INT,
    FK_LOCATION_ID_SK INT,
    FK_CUSTOMER_SK INT,
    TOTAL_LONG_DESTINCE_CHARGES FLOAT,
    MONTHLY_CHARGES FLOAT,
    MONTHLY_GB INT,
    INTERNET_USAGE INT,
    TOTAL_CHARGES FLOAT,
    TOTAL_REFAND FLOAT,
    TOTAL_EXTRA_DATA_CHARGES INT,
    QUOTA INT,
    START_DATE DATETIME NULL,
    END_DATE DATETIME NULL,
    IS_CURRENT INT NULL,
    CONSTRAINT FK_OFFERS FOREIGN KEY (FK_OFFERS_SK) REFERENCES DIM_OFFERS(OFFERS_SK),
    CONSTRAINT FK_SERVICES FOREIGN KEY (FK_SERVICESID_SK) REFERENCES DIM_SERVICES(SERVICESID_SK),
    CONSTRAINT FK_LOCATION FOREIGN KEY (FK_LOCATION_ID_SK) REFERENCES DIM_LOCATION(LOCATION_ID_SK),
    CONSTRAINT FK_CUSTOMER FOREIGN KEY (FK_CUSTOMER_SK) REFERENCES DIM_CUSTOMER(CUSTOMER_SK)
);
 
CREATE TABLE DIM_AGENT (
    AGENT_SK INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    AGENT_BK INT NOT NULL,
    NAME NVARCHAR(50),
    START_DATE DATETIME NULL,
    END_DATE DATETIME NULL,
    IS_CURRENT INT NULL
);
 
CREATE TABLE DIM_CALL_DETAILS (
    CALLDETAILS_SK INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    CALLDETAILS_BK INT NOT NULL,
    ANSWERED BIT,
    CALLTIME TIME(7),
    CALLDATE DATE,
    ENDCALLTIME TIME(7),
    RESALUATION_STATUES BIT,
    SPEAD_OF_ANSWER INT,
    DURATION INT,
    START_DATE DATETIME NULL,
    END_DATE DATETIME NULL,
    IS_CURRENT INT NULL
);
 
CREATE TABLE FACT_CALL (
    CALL_SK INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
	FK_CUSTOMER_SK INT,
    FK_CALLDETAILS_SK INT NOT NULL,
    FK_AGENT_SK INT,
    HANDLING_TIME DECIMAL(18,0),
    SATISIFACTION_RATE INT,
    START_DATE DATETIME NULL,
    END_DATE DATETIME NULL,
    IS_CURRENT INT NULL,
	CONSTRAINT FK_CUSTOMER_call FOREIGN KEY (FK_CUSTOMER_SK) REFERENCES DIM_CUSTOMER(CUSTOMER_SK),
    CONSTRAINT FK_CALL_DETAILS FOREIGN KEY (FK_CALLDETAILS_SK) REFERENCES DIM_CALL_DETAILS(CALLDETAILS_SK),
    CONSTRAINT FK_AGENT FOREIGN KEY (FK_AGENT_SK) REFERENCES DIM_AGENT(AGENT_SK)
);

