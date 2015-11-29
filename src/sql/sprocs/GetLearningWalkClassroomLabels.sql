if exists (select * from sysobjects 
where id = object_id('dbo.GetLearningWalkClassroomLabels') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetLearningWalkClassroomLabels.'
      drop procedure dbo.GetLearningWalkClassroomLabels
   END
GO
PRINT '.. Creating sproc GetLearningWalkClassroomLabels.'
GO
CREATE PROCEDURE GetLearningWalkClassroomLabels
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


SELECT l.LabelID
      ,l.Label
 FROM SELearningWalkClassroomLabelRelationship r
 JOIN SELearningWalkClassroomLabel l ON r.LabelID = l.LabelID
WHERE ClassroomID = @pClassroomID
ORDER BY l.Label ASC

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


