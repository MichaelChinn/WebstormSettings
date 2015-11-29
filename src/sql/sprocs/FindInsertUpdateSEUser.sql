IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.FindInsertUpdateSEUser')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc FindInsertUpdateSEUser.';
        DROP PROCEDURE dbo.FindInsertUpdateSEUser;
    END;
GO
PRINT '.. Creating sproc FindInsertUpdateSEUser.';
GO
CREATE PROCEDURE FindInsertUpdateSEUser
    @pUserName VARCHAR(256) ,
    @pFirstName VARCHAR(50) ,
    @pLastName VARCHAR(50) ,
    @pEMail VARCHAR(256) ,
    @pCertNo VARCHAR(20) ,
    @pHasMultipleLocations BIT ,
	@pSEUserIdOutput BIGINT OUTPUT
AS
    SET NOCOUNT ON; 
--TODO  remove district and school code, and add certNo and has multiple
---------------
-- VARIABLES --
---------------
    DECLARE @sql_error INT ,
        @ProcName sysname ,
        @tran_count INT ,
        @sql_error_message NVARCHAR(500);


---------------------
-- INITIALIZATIONS --
---------------------
    SELECT  @sql_error = 0 ,
            @tran_count = @@TRANCOUNT ,
            @ProcName = OBJECT_NAME(@@PROCID);

------------------
-- TRAN CONTROL --
------------------


    DECLARE @ApplicationID UNIQUEIDENTIFIER ,
        @NetUserID UNIQUEIDENTIFIER;
    DECLARE @ltDate DATETIME ,
        @utcDate DATETIME;
    SELECT  @ltDate = GETDATE();
    SELECT  @utcDate = GETUTCDATE();

    EXEC dbo.aspnet_Applications_CreateApplication 'SE', @ApplicationID OUTPUT;

    SELECT  @NetUserID = NULL;

    DECLARE @SEUserId BIGINT;
    SELECT  @SEUserId = SEUserID
    FROM    dbo.SEUser su
            JOIN dbo.aspnet_Users au ON au.UserId = su.ASPNetUserID
    WHERE   au.UserName = @pUserName;


    IF @tran_count = 0
        BEGIN TRANSACTION;
    BEGIN TRY

        IF @SEUserId IS NULL
            BEGIN

                SELECT  @sql_error_message = 'Creating an aspne User for application SE';
                EXEC dbo.aspnet_Membership_CreateUser @ApplicationName = N'SE',
                    @UserName = @pUserName,
                    @Password = 'a/sIilT282/jAGnN7D3eJVeNMco=',
                    @PasswordSalt = 'e9Neug8GJXnSIfqHSzKSiw==',
                    @PasswordQuestion = N'test',
                    @PasswordAnswer = N'gUg/Zc1qj8zlMCclIS2AQRPhKaI=',
                    @Email = @pEMail, @IsApproved = 1, @UniqueEmail = 0,
                    @PasswordFormat = 1, @CurrentTimeUtc = @utcDate,
                    @UserId = @NetUserID OUTPUT;

                DECLARE @UserID BIGINT;

                SELECT  @sql_error_message = 'Now insert an SEUser';

                INSERT  dbo.SEUser
                        ( ASPNetUserID ,
                          FirstName ,
                          LastName ,
                          EmailAddress ,
                          HasMultipleBuildings ,
                          Username ,
                          loweredUsername ,
						  CertificateNumber
                        )
                VALUES  ( @NetUserID ,
                          @pFirstName ,
                          @pLastName ,
                          @pEMail ,
                          @pHasMultipleLocations ,
                          @pUserName ,
                          LOWER(@pUserName) ,
						  @pCertNo
                        );
                SELECT  @SEUserId = SCOPE_IDENTITY();

            END;

        ELSE
            BEGIN

                SELECT  @sql_error_message = 'Updating SEUser parameters';

                UPDATE  SEUser
                SET     FirstName = @pFirstName ,
                        LastName = @pLastName ,
                        EmailAddress = @pEMail ,
                        HasMultipleBuildings = @pHasMultipleLocations ,
                        Username = @pUserName ,
                        loweredUsername = LOWER(@pUserName) ,
						CertificateNumber = @pCertNo
				WHERE SEUserId = @SEUserId

                SELECT  @sql_error_message = 'Update email in aspnet_membership';

                UPDATE  aspnet_Membership
                SET     Email = @pEMail
                FROM    aspnet_Membership m
                        JOIN dbo.aspnet_Users u ON u.UserId = m.UserId
				WHERE Username = @pUserName
            END;


        SELECT  @pSEUserIdOutput = @SEUserId;

        IF ( @tran_count = 0 )
            AND ( @@TRANCOUNT = 1 )
            BEGIN
                COMMIT TRANSACTION;
            END;
    END TRY
    
	
    BEGIN CATCH
        SELECT  @sql_error_message = 'LineNumber... '
                + CONVERT(VARCHAR(20), ERROR_LINE()) + ' of '
                + ERROR_PROCEDURE() + ' >>> ' + @sql_error_message + +' ... "'
                + ERROR_MESSAGE() + '"<<<';


        IF ( ( @tran_count = 0 )
             AND ( @@TRANCOUNT <> 0 )
           )
            ROLLBACK TRANSACTION;
        RAISERROR(@sql_error_message, 15, 10);

   
    END CATCH;