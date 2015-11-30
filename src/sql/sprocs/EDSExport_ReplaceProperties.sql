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
CREATE PROCEDURE EDSExport_ReplaceProperties
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

------------------
-- TRAN CONTROL --
------------------
    IF @tran_count = 0
        BEGIN TRANSACTION;

/***********************************************************************************/
    BEGIN

	/* uds
		ulr
		seuser
		aspnet_membership.email*/
       
        DELETE  dbo.SEUserDistrictSchool
        WHERE   SEUserID IN (
                SELECT  seu.SEUserID
                FROM    EDSStaging sta
                        JOIN SEUser seu ON seu.Username = CONVERT(VARCHAR(20), sta.personID)
                                           + '_edsUser' );
               
        SELECT  @sql_error = @@ERROR;
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Problem deleting UDS'; 
                GOTO ErrorHandler;
            END; 
		
        DELETE  dbo.SEUserLocationRole
        WHERE   seUserId IN (
                SELECT  SEUserId
				FROM seUser u
				JOIN aspnet_Users au ON au.userid =u.ASPNetUserID
				JOIN dbo.EDSStaging s ON au.userId = CONVERT(VARCHAR(20), s.personID) + '_edsUser'
                );
		
        SELECT  @sql_error = @@ERROR;
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Problem deleting lrc'; 
                GOTO ErrorHandler;
            END; 
   
        INSERT  dbo.SEUserDistrictSchool
                ( SEUserID ,
                  SchoolCode ,
                  DistrictCode ,
                  IsPrimary
                    
                )
                SELECT DISTINCT
                        seu.SEUserID ,
                        ISNULL(sta.schoolCode, '') ,
                        sta.districtCode ,
                        firstEntry
                FROM    EDSStaging sta
                        JOIN SEUser seu ON seu.Username = CONVERT(VARCHAR(20), sta.personID)
                                           + '_edsUser';

          
        SELECT  @sql_error = @@ERROR;
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Problem inserting UDS'; 
                GOTO ErrorHandler;
            END; 
            
        
		
        UPDATE  SEUserDistrictSchool
        SET     SchoolName = ds.districtSchoolName
        FROM    SEUserDistrictSchool uds
                JOIN SEDistrictSchool ds ON ds.schoolCode = uds.SchoolCode
        WHERE   uds.SchoolCode <> '';

        SELECT  @sql_error = @@ERROR;
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Problem with SeUserDistrictSchool hydrate school name. In: '
                        + @ProcName + ' >>>' + ISNULL(@sql_error_message, '');
                GOTO ErrorHandler;
            END;

        UPDATE  SEUserDistrictSchool
        SET     DistrictName = x.districtSchoolName
        FROM    SEUserDistrictSchool uds
                JOIN SEDistrictSchool x ON x.districtCode = uds.DistrictCode;
    --WHERE   SEUserID = @UserID;



        SELECT  @sql_error = @@ERROR;
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Problem with SeUserDistrictSchool hydrate districtme. In: '
                        + @ProcName + ' >>>' + ISNULL(@sql_error_message, '');
                GOTO ErrorHandler;
            END;
		    
        INSERT  dbo.LocationRoleClaim
                ( userName ,
                  Location ,
                  LocationCode ,
                  RoleString
		        )
                SELECT  seu.Username ,
                        locationName ,
                        locationCode ,
                        roleString
                FROM    EDSStaging sta
                        JOIN SEUser seu ON seu.Username = CONVERT(VARCHAR(20), sta.personID)
                                           + '_edsUser';

        SELECT  @sql_error = @@ERROR;
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Problem inserting LRC'; 
                GOTO ErrorHandler;
            END;             


        UPDATE  dbo.SEUser
        SET     FirstName = eu.FirstName ,
                LastName = eu.LastName ,
                DistrictCode = st.districtCode ,
                SchoolCode = ISNULL(st.schoolCode, '') ,
                LoginName = eu.LoginName ,
                EmailAddressAlternate = eu.EmailAddressAlternate ,
                CertificateNumber = eu.CertificateNumber
        FROM    dbo.EDSStaging st
                JOIN dbo.SEUser u ON u.Username = CONVERT(VARCHAR(20), st.personID)
                                     + '_edsUser'
                JOIN dbo.vEDSUsers eu ON eu.PersonId = st.personID
        WHERE   st.firstEntry = 1;
		
        SELECT  @sql_error = @@ERROR;
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Problem updating user name, location'; 
                GOTO ErrorHandler;
            END; 
            
       
       
            
        UPDATE  dbo.aspnet_Membership
        SET     Email = eu.Email
        FROM    aspnet_Membership m
                JOIN aspnet_Users u ON u.UserId = m.UserId
                JOIN dbo.vEDSUsers eu ON u.UserName = CONVERT(VARCHAR(20), eu.PersonId)
                                         + '_edsUser';
		
        SELECT  @sql_error = @@ERROR;
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Problem updating user email'; 
                GOTO ErrorHandler;
            END; 
            
        UPDATE  dbo.SEUser
        SET     HasMultipleBuildings = CASE WHEN X.nLocations > 1 THEN 1
                                            ELSE 0
                                       END
        FROM    dbo.SEUser su
                JOIN ( SELECT   COUNT(PersonId) AS nLocations ,
                                PersonId
                       FROM     vEDSroles
                       GROUP BY PersonId
                     ) X ON CONVERT(VARCHAR(20), X.PersonId) + '_edsUser' = su.Username;

        SELECT  @sql_error = @@ERROR;
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Problem updating seuser hasMultiple buildings'; 
                GOTO ErrorHandler;
            END;             



       /******************-- now have to get the person's roles from the semi-colon delimited role string        */



        CREATE TABLE #multis
            (
              personId BIGINT ,
              remaining VARCHAR(3000) ,
              leftPart VARCHAR(300)			--as in 'the part that is to the left'
            );
        CREATE TABLE #userNameClaims
            (
              personId BIGINT ,
              seRoleName VARCHAR(300) ,
            );

		-- all the easy ones first 
        INSERT  #userNameClaims
                ( personId ,
                  seRoleName
                )
                SELECT  personID ,
                        REPLACE(roleString, ' ', '')
                FROM    dbo.EDSStaging
                WHERE   firstEntry = 1
                        AND roleString NOT LIKE '%;%';
                        

		-- now process multi location users
        INSERT  #multis
                ( personId ,
                  remaining
                )
                SELECT  personID ,
                        REPLACE(roleString, ' ', '')
                FROM    dbo.EDSStaging
                WHERE   firstEntry = 1
                        AND roleString LIKE '%;%';
                       
        
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
                        ( personId ,
                          seRoleName
                        )
                        SELECT  personId ,
                                leftPart
                        FROM    #multis;

		--... reset 'remaining'; pick up any that cant' be processed anymore
                UPDATE  #multis
                SET     remaining = SUBSTRING(remaining,
                                              CHARINDEX(';', remaining) + 1,
                                              5000)
                FROM    #multis;
                INSERT  #userNameClaims
                        ( personId ,
                          seRoleName
                        )
                        SELECT  personId ,
                                remaining
                        FROM    #multis
                        WHERE   remaining NOT LIKE '%;%';

		--... remove spent records; reset 'leftpart'
                DELETE  #multis
                WHERE   remaining NOT LIKE '%;%';
                UPDATE  #multis
                SET     leftPart = '';

            END;
    
		
    
    
        /*have a personid, and a role Id; have to update seUserlocationRole*/
   
        SELECT  @sql_error = @@ERROR;
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Problem inserting new base roles'; 
                GOTO ErrorHandler;
            END; 
	    
	
    END;
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
                    ROLLBACK TRANSACTION;
                END;


            SELECT  @sql_error_message = '.... In: ' + @ProcName + '. '
                    + CONVERT(VARCHAR(20), @sql_error) + '>>>'
                    + ISNULL(@sql_error_message, '') + '<<<  ';

            RAISERROR(@sql_error_message, 15, 10);
        END;

----------------------
-- End of Procedure --
----------------------
    ProcEnd:

    IF ( @tran_count = 0 )
        AND ( @@TRANCOUNT = 1 )
        BEGIN
            COMMIT TRANSACTION;
        END;

    RETURN(@sql_error);

