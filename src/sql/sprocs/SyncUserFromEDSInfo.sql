IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.SyncUserFromEDSInfo')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc SyncUserFromEDSInfo.'
        DROP PROCEDURE dbo.SyncUserFromEDSInfo
    END
GO
PRINT '.. Creating sproc SyncUserFromEDSInfo.'
GO
CREATE PROCEDURE SyncUserFromEDSInfo
    @pEDSUserName VARCHAR(256) ,
    @pEmail VARCHAR(256) ,
    @pFirstName VARCHAR(50) ,
    @pLastName VARCHAR(50) ,
    @pDistrictCode VARCHAR(10) ,
    @pSchoolCode VARCHAR(10) ,
    @pEvaluationType SMALLINT ,
    @pOldEDSIds VARCHAR(5000) = '' ,
    @pDebug BIT = 0
AS
    SET NOCOUNT ON 


---------------
-- VARIABLES --
---------------
    DECLARE @sql_error INT ,
        @ProcName SYSNAME ,
        @tran_count INT ,
        @sql_error_message NVARCHAR(500)

---------------------
-- INITIALIZATIONS --
---------------------
    SELECT  @sql_error = 0 ,
            @tran_count = @@TRANCOUNT ,
            @ProcName = OBJECT_NAME(@@PROCID)

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

        DECLARE @seUserID BIGINT


        IF ( @pDebug = 1 )
            BEGIN
                SELECT  @pEDSUserName ,
                        @pEDSUserName ,
                        @pFirstName ,
                        @pLastName ,
                        @pDistrictCode ,
                        @pSchoolCode ,
                        @pEvaluationType
            END


        IF NOT EXISTS ( SELECT  userId
                        FROM    aspnet_users
                        WHERE   userName = @pEDSUserName )
            AND ( @pOldEDSIds <> '' )
            BEGIN
                EXEC @sql_error = dbo.ChangeEDSUserName @pCurrentEDSUserName = @pEDSUserName, -- varchar(100)
                    @pIDHistory = @pOldEDSIds, -- varchar(8000)
                    @pApplicationName = 'SE', -- varchar(200)
                    @sql_error_message = @sql_error_message
			
                IF @sql_error <> 0
                    BEGIN
                        SELECT  @sql_error_message = 'EXEC ChangeEDSUserName failed. In: '
                                + @ProcName + '. ' + '>>>'
                                + ISNULL(@sql_error_message, '')
                        GOTO ErrorHandler
                    END
            END


        CREATE TABLE #t
            (
              firstString VARCHAR(50) ,
              secondString VARCHAR(200)
            )
        DECLARE @ahora DATETIME ,
            @foo BIGINT
        SELECT  @ahora = GETDATE()

		--if the user is not there, insert him

		--if the user is there, but something is different, update from the input args

		--else the user is not there, so insert him	

        IF NOT EXISTS ( SELECT  userId
                        FROM    aspnet_users
                        WHERE   userName = @pEDSUserName )
            BEGIN		
		--the user isn't known yet
		--aspnet_UsersInRoles_AddUsersToRoles will set an aspnet_user record for him
		--then insert a coeUser record for him
                IF ( @pDebug = 1 )
                    SELECT  'heretofore unseen user'

                DECLARE @aspnetUserId UNIQUEIDENTIFIER

                EXEC aspnet_Membership_CreateUser @ApplicationName = 'SE',
                    @UserName = @pEDSUserName,
                    @Password = 'Teot+hQW/alZR0qJgHbyeIps4jY=',
                    @PasswordSalt = 'vuFtU+smxgqlRZh2i9dkrQ==',
                    @Email = @pEmail, @PasswordQuestion = '',
                    @PasswordAnswer = '', @IsApproved = 1,
                    @CurrentTimeUtc = @ahora, @CreateDate = @ahora,
                    @UniqueEmail = 0, @PasswordFormat = 1,
                    @UserId = @aspnetUserId OUTPUT

                SELECT  @sql_error = @@ERROR
                IF @sql_error <> 0
                    BEGIN
                        SELECT  @sql_error_message = 'Failed inserting membership record for user' 

                        GOTO ErrorHandler
                    END

                SELECT  @aspnetUserId = userId
                FROM    dbo.aspnet_users
                WHERE   userName = @pEDSUserName
		
                INSERT  dbo.seUser
                        ( firstName ,
                          lastName ,
                          DistrictCode ,
                          SchoolCode ,
                          ASPNetUserID ,
                          HasMultipleBuildings ,
                          Username ,
                          loweredUsername
                        )
                VALUES  ( @pFirstName ,
                          @pLastName ,
                          @pDistrictCode ,
                          @pSchoolCode ,
                          @aspnetUserId ,
                          0 ,
                          @pEDSUserName ,
                          LOWER(@pEDSUserName)
                        )


                SELECT  @sql_error = @@ERROR
                IF @sql_error <> 0
                    BEGIN
                        SELECT  @sql_error_message = 'Problem inserting new COEUser' 

                        GOTO ErrorHandler
                    END
		   
                SELECT  @seUserID = seUserID
                FROM    dbo.SEUser u
                        JOIN aspnet_Users au ON au.UserId = u.ASPNetUserID
                WHERE   au.userID = @aspnetUserId
		
                IF ( @pDebug = 1 )
                    SELECT  @seUserID AS seuserid ,
                            @pDistrictCode AS districtcode ,
                            @pSchoolCode AS schoolcode
		   		

            END

        ELSE  --well, the user is here
            BEGIN
                IF ( @pDebug = 1 )
                    SELECT  'know the user'
		
                DECLARE @auid UNIQUEIDENTIFIER ,
                    @currentUserName VARCHAR(256) ,
                    @matchCount INT ,
                    @currentEmail VARCHAR(256)
                SELECT  @auid = u.userID ,
                        @CurrentUserName = u.userName ,
                        @seUserID = seUserID
                FROM    dbo.aspnet_users u
                        JOIN dbo.SEUser seu ON seu.ASPNetUserID = u.UserId
                WHERE   u.userName = @pEDSUserName
		
                IF ( @pDebug = 1 )
                    SELECT  'the user''s userid is: '
                            + CONVERT(VARCHAR(10), @seUserID)
		
                SELECT  @currentEmail = email
                FROM    dbo.aspnet_membership
                WHERE   userId = @auid 

		--is the email the same?
                IF ( @currentEmail <> @pEmail )
                    BEGIN
                        IF ( @pDebug = 1 )
                            SELECT  'knew the user, aspnet_membership.dbo.email is changing'

                        UPDATE  dbo.aspnet_membership
                        SET     email = @pEmail
                        WHERE   userid = @auid

                        SELECT  @sql_error = @@ERROR
                        IF @sql_error <> 0
                            BEGIN
                                SELECT  @sql_error_message = 'Problem updating email' 

                                GOTO ErrorHandler
                            END
                    END

		-- now check the coeUser information
                IF NOT EXISTS ( SELECT  SEUserID
                                FROM    dbo.seUser u
                                WHERE   u.aspnetUserId = @auid
                                        AND FIRSTNAME = @pFirstName
                                        AND LastName = @pLastName
                                        AND DistrictCode = @pDistrictCode
                                        AND SchoolCode = @pSchoolCode )
                    BEGIN	--we know that there is something different about his (non aspnet table) info

                        IF ( @pDebug = 1 )
                            SELECT  'knew the user, but something is different of coeUser info'

                        UPDATE  dbo.SEUser
                        SET     FirstName = @pFirstName ,
                                LastName = @pLastName ,
                                DistrictCode = @pDistrictCode ,
                                SchoolCode = @pSchoolCode ,
                                Username = @pEDSUserName ,
                                loweredUsername = LOWER(@pEDSUserName)
                        WHERE   aspnetUserId = @auid

                        SELECT  @sql_error = @@ERROR
                        IF @sql_error <> 0
                            BEGIN
                                SELECT  @sql_error_message = 'Problem updating coeUser information' 

                                GOTO ErrorHandler
                            END
                    END

            END
     
     
    --in any event, make sure that we have current location info for him
        DELETE  dbo.SEUserDistrictSchool
        WHERE   seUserID = @seUserID
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Could not remove user from seUserDistrictSchool  failed.'
                        + CONVERT(VARCHAR(10), @seUserID) + '. In: '
                        + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
                GOTO ErrorHandler
            END

		/*
			we join through the LRC table because we want to insert
			SEUserDistrictSchool records for *every* location we know of
			for him, not just the location/role that is being presented
			to this instance of the sproc.

			LRC has been filled out earlier in the user hydration cycle by
			the STP, and has a record for *each* role claim (location, roles)
			from EDS
		*/

        DECLARE @nBuildings INT
        INSERT  dbo.SEUserDistrictSchool
                ( SEUserID ,
                  districtCode ,
                  schoolCode ,
                  IsPrimary
                )
                SELECT DISTINCT
                        @seUserID ,
                        DistrictCode ,
                        CASE WHEN lrc.LocationCode LIKE '____'
                             THEN lrc.LocationCode
                             ELSE ''
                        END ,
                        1
                FROM    dbo.locationRoleClaim lrc
                        JOIN dbo.SEUser su ON su.Username = lrc.userName
                WHERE   seuserId = @seUserID
	
        SELECT  @sql_error = @@ERROR ,
                @nBuildings = @@ROWCOUNT
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Could not insert to SEUserDistrictSchool  failed. '
                        + CONVERT(VARCHAR(10), @seUserID) + '. In: '
                        + @ProcName + ' >>>' + ISNULL(@sql_error_message, '')
                GOTO ErrorHandler
            END
		
        IF ( @nBuildings > 1 )
            BEGIN
                UPDATE  dbo.SEUser
                SET     HasMultipleBuildings = 1
                WHERE   seUserID = @seUserID
                IF @sql_error <> 0
                    BEGIN
                        SELECT  @sql_error_message = 'Failed to update HasMultipleBuildings for user. '
                                + CONVERT(VARCHAR(10), @seUserID) + '. In: '
                                + @ProcName + ' >>>'
                                + ISNULL(@sql_error_message, '')
                        GOTO ErrorHandler
                    END	
            END
	
	--Check to see whether he has an SEEvaluationRecord
        IF ( @pEvaluationType <> 0 )
            BEGIN
                EXEC @sql_error = dbo.InsertEvaluation @pEvaluationTypeID = @pEvaluationType,
                    @pSchoolYear = NULL, @pDistrictCode = @pDistrictCode,
                    @pEvaluateeID = @seUserID,
                    @sql_error_message = @sql_error_message OUTPUT
                IF @sql_error <> 0
                    BEGIN
                        SELECT  @sql_error_message = 'EXEC InsertEvaluation failed. In: '
                                + @ProcName + '. ' + '>>>'
                                + ISNULL(@sql_error_message, '')
                        GOTO ErrorHandler
                    END
            END
    END
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
    ErrorHandler:
    IF ( @sql_error <> 0 )
        BEGIN
            IF ( @tran_count = 0 )
                AND ( @@TRANCOUNT <> 0 )
                BEGIN
                    ROLLBACK TRANSACTION
                END

            SELECT  @sql_error_message = '.... In: ' + @ProcName + '. '
                    + CONVERT(VARCHAR(20), @sql_error) + '>>>'
                    + ISNULL(@sql_error_message, '') + '<<<  '
                    + ' ... parameters...' + ' @pEmail =' + @pEmail
                    + ' | @pEDSUserName ='
                    + CONVERT(VARCHAR(50), ISNULL(@pEDSUserName, ''))
                    + ' | @pfirstName ='
                    + CONVERT(VARCHAR(50), ISNULL(@pfirstName, ''))
                    + ' | @plastName ='
                    + CONVERT(VARCHAR(50), ISNULL(@plastName, ''))
                    + ' | @pbuildingId ='
                    + CONVERT(VARCHAR(50), ISNULL(@pSchoolCode, ''))
                    + ' | @pLeaId ='
                    + CONVERT(VARCHAR(50), ISNULL(@pDistrictCode, ''))
                    + '<<<  '

            RAISERROR(@sql_error_message, 15, 10)

            IF ( @pDebug = 1 )
                BEGIN
                    SELECT  @pEDSUserName ,
                            @pFirstName ,
                            @pLastName ,
                            @pDistrictCode ,
                            @pSchoolCode ,
                            @pEvaluationType

                END
        END

----------------------
-- End of Procedure --
----------------------
    ProcEnd:

    SELECT  u.*
    FROM    vSEUser u
            JOIN dbo.aspnet_Users au ON au.userId = u.aspnetUserID
    WHERE   au.userName = @pEDSUserName

    IF ( @tran_count = 0 )
        AND ( @@TRANCOUNT = 1 )
        BEGIN
            COMMIT TRANSACTION
        END

    RETURN(@sql_error)

GO

