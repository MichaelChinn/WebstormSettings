if exists (select * from sysobjects 
where id = object_id('dbo.InsertLearningWalkClassroomLabel') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertLearningWalkClassroomLabel.'
      drop procedure dbo.InsertLearningWalkClassroomLabel
   END
GO
PRINT '.. Creating sproc InsertLearningWalkClassroomLabel.'
GO
CREATE PROCEDURE InsertLearningWalkClassroomLabel
		@pLabel VARCHAR(200)
		,@pClassroomID BIGINT
		,@pPracticeSessionID BIGINT
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


DECLARE @LabelID BIGINT
SELECT @LabelID = LabelID 
  FROM dbo.SELearningWalkClassroomLabel 
 WHERE Label=@pLabel
   AND PracticeSessionID=@pPracticeSessionID

IF (@LabelID IS NOT NULL)
BEGIN
	INSERT dbo.SELearningWalkClassroomLabelRelationship(ClassroomID, LabelID)
	VALUES (@pClassroomID, @LabelID)
END
ELSE
BEGIN
	INSERT dbo.SELearningWalkClassroomLabel(PracticeSessionID, Label) VALUES(@pPracticeSessionID, @pLabel)
	SELECT @LabelID = @@IDENTITY

	INSERT dbo.SELearningWalkClassroomLabelRelationship(ClassroomID, LabelID)
	VALUES (@pClassroomID, @LabelID)
END

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


