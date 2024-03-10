--Hadi--
--calculate duration 
CREATE TRIGGER trgCalculteDuration 
ON [dbo].[Call_Customer_Agent]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE cca
    SET cca.[Duration] = DATEDIFF(minute, i.[call_time], i.[end_call_time])
    FROM [dbo].[Call_Customer_Agent] cca
    INNER JOIN inserted i ON cca.call_id = i.call_id;
END;

GO
--
--SEND OFFERS 
