IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.EDSExport_SetupNew')
                    AND sysstat & 0xf = 4 ) 
    BEGIN
        PRINT '.. Dropping sproc EDSExport_SetupNew.'
        DROP PROCEDURE dbo.EDSExport_SetupNew
    END
GO
PRINT '.. Creating sproc EDSExport_SetupNew.'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE EDSExport_SetupNew
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
     
        DECLARE @ahora DATETIME ,
            @appId UNIQUEIDENTIFIER
            
        SELECT  @ahora = GETDATE() ,
                @appId = applicationId
        FROM    dbo.aspnet_Applications
        WHERE   ApplicationName = 'se'  
		
        INSERT  dbo.aspnet_Users
                ( ApplicationId ,
                  userId ,
                  UserName ,
                  LoweredUserName ,
                  IsAnonymous ,
                  LastActivityDate
                )
                SELECT  DISTINCT
                        @appId ,
                        NEWID() ,
                        UPPER(CONVERT(VARCHAR(20), personID) + '_edsUser') ,
                        LOWER(CONVERT(VARCHAR(20), personID) + '_edsUser') ,
                        0 ,
                        @ahora
                FROM    EDSStaging
                WHERE   IsNew = 1
                        AND FirstEntry = 1
        
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem inserting new aspnet_user' 
                GOTO ErrorHandler
            END  
     
        INSERT  INTO dbo.aspnet_Membership
                ( ApplicationId ,
                  UserId ,
                  Password ,
                  PasswordSalt ,
                  Email ,
                  LoweredEmail ,
                  PasswordQuestion ,
                  PasswordAnswer ,
                  PasswordFormat ,
                  IsApproved ,
                  IsLockedOut ,
                  CreateDate ,
                  LastLoginDate ,
                  LastPasswordChangedDate ,
                  LastLockoutDate ,
                  FailedPasswordAttemptCount ,
                  FailedPasswordAttemptWindowStart ,
                  FailedPasswordAnswerAttemptCount ,
                  FailedPasswordAnswerAttemptWindowStart 
                )
                SELECT  @appId ,
                        u.userId ,
                        'Teot+hQW/alZR0qJgHbyeIps4jY=' ,
                        'vuFtU+smxgqlRZh2i9dkrQ==' ,
                        '' ,
                        '' ,
                        'TheQuestion' ,
                        'theAnswer' ,
                        1 ,
                        1 ,
                        0 ,
                        @ahora ,
                        '1/1/2000' ,
                        @ahora ,
                        '1/1/2000' ,
                        0 ,
                        '1/1/2000' ,
                        0 ,
                        '1/1/2000'
                FROM    EDSStaging sta
                        JOIN aspnet_users u ON u.username = CONVERT(VARCHAR(20), sta.personID)
                                               + '_edsUser'
                WHERE   IsNew = 1
                        AND FirstEntry = 1

        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem inserting new aspnet_membership record' 
                GOTO ErrorHandler
            END  
      
       
        INSERT  dbo.seUser
                ( firstName ,
                  lastName ,
                  ASPNetUserID ,
                  HasMultipleBuildings ,
                  Username ,
                  loweredUsername ,

				  loginName ,
				  EmailAddressAlternate ,
				  CertificateNumber
                        
                )
                SELECT  DISTINCT
                        RTRIM(LTRIM(xu.firstname)) ,
                        RTRIM(LTRIM(xu.lastname)) ,
                        au.UserId ,
                        0 ,
                        CONVERT(VARCHAR(20), xu.PersonId) + '_edsUser' ,
                        LOWER(CONVERT(VARCHAR(20), xu.PersonId) + '_edsUser') ,
                        xu.loginName ,
                        xu.EmailAddressAlternate ,
                        xu.CertificateNumber

                FROM    vedsUsers xu
                        JOIN EDSStaging s ON s.personId = xu.personId
                        JOIN aspnet_users au ON au.userName = CONVERT(VARCHAR(20), xu.PersonId)
                                                + '_edsUser'
                WHERE   s.IsNew = 1						--where it is new
                        AND s.firstEntry = 1			--only want to insert one
                        
                        -- *and* the user doesn't already have an seUser record
                        AND CONVERT(VARCHAR(20), xu.PersonId) + '_edsUser' NOT IN (
                        SELECT  userName
                        FROM    dbo.SEUser
                        WHERE   userName IS NOT NULL )
                   

        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem inserting new COEUser' 
                GOTO ErrorHandler
            END 
     

        UPDATE  dbo.seUser
        SET     aspnetUserid = au.UserId
        FROM    dbo.seUser su
                JOIN aspnet_users au ON au.userName = su.Username
                JOIN edsStaging sta ON au.UserName = CONVERT(VARCHAR(20), sta.PersonId)
                                       + '_edsUser'
        WHERE   sta.IsNew = 1
                AND sta.firstEntry = 1
                AND su.ASPNetUserID IS NULL
                        
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem updating old seUser record with new aspneUserid' 
                GOTO ErrorHandler
            END 
        
                
        UPDATE  dbo.seUser
        SET     HasMultipleBuildings = 1
        FROM    dbo.SEUser su
                JOIN ( SELECT   COUNT(locationCode) AS lcCount ,
                                personId
                       FROM     EDSStaging
                       GROUP BY personid
                     ) x ON CONVERT(VARCHAR(20), x.personID) + '_edsUser' = su.UserName
        WHERE   lcCount > 1

		SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem updating hasMultipleBuildings flag in seUser record ' 
                GOTO ErrorHandler
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

    RETURN(@sql_error)

