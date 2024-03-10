---Notification
INSERT INTO notification (Notification_Text) VALUES
('Welcome to our telecom service!'),
('Special offer: Upgrade your plan and get additional data.'),
('Important announcement: Service maintenance scheduled.'),
('New feature alert: Faster data speeds now available.'),
('Reminder: Pay your bill by the end of the month.'),
('Usage alert: You have consumed 50% of your data quota.'),
('Usage alert: You have consumed 75% of your data quota.'),
('Usage alert: You have consumed 100% of your data quota. Renew your plan for continued service.');
--select * from Notification

-- salwa
EXECUTE insertoffer '25% discount when paying three months in one transaction','2024-06-12 12:00:00','2024-09-30 12:00:00'
EXECUTE insertoffer 'An extended trial period with no commitment required to know about the improvements since you left','2018-06-12 12:00:00','2024-03-30 12:00:00'
EXECUTE insertoffer 'Double the usual data allowance for the same price ','2024-07-01 12:00:00','2024-07-12 12:00:00'
EXECUTE insertoffer 'A free speed upgrade','2024-06-12 10:34:09','2024-12-01 12:00:00'
EXECUTE insertoffer ' Provide free installation and setup services for customers returning to the network','2024-03-12 10:34:09','2025-03-15 12:00:00'

-- rana
INSERT 
INTO [dbo].[Payment_Method]
VALUES
('Bank Withdrawal'),
('Mailed Check'),
('Credit Card')

INSERT INTO [dbo].[Agent] (Name,[HANDLING_TIME] )
VALUES
    ('Diane', 57),
    ('Becky', 52),
    ('Stewart', 24),
    ('Greg', 28),
    ('Jim', 39),
    ('Joe', 3),
    ('Martha', 25),
    ('Dan', 30);













	