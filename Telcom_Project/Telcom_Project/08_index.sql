
-- Create non-clustered index on InternetService table
CREATE INDEX idx_InternetService ON InternetService
(InternetServiceID, ServiceType, Quota);

-- Create non-clustered index on Location table
CREATE INDEX idx_location ON [Location]
(City, [Customer_ID]);

-- Create non-clustered index on Payment_Method table
CREATE INDEX idx_Payment_Type ON [Payment_Method]
([Payment_Type]);

-- Create non-clustered index on Agent table
CREATE INDEX idx_Name ON [Agent]
([Name]);

-- Create non-clustered index on Call_Customer_Agent table
CREATE INDEX idx_Call_Customer_Agent ON Call_Customer_Agent
(Call_id, answered, Duration, satisfaction_rating);