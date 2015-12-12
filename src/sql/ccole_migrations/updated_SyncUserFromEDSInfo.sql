if exists (select * from sysobjects 
where id = object_id('dbo.SyncUserFromEDSInfo') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc SyncUserFromEDSInfo.'
      drop procedure dbo.SyncUserFromEDSInfo
   END
GO
PRINT '.. Creating sproc SyncUserFromEDSInfo.'
GO
CREATE PROCEDURE SyncUserFromEDSInfo
@pEDSUserName varchar (256)
,@pEmail varchar (256)
,@pFirstName varchar (50)
,@pLastName  varchar (50)
,@pDistrictCode varchar (10)
,@pSchoolCode varchar (10)
,@pEvaluationType smallint
,@pDebug bit = 0
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

	--!!! have to assume that the username is unique in EDS
	-- ==> as long as we don't append '_edsUser' to usernames assigned in eCOE,
	--     the taggedUserName will be delete as well

	DECLARE @seUserID  bigint


	if (@pDebug=1)
	BEGIN
		select @pEDSUserName, @pEDSUserName, @pFirstName, @pLastName, @pDistrictCode, @pSchoolCode, @pEvaluationType
	END

	create table #t (firstString varchar (50), secondString varchar(200))
	declare @ahora datetime, @foo bigint
	select @ahora = GETDATE()

	--if the user is not there, insert him

	--if the user is there, but something is different, update from the input args

	--else the user is not there, so insert him	

	IF NOT EXISTS (SELECT userId from aspnet_users where userName = @pEDSUserName)
	BEGIN		
		--the user isn't known yet
		--aspnet_UsersInRoles_AddUsersToRoles will set an aspnet_user record for him
		--then insert a coeUser record for him
		if (@pDebug=1)
			select 'heretofore unseen user'

		DECLARE @aspnetUserId uniqueidentifier

		exec aspnet_Membership_CreateUser
			@ApplicationName     = 'SE'
			,@UserName            =@pEDSUserName
			,@Password            ='Teot+hQW/alZR0qJgHbyeIps4jY='
			,@PasswordSalt        ='vuFtU+smxgqlRZh2i9dkrQ=='
			,@Email               =@pEmail
			,@PasswordQuestion    =''
			,@PasswordAnswer      =''
			,@IsApproved          =1
			,@CurrentTimeUtc      =@ahora
			,@CreateDate          =@ahora
			,@UniqueEmail         =0
			,@PasswordFormat      =0
			,@UserId              =@aspnetUserId OUTPUT

		SELECT @sql_error = @@ERROR
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Failed inserting membership record for user' 

			  GOTO ErrorHandler
		   END

		select @aspnetUserId = userId
		from dbo.aspnet_users
		where userName = @pEDSUserName
		
		INSERT dbo.seUser (firstName, lastName, DistrictCode, SchoolCode, ASPNetUserID, HasMultipleBuildings, 
			Username, loweredUsername)
		values (@pFirstName, @pLastName, @pDistrictCode, @pSchoolCode, @aspnetUserId, 0,
			@pEDSUserName, LOWER(@pEDSUserName) )


		SELECT @sql_error = @@ERROR
		IF @sql_error <> 0
		   BEGIN
			  SELECT @sql_error_message = 'Problem inserting new COEUser' 

			  GOTO ErrorHandler
		   END
		   
		select @seUserID = seUserID from dbo.SEUser u
		join aspnet_Users au on au.UserId = u.ASPNetUserID
		where au.userID = @aspnetUserId
		
		if (@pDebug=1)
			select @seUserID as seuserid, @pDistrictCode as districtcode, @pSchoolCode as schoolcode
		   		
		INSERT dbo.SEUserDistrictSchool(SEUserID, districtCode, schoolCode, IsPrimary)
		VALUES (@seUserID, @pDistrictCode, @pSchoolCode, 1)
		SELECT @sql_error = @@ERROR
		IF @sql_error <> 0
		BEGIN
			SELECT @sql_error_message = 'Could not insert to SEUserDistrictSchool  failed. Brand New User.  In: ' 
				+ @ProcName
				+ ' >>>' + ISNULL(@sql_error_message, '')
			GOTO ErrorHandler
		END
		
		IF (@pEvaluationType <> 0)
		BEGIN
			INSERT dbo.SEFinalScore(EvaluateeID, EvaluatorID, EvaluationTypeID) 
			VALUES(@seUserID, null, @pEvaluationType)
			SELECT @sql_error = @@ERROR
			IF @sql_error <> 0
			BEGIN
				SELECT @sql_error_message = 'Could not update to SEFinalScore  failed. In: ' 
					+ @ProcName
					+ ' >>>' + ISNULL(@sql_error_message, '')
				GOTO ErrorHandler
			END
		END
				
	END

	ELSE  --well, the user is here
	BEGIN
		if (@pDebug=1)
			select 'know the user'
		
		DECLARE @auid uniqueIdentifier, @currentUserName varchar (256)
		, @matchCount int, @currentEmail varchar (256)
		SELECT @auid = u.userID , @CurrentUserName = u.userName, @seUserID=seUserID
		FROM dbo.aspnet_users u
		join dbo.SEUser seu on seu.ASPNetUserID = u.UserId
		WHERE u.userName = @pEDSUserName
		
		if (@pDebug=1)
			select 'the user''s userid is: ' + CONVERT(varchar(10), @seUserID)
		
		SELECT @currentEmail =email from dbo.aspnet_membership where userId = @auid 

		--is the email the same?
		IF (@currentEmail <> @pEmail)
		BEGIN
			if (@pDebug = 1)
				select 'knew the user, aspnet_membership.dbo.email is changing'

			UPDATE dbo.aspnet_membership set email = @pEmail
			where userid = @auid

			SELECT @sql_error = @@ERROR
			IF @sql_error <> 0
			   BEGIN
				  SELECT @sql_error_message = 'Problem updating email' 

				  GOTO ErrorHandler
			   END
		END

		-- now check the coeUser information
		IF NOT EXISTS (
			SELECT SEUserID from dbo.seUser u
			WHERE u.aspnetUserId = @auid
				AND FIRSTNAME = @pFirstName
				AND LastName = @pLastName
				AND DistrictCode = @pDistrictCode
				AND SchoolCode = @pSchoolCode
		)	
		BEGIN	--we know that there is something different about his (non aspnet table) info

			if (@pDebug = 1)
				select 'knew the user, but something is different of coeUser info'

			UPDATE dbo.SEUser
				set FirstName = @pFirstName
				,LastName = @pLastName
				,DistrictCode = @pDistrictCode
				,SchoolCode = @pSchoolCode
				,Username = @pEDSUserName
				,loweredUsername = LOWER(@pEDSUserName)
			WHERE aspnetUserId = @auid

			SELECT @sql_error = @@ERROR
			IF @sql_error <> 0
			   BEGIN
				  SELECT @sql_error_message = 'Problem updating coeUser information' 

				  GOTO ErrorHandler
			   END
		END
		
		-- check his 'districts'
		IF NOT EXISTS (
			SELECT uds.SEUserID from dbo.seUser u
			JOIN SEUserDistrictSchool uds on uds.seUserID = u.seUserID 
			WHERE u.aspnetUserId = @auid
				AND uds.DistrictCode = @pDistrictCode
				AND uds.SchoolCode = @pSchoolCode
		)
		BEGIN	
			INSERT dbo.SEUserDistrictSchool(SEUserID, districtCode, schoolCode, IsPrimary)
			VALUES (@seUserID, @pDistrictCode, @pSchoolCode, 1)
			SELECT @sql_error = @@ERROR
			IF @sql_error <> 0
			BEGIN
				SELECT @sql_error_message = 'Could not insert to SEUserDistrictSchool  failed. he is known, his user id is... '
				+CONVERT(varchar(10), @seUserID)+'. In: ' 
					+ @ProcName
					+ ' >>>' + ISNULL(@sql_error_message, '')
				GOTO ErrorHandler
			END
		END
		
		
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
		+ 	' @pEmail =' + @pEmail 
		+ 	' | @pEDSUserName =' + convert(varchar(50), isNull(@pEDSUserName , '')) 
		+ 	' | @pfirstName =' + convert(varchar(50), isNull(@pfirstName , '')) 
		+ 	' | @plastName =' + convert(varchar(50), isNull(@plastName , '')) 
		+ 	' | @pbuildingId =' + convert(varchar(50), isNull(@pSchoolCode , '')) 
		+ 	' | @pLeaId =' + convert(varchar(50), isNull(@pDistrictCode , '')) 
        +   '<<<  '

      RAISERROR(@sql_error_message, 15, 10)

	  if (@pDebug=1)
	  BEGIN
		select @pEDSUserName, @pFirstName, @pLastName, @pDistrictCode, @pSchoolCode, @pEvaluationType

	  END
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

	SELECT u.* from vSEUser u 
	JOIN dbo.aspnet_Users au on au.userId = u.aspnetUserID
	where au.userName = @pEDSUserName

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END

RETURN(@sql_error)

GO

