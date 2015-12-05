IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.EDSExport_ReplaceProperties')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc EDSExport_ReplaceProperties.';
        DROP PROCEDURE dbo.EDSExport_ReplaceProperties;
    END;
GO
PRINT '.. Creating sproc EDSExport_ReplaceProperties.';
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE EDSExport_ReplaceProperties @pDebug VARCHAR(20) = ''
AS
    SET NOCOUNT ON; 

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



/***********************************************************************************/
 
	/*  Check in SEUserLocationRole for need to flush  */

    BEGIN  --first, process the raw rolestring into separate records
        CREATE TABLE #multis
            (
              stagingId BIGINT ,
              remaining VARCHAR(3000) ,
              leftPart VARCHAR(300)			--as in 'the part that is to the left'
            );
        CREATE TABLE #userNameClaims
            (
              seRoleName VARCHAR(300) ,
              stagingId BIGINT
            );

			-- all the easy ones first 
        INSERT  #userNameClaims
                ( seRoleName ,
                  stagingId
                )
                SELECT  REPLACE(roleString, ' ', '') ,
                        stagingId
                FROM    dbo.EDSStaging
                WHERE   roleString NOT LIKE '%;%';
                        

			-- now process multi location users
        INSERT  #multis
                ( stagingId ,
                  remaining
                )
                SELECT  stagingId ,
                        REPLACE(roleString, ' ', '')
                FROM    dbo.EDSStaging
                WHERE   roleString LIKE '%;%';
                       
        
        DECLARE @nRows BIGINT ,
            @Cycles INT;
        SELECT  @nRows = COUNT(*) ,
                @Cycles = 0
        FROM    #multis;



        WHILE ( SELECT  COUNT(*)
                FROM    #multis
              ) > 0
            BEGIN
				--start a cycle
                UPDATE  #multis
                SET     leftPart = LEFT(remaining,
                                        CHARINDEX(';', remaining) - 1); 
					--... pick up the single claims found
                INSERT  #userNameClaims
                        ( seRoleName ,
                          stagingId
                        )
                        SELECT  leftPart ,
                                stagingId
                        FROM    #multis;

					--... reset 'remaining'; pick up any that cant' be processed anymore
                UPDATE  #multis
                SET     remaining = SUBSTRING(remaining,
                                              CHARINDEX(';', remaining) + 1,
                                              5000)
                FROM    #multis;
                INSERT  #userNameClaims
                        ( seRoleName ,
                          stagingId
                        )
                        SELECT  remaining ,
                                stagingId
                        FROM    #multis
                        WHERE   remaining NOT LIKE '%;%';

					--... remove spent records; reset 'leftpart'
                DELETE  #multis
                WHERE   remaining NOT LIKE '%;%';
                UPDATE  #multis
                SET     leftPart = '';

            END;
    
    END;

    IF @pDebug = 'EmitUserRoles'
        BEGIN
		--SELECT * FROM dbo.EDSStaging

            SELECT  seRoleName ,
                    districtCode ,
                    schoolCode ,
                    personID
            FROM    #userNameClaims unc
                    JOIN dbo.EDSStaging s ON s.stagingId = unc.stagingId;
        END;
	
		--now, do we need to flush the ULR?
    CREATE TABLE #ulrFlush
        (
          edsuserName VARCHAR(50)
        );

    INSERT  #ulrFlush
            ( edsuserName
            )
            SELECT  X.userName
            FROM    ( SELECT    CONVERT(VARCHAR(50), s.personID) + '_edsuser' AS userName ,
                                unc.seRoleName
                      FROM      #userNameClaims unc
                                JOIN dbo.EDSStaging s ON s.stagingId = unc.stagingId
                      EXCEPT
                      SELECT    UserName ,
                                RoleName
                      FROM      dbo.SEUserLocationRole
                    ) X;

    INSERT  #ulrFlush
            ( edsuserName
            )
            SELECT  X.UserName
            FROM    ( SELECT    UserName ,
                                RoleName
                      FROM      dbo.SEUserLocationRole
                      EXCEPT
                      SELECT    CONVERT(VARCHAR(50), s.personID) + '_edsuser' AS userName ,
                                unc.seRoleName
                      FROM      #userNameClaims unc
                                JOIN dbo.EDSStaging s ON s.stagingId = unc.stagingId
                    ) X;

		/******************************************************/
		/*  Check for change in the userProperties  */
    
    CREATE TABLE #userChange
        (
          EDSUserName VARCHAR(50)
        );
    INSERT  #userChange
            ( EDSUserName
            )
            SELECT  u.UserName
            FROM    aspnet_Users u
                    JOIN SEUser su ON su.ASPNetUserID = u.UserId
                    JOIN vEDSUsers eu ON CONVERT(VARCHAR(20), PersonId)
                                         + '_edsUser' = u.UserName
            WHERE   eu.FirstName <> su.FirstName
                    OR eu.LastName <> su.LastName
                    OR eu.CertificateNumber <> su.CertificateNumber
                    OR eu.Email <> su.EmailAddress
                    OR eu.EmailAddressAlternate <> su.EmailAddressAlternate
                    OR eu.LoginName <> su.LoginName;

