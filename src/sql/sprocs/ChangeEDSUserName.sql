IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.ChangeEDSUserName')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc ChangeEDSUserName.'
        DROP PROCEDURE dbo.ChangeEDSUserName
    END
GO
PRINT '.. Creating sproc ChangeEDSUserName.'
GO
SET QUOTED_IDENTIFIER ON
go 
CREATE PROCEDURE dbo.ChangeEDSUserName
    @pCurrentEDSUserName VARCHAR(100) ,
    @pIDHistory VARCHAR(8000) ,	          --a semi colon separated list of personId's that the person has had
    @pApplicationName VARCHAR(200) ,      -- the application name (SE, COE)
    @pDebug BIT = 0 ,
    @sql_error_message NVARCHAR(500) OUTPUT
AS
    SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
    DECLARE @sql_error INT ,
        @ProcName SYSNAME ,
        @tran_count INT 


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

		-- Get the UserId and ApplicationId for the user 
    DECLARE @ASPNETUserId UNIQUEIDENTIFIER ,
        @ApplicationId UNIQUEIDENTIFIER 
    SELECT  @ApplicationId = a.ApplicationId
    FROM    dbo.aspnet_Applications a
    WHERE   LOWER(@pApplicationName) = a.LoweredApplicationName

    IF @ApplicationId IS NULL
        BEGIN
            SELECT  @sql_error = -1
            SELECT  @sql_error_message = 'Could not find application '
                    + @pApplicationName
            GOTO ErrorHandler
        END

    IF ( @pDebug = 1 )
        SELECT  @pCurrentEDSUserName

    IF EXISTS ( SELECT  userName
                FROM    aspnet_Users
                WHERE   userName = @pCurrentEDSUserName )
        BEGIN
            SELECT  @sql_error = -1
            SELECT  @sql_error_message = 'New username already exists in aspnet_users... '
                    + @pCurrentEDSUserName
            GOTO ErrorHandler
        END

    DECLARE @PreXml VARCHAR(2000) ,
        @XMLList XML

	-- change the input string to something that looks like XML... that is:
	--     1;2;3;4   ->  <list><y i="1"/><y i="2"/><y i="3"/><y i="4"/></list>
	--SELECT  @PreXML = REPLACE(@pIDHistory, ' ', '')
    SELECT  @PreXML = REPLACE(@pIDHistory, ';', '"/><y i="')
    SELECT  @prexml = '<list><y i="' + @PreXML + '"/></list>'

    SELECT  @XMLList = @preXml

    IF @pDebug = 1
        SELECT  @preXml ,
                @pIDHistory

    CREATE TABLE #IdHistory ( OldPersonId BIGINT )

    INSERT  #IdHistory
            ( OldPersonid
            )
            SELECT  x.y.value('.', 'bigint')
            FROM    @XMLList.nodes('list/y/@i') AS x ( y )

    IF @pDebug = 1
        SELECT  *
        FROM    #IdHistory

	-- check to make sure there was only one userid in the db
    DECLARE @nIdentities INT 
    SELECT  @nIdentities = 0

    SELECT  @nIdentities = COUNT(*)
    FROM    aspnet_users au
            JOIN #IdHistory idh ON CONVERT(VARCHAR(20), idh.OldPersonId)
                                   + '_edsUser' = au.UserName


	--no history ids here: we don't know this guy at all...
    IF ( @nIdentities = 0 )
        GOTO PROCEND

    IF ( @nIdentities > 1 )
        BEGIN
            SELECT  @sql_error = -1
            SELECT  @sql_error_message = 'Multiple old identities found for current user'
            GOTO ErrorHandler
        END

/*
	--tried to get this error condition to work, but it can't
	--during export, these things are taken care of by the calling sproc
	--during the saml processing, this sproc never gets called if the username is known
    IF ( @nIdentities = 1 )
        BEGIN
            IF EXISTS ( SELECT  userId
                        FROM    aspnet_users au
                                JOIN #IdHistory idh ON @pCurrentEDSUserName = au.UserName )
                BEGIN
                    SELECT  @sql_error = -1
                    SELECT  @sql_error_message = 'New and old identities found simultaneusly'
                    GOTO ErrorHandler
                END
        END
*/

	--get the aspnet_userId of the old login
    DECLARE @oldUserName VARCHAR(50)
    SELECT  @oldUserName = CONVERT(VARCHAR(20), idh.OldPersonId) + '_EDSUSER'
    FROM    aspnet_users au
            JOIN #IdHistory idh ON CONVERT(VARCHAR(20), idh.OldPersonId)
                                   + '_edsUser' = au.UserName


    SELECT  @AspnetUserid = au.Userid
    FROM    aspnet_users au
            JOIN #IdHistory idh ON @oldUserName = au.UserName
 
    UPDATE  aspnet_Users
    SET     UserName = UPPER(@pCurrentEDSUserName) ,
            LoweredUserName = LOWER(@pCurrentEDSUserName)
    WHERE   UserId = @AspnetUserid
            AND ApplicationId = @ApplicationId 

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem changing the username in aspnet_users table' 
            GOTO ErrorHandler
        END

    UPDATE  SEUser
    SET     UserName = UPPER(@pCurrentEDSUserName) ,
            LoweredUserName = LOWER(@pCurrentEDSUserName)
    WHERE   aspnetUserId = @AspnetUserid
            

    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem changing the username in SEUser table' 
            GOTO ErrorHandler
        END

    UPDATE  LocationRoleClaim
    SET     userName = @pCurrentEDSUserName
    WHERE   userName = @oldUserName
            
    SELECT  @sql_error = @@ERROR
    IF @sql_error <> 0
        BEGIN
            SELECT  @sql_error_message = 'Problem changing the username in LocationRoleClaim table' 
            GOTO ErrorHandler
        END
		

-------------------
-- Handle errors --
-------------------
    ErrorHandler:
    IF ( @sql_error <> 0 )
        BEGIN

            SELECT  @sql_error_message = @sql_error_message + '.... In: '
                    + @ProcName + '. ' + CONVERT(VARCHAR(20), @sql_error)
                    + '>>>' + '@pCurrentPersonId: ' + @pCurrentEDSUserName
                    + ' | ' + '@pIdHistory: ' + @pIDHistory + ' | '
                    + '@pApplicationName: - ' + @pApplicationName + '<<<  '
            IF @@TRANCOUNT = 1
                ROLLBACK TRANSACTION


            RAISERROR(@sql_error_message, 15, 10)
        END



----------------------
-- End of Procedure --
----------------------
    ProcEnd:

    IF ( @tran_count = 0 )
        AND ( @@TRANCOUNT = 1 )
        BEGIN
            COMMIT TRANSACTION
        END



