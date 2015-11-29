if exists (select * from sysobjects 
where id = object_id('dbo.InsertReportSnapshot') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertReportSnapshot.'
      drop procedure dbo.InsertReportSnapshot
   END
GO
PRINT '.. Creating sproc InsertReportSnapshot.'
GO
CREATE PROCEDURE InsertReportSnapshot
	 @pSEUserID BIGINT
	,@pSchoolYear SMALLINT
	,@pRepositoryItemID BIGINT
	,@pReportTypeID SMALLINT
	,@pIsPublic BIT = 0
	,@pDistrictCode VARCHAR(20)
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

INSERT dbo.SEReportSnapshot(SchoolYear, ReportTypeID, RepositoryItemID, IsPublic, DistrictCode)
VALUES (@pSchoolYear, @pReportTypeID, @pRepositoryItemID, @pIsPublic, @pDistrictCode)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEReportSnapshot  failed. In: ' 
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


