                   ---HADY---
--view Acqcithionchanel with #customer
CREATE VIEW Acqcithionchanelwithnumberofcustomer 
AS
SELECT COUNT(c.Channel_ID) AS Number_of_Customers, ac.[Channel_Name]
FROM Customer c
JOIN [Aquisition_Channel] ac ON c.Channel_ID = ac.Channel_ID
GROUP BY ac.[Channel_Name];

--Display Info About Customer For Agent  
CREATE VIEW CustomerInternetInfo AS
SELECT 
    c.[Customer_ID],
    c.[Gender],
    nc.[Contract_Type],
    is.[ServiceType],
    is.[Quota]
FROM 
    Customer c
JOIN 
    [New_Comer] nc ON c.[Customer_ID] = nc.[Customer_ID]
JOIN 
    InternetService is ON c.[Customer_ID] = is.[Customer_ID];
















