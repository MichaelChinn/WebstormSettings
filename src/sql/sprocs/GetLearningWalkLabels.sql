if exists (select * from sysobjects 
where id = object_id('dbo.GetLearningWalkLabels') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetLearningWalkLabels.'
      drop procedure dbo.GetLearningWalkLabels
   END
GO
PRINT '.. Creating sproc GetLearningWalkLabels.'
GO
CREATE PROCEDURE GetLearningWalkLabels
		@pPracticeSessionID BIGINT
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT
       ,@sql_error_message   	NVARCHAR(500)


---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)


SELECT LabelID
      ,Label
 FROM SELearningWalkClassroomLabel
WHERE PracticeSessionID=@pPracticeSessionID
ORDER BY Label ASC

SELECT @sql_error = @@ERROR 
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SELearningWalkClassRoomIDRelationship failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      RAISERROR(@sql_error_message, 15, 10)
   END

GO


