if exists (select * from sysobjects 
where id = object_id('dbo.UpdateFrameworkViewType') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateFrameworkViewType.'
      drop procedure dbo.UpdateFrameworkViewType
   END
GO
PRINT '.. Creating sproc UpdateFrameworkViewType.'
GO
CREATE PROCEDURE UpdateFrameworkViewType
	 @pDistrictCode VARCHAR(20)
	,@pSchoolYear SMALLINT
	,@pFrameworkViewTypeID SMALLINT
	,@pEvaluationTypeID SMALLINT
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


UPDATE dbo.SEDistrictConfiguration
   SET FrameworkViewTypeID=@pFrameworkViewTypeID
 WHERE SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   AND EvaluationTypeID=@pEvaluationTypeID
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update to SEDistrictConfiguration  failed. In: ' 
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


