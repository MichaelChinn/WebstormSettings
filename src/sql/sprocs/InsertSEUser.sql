if exists (select * from sysobjects 
where id = object_id('dbo.InsertSEUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertSEUser.'
      drop procedure dbo.InsertSEUser
   END
GO
PRINT '.. Creating sproc InsertSEUser.'
GO
CREATE PROCEDURE InsertSEUser
	@pUserName		varchar(256)
	,@pFirstName	varchar(50)
	,@pLastName		varchar(50)
	,@pEMail		varchar(256)
	,@pDistrictCode		varchar(20)= ''
    ,@pSchoolCode	varchar(20) = ''
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

DECLARE @ApplicationID UNIQUEIDENTIFIER, @NetUserID UNIQUEIDENTIFIER
DECLARE @ltDate DATETIME, @utcDate DATETIME
SELECT @ltDate = getdate()
SELECT @utcDate = getutcdate()

EXEC dbo.aspnet_Applications_CreateApplication 'SE', @ApplicationID OUTPUT

SELECT @NetUserID = NULL

IF EXISTS (SELECT userId FROM dbo.aspnet_users WHERE userName = @pUserName)
SELECT @sql_error = -1
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'seUser '+@pUserName+' exists  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END


EXEC dbo.aspnet_Membership_CreateUser 
	 @ApplicationName=N'SE'
	,@UserName=@pUserName
	,@Password='a/sIilT282/jAGnN7D3eJVeNMco='
	,@PasswordSalt = 'e9Neug8GJXnSIfqHSzKSiw=='
	,@PasswordQuestion=N'test'
	,@PasswordAnswer=N'gUg/Zc1qj8zlMCclIS2AQRPhKaI='
	,@Email=@pEMail
	,@IsApproved=1
	,@UniqueEmail=0
	,@PasswordFormat=1
	,@CurrentTimeUtc=@utcDate
	,@UserID=@NetUserID OUTPUT

DECLARE @UserID BIGINT

INSERT dbo.SEUser(aspnetUserID, FirstName, LastName, emailAddress)
VALUES (@NetUserID, @pFirstName, @pLastName, @pEMail)
SELECT @sql_error = @@ERROR, @UserID = SCOPE_IDENTITY()
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUser  failed. In: ' 
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


