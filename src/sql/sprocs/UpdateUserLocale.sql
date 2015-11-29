if exists (select * from sysobjects 
where id = object_id('dbo.UpdateUserLocale') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateUserLocale.'
      drop procedure dbo.UpdateUserLocale
   END
GO
PRINT '.. Creating sproc UpdateUserLocale.'
GO
CREATE PROCEDURE UpdateUserLocale
	 @pUserID bigint
	,@pDistrictCode varchar(10)
	,@pSchoolCode varchar (10)
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

UPDATE dbo.SEUser 
   SET DistrictCode= @pDistrictCode 
		,SchoolCode  = @pSchoolCode   
 WHERE SEUserID=@pUserID
 
 
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'updating of school or district code failed. In: ' 
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
