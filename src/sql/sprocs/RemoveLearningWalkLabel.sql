if exists (select * from sysobjects 
where id = object_id('dbo.RemoveLearningWalkLabel') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc RemoveLearningWalkLabel.'
      drop procedure dbo.RemoveLearningWalkLabel
   END
GO
PRINT '.. Creating sproc RemoveLearningWalkLabel.'
GO
CREATE PROCEDURE RemoveLearningWalkLabel
	 @pLabelID BIGINT
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT
	   ,@sql_error_message		   VARCHAR(200)


---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION

DELETE dbo.SELearningWalkClassroomLabelRelationship
 WHERE LabelID=@pLabelID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SELearningWalkClassroomLabelRelationship  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DELETE dbo.SELearningWalkClassroomLabel
 WHERE LabelID=@pLabelID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not delete to SELearningWalkClassroomLabel  failed. In: ' 
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
      ROLLBACK TRANSACTION
      RAISERROR(@sql_error_message, 15, 10)
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END


GO


