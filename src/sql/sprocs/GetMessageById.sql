if exists (select * from sysobjects 
where id = object_id('dbo.GetMessageById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetMessageById.'
      drop procedure dbo.GetMessageById
   END
GO
PRINT '.. Creating sproc GetMessageById.'
GO
CREATE PROCEDURE GetMessageById
	 @pMessageID BIGINT
AS
SET NOCOUNT ON 

SELECT m.*
  FROM dbo.vMessage m
  WHERE m.MessageID=@pMessageID

GO




