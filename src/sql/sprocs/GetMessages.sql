if exists (select * from sysobjects 
where id = object_id('dbo.GetMessages') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetMessages.'
      drop procedure dbo.GetMessages
   END
GO
PRINT '.. Creating sproc GetMessages.'
GO
CREATE PROCEDURE GetMessages
	 @pRecipientID BIGINT
	 ,@pUnReadOnly BIT
	 ,@pSchoolYear SMALLINT
AS
SET NOCOUNT ON 

SELECT h.*
  FROM dbo.vMessageHeader h
  WHERE h.RecipientID=@pRecipientID
    AND h.SchoolYear=@pSchoolYear
    AND (@pUnReadOnly=0 OR IsRead=0)
    AND h.[Deleted]=0
  ORDER BY h.SendTime DESC

GO




