IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetTrainingProtocolJournalEntries') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetTrainingProtocolJournalEntries.'
      DROP PROCEDURE dbo.GetTrainingProtocolJournalEntries
   END
GO
PRINT '.. Creating sproc GetTrainingProtocolJournalEntries.'
GO

CREATE PROCEDURE dbo.GetTrainingProtocolJournalEntries
   @pProtocolID BIGINT
   ,@pUserID BIGINT
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vTrainingProtocolJournalEntry
 WHERE TrainingProtocolID=@pProtocolID
   AND UserID=@pUserID
 ORDER BY TrainingProtocolJournalEntryID DESC
  
  
