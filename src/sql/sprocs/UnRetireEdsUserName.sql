if exists (select * from sysobjects 
where id = object_id('dbo.UnRetireEdsUserName') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UnRetireEdsUserName.'
      drop procedure dbo.UnRetireEdsUserName
   END
GO
PRINT '.. Creating sproc UnRetireEdsUserName.'
GO
CREATE PROCEDURE UnRetireEdsUserName
	 @pEDSPersonId BIGINT
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

DECLARE @retiredName VARCHAR (40)
DECLARE @unretiredName VARCHAR(40)

SELECT @retiredName = 'x' + CONVERT(VARCHAR (10), @pEDSPersonId) + '_depr'
SELECT @unretiredName = CONVERT(VARCHAR (10), @pEDSPersonId) + '_edsUser'

UPDATE seUser 
SET username = @unretiredName, loweredUsername = LOWER(@unretiredName)
WHERE username = @retiredName

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Unretire name in seUser failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

UPDATE aspnet_users 
 SET username = @unretiredName, loweredUsername = LOWER(@unretiredName)
WHERE username = @retiredName

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Unretire name in aspnet_users failed. In: ' 
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


