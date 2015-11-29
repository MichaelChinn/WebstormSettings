if exists (select * from sysobjects 
where id = object_id('dbo.UpdateReportSnapshot') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateReportSnapshot.'
      drop procedure dbo.UpdateReportSnapshot
   END
GO
PRINT '.. Creating sproc UpdateReportSnapshot.'
GO
CREATE PROCEDURE UpdateReportSnapshot
	 @pSnapshotID BIGINT
	,@pDescription TEXT
	,@pIsPublic BIT
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

------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION

UPDATE dbo.SEReportSnapshot
   SET IsPublic=@pIsPublic
WHERE ReportSnapshotID=@pSnapshotID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEReportSnapshot  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

IF (@pDescription IS NOT NULL)
BEGIN

DECLARE @RepoItemID BIGINT
SELECT @RepoItemID = RepositoryItemID
  FROM SEReportSnapshot 
 WHERE ReportSnapshotID=@pSnapshotID
 
UPDATE  $(RepoDatabaseName).dbo.RepositoryItem -- stateeval_repo.dbo.RepositoryItem
   SET DESCRIPTION=@pDescription
 WHERE RepositoryItemID=@RepoItemID
	
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to RepositoryItem  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END  

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


