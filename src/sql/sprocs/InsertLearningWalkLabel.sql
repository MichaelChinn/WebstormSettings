if exists (select * from sysobjects 
where id = object_id('dbo.InsertLearningWalkLabel') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertLearningWalkLabel.'
      drop procedure dbo.InsertLearningWalkLabel
   END
GO
PRINT '.. Creating sproc InsertLearningWalkLabel.'
GO
CREATE PROCEDURE InsertLearningWalkLabel
		@pLabel VARCHAR(200)
		,@pPracticeSessionID BIGINT
AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@sql_error_message   	NVARCHAR(500)

---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@ProcName               = OBJECT_NAME(@@PROCID)

IF NOT EXISTS ( SELECT LabelID 
				  FROM dbo.SELearningWalkClassroomLabel 
				 WHERE Label=@pLabel
				   AND PracticeSessionID=@pPracticeSessionID)
BEGIN
	INSERT dbo.SELearningWalkClassroomLabel(PracticeSessionID, Label)
	VALUES (@pPracticeSessionID, @pLabel)
END

SELECT @sql_error = @@ERROR 
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SELearningWalkClassRoomLabel failed. In: ' 
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


