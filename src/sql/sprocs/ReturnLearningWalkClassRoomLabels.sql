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
		@pLabelID BIGINT,
		@pClassroomID BIGINT
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


INSERT dbo.SELearningWalkClassroomLabelRelationship(ClassroomID, LabelID)
VALUES (@pClassroomID, @pLabelID)
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


