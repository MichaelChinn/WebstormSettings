if exists (select * from sysobjects 
where id = object_id('dbo.LetMeBe') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc LetMeBe.'
      drop procedure dbo.LetMeBe
   END
GO
PRINT '.. Creating sproc LetMeBe.'
GO
CREATE PROCEDURE LetMeBe
@pAspnetUserName varchar(200)
,@pPassword varchar(200) ='Teot+hQW/alZR0qJgHbyeIps4jY='
,@pPasswordSalt varchar(200) = 'vuFtU+smxgqlRZh2i9dkrQ=='


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

/***********************************************************************************/
BEGIN

	IF NOT EXISTS (select userID from dbo.aspnet_Users where UserName = @pAspnetUserName)
	BEGIN
	  SELECT @sql_error_message = 'could not change the password' 
			,@sql_error = -1
	  GOTO ErrorHandler
	END
	
	SELECT password, passwordSalt 
	from dbo.aspnet_Membership m
	join dbo.aspnet_Users u on u.UserId = m.UserId
	where u.UserName = @pAspnetUserName
	
	
	DECLARE @format int, @isLockedOut bit
	if (@pPassword = '')
	BEGIN
		select @format = 0, @isLockedOut = 1
	END
	ELSE BEGIN
	 select @format = 1, @isLockedOut=0
	END
	
	
	UPDATE dbo.aspnet_membership 
	set Password = @pPassword
	, PasswordSalt = @pPasswordSalt
	, PasswordFormat = @format
	, IsLockedOut = @isLockedOut
	FROM dbo.aspnet_Membership m
	JOIN dbo.aspnet_Users u on u.UserId = m.UserId
	WHERE UserName = @pAspnetUserName
	
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	   BEGIN
		  SELECT @sql_error_message = 'could not change the password' 

		  GOTO ErrorHandler
	   END


END
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
         BEGIN
            ROLLBACK TRANSACTION
         END


	  SELECT @sql_error_message = '.... In: ' + @ProcName + '. ' + Convert(varchar(20), @sql_error) 
		+ '>>>' + ISNULL(@sql_error_message, '') + '<<<  '
		+ ' ... parameters...'
		+ 	' @pUserName =' + @pAspnetUserName 
		        +   '<<<  '



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

RETURN(@sql_error)

GO