------------------
-- TRAN CONTROL --
------------------
    IF @tran_count = 0
        BEGIN TRANSACTION;

    BEGIN TRY
        DELETE  dbo.SEUserLocationRole
        WHERE   SEUserId IN (
                SELECT  SEUserID
                FROM    dbo.EDSStaging stage
                        JOIN #ulrFlush f ON f.edsuserName = CONVERT(VARCHAR(50), personID)
                                            + '_edsUser'
                        JOIN aspnet_Users au ON au.UserName = f.edsuserName
                        JOIN SEUser su ON su.ASPNetUserID = au.UserId );

        INSERT  dbo.SEUserLocationRole
                ( SEUserId ,
                  UserName ,
                  RoleName ,
                  RoleId ,
                  DistrictCode ,
                  SchoolCode ,
                  LastActiveRole ,
                  CreateDate ,
				  DistrictName
                )
                SELECT  DISTINCT
                        su.SEUserID ,
                        au.UserName ,
                        unc.seRoleName ,
                        r.RoleId ,
                        stage.districtCode ,
                        ISNULL(stage.schoolCode, '') ,
                        NULL ,
                        GETDATE(),
						dn.DistrictName
                FROM    dbo.EDSStaging stage
                        JOIN #ulrFlush f ON f.edsuserName = CONVERT(VARCHAR(50), personID)
                                            + '_edsUser'
                        JOIN aspnet_Users au ON au.UserName = f.edsuserName
                        JOIN SEUser su ON su.ASPNetUserID = au.UserId
                        JOIN #userNameClaims unc ON unc.stagingId = stage.stagingId
                        JOIN aspnet_Roles r ON r.RoleName = unc.seRoleName 
						JOIN dbo.vDistrictName dn ON dn.districtCode = stage.districtCode

		UPDATE dbo.SEUserLocationRole SET schoolName = sn.schoolName
		FROM seUserlocationRole ulr
		JOIN vSchoolName sn ON sn.schoolCode = ulr.SchoolCode
		JOIN #ulrFlush f ON f.edsuserName = CONVERT(VARCHAR(50), personID)
                                            + '_edsUser'
		WHERE ulr.schoolCode IS NOT null

        UPDATE  dbo.SEUser
        SET     FirstName = eu.FirstName ,
                LastName = eu.LastName ,
                CertificateNumber = eu.CertificateNumber ,
                EmailAddress = eu.Email ,
                EmailAddressAlternate = eu.EmailAddressAlternate ,
                LoginName = eu.LoginName
        FROM    aspnet_Users u
                JOIN #userChange uc ON uc.EDSUserName = u.UserName
                JOIN SEUser su ON su.ASPNetUserID = u.UserId
                JOIN vEDSUsers eu ON CONVERT(VARCHAR(20), PersonId)
                                     + '_edsUser' = u.UserName;

        UPDATE  dbo.SEUser
        SET     SchoolCode = st.schoolCode ,
                DistrictCode = st.districtCode
        FROM    aspnet_Users u
                JOIN #userChange uc ON uc.EDSUserName = u.UserName
                JOIN SEUser su ON su.ASPNetUserID = u.UserId
                JOIN dbo.EDSStaging st ON CONVERT(VARCHAR(20), personID)
                                          + '_edsUser' = u.UserName;

        UPDATE  dbo.aspnet_Membership
        SET     Email = eu.Email
        FROM    aspnet_Users u
                JOIN #userChange uc ON uc.EDSUserName = u.UserName
                JOIN aspnet_Membership m ON m.UserId = u.UserId
                JOIN vEDSUsers eu ON CONVERT(VARCHAR(20), PersonId)
                                     + '_edsUser' = u.UserName;


        IF ( @tran_count = 0 )
            AND ( @@TRANCOUNT = 1 )
            BEGIN
                COMMIT TRANSACTION;
            END;

    END TRY
    

    BEGIN CATCH
        IF ( @tran_count = 0 )
            AND ( @@TRANCOUNT <> 0 )
            BEGIN
                ROLLBACK TRANSACTION;
            END;


        SELECT  @sql_error_message = '.... In: ' + @ProcName + '. '
                + CONVERT(VARCHAR(20), @sql_error) + '|'
                + 'At line no (less offset)... '
                + CONVERT(VARCHAR(20), ERROR_LINE()) + '>>>'
                + ISNULL(@sql_error_message, '') + '<<<  ';

        RAISERROR(@sql_error_message, 15, 10);

    END CATCH;
