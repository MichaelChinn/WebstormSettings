IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.EDSExport_ReplaceProperties')
                    AND sysstat & 0xf = 4 ) 
    BEGIN
        PRINT '.. Dropping sproc EDSExport_ReplaceProperties.'
        DROP PROCEDURE dbo.EDSExport_ReplaceProperties
    END
GO
PRINT '.. Creating sproc EDSExport_ReplaceProperties.'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE EDSExport_ReplaceProperties
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
       
        DELETE  dbo.aspnet_UsersInRoles
        WHERE   userID IN (
                SELECT  seu.aspnetUserID
                FROM    EDSStaging sta
                        JOIN seUser seu ON seu.UserName = CONVERT(VARCHAR(20), sta.PersonID)
                                           + '_edsUser' )
                        
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem deleting usersInRoles' 
                GOTO ErrorHandler
            END 
		
        DELETE  dbo.SEUserDistrictSchool
        WHERE   SEUserID IN (
                SELECT  seu.seUserID
                FROM    EDSStaging sta
                        JOIN seUser seu ON seu.UserName = CONVERT(VARCHAR(20), sta.PersonID)
                                           + '_edsUser' )
               
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem deleting UDS' 
                GOTO ErrorHandler
            END 
		
        DELETE  dbo.locationRoleClaim
        WHERE   userName IN (
                SELECT  CONVERT(VARCHAR(20), Personid) + '_edsUser'
                FROM    EDSStaging )
		
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem deleting lrc' 
                GOTO ErrorHandler
            END 
   
        INSERT  dbo.SEUserDistrictSchool
                ( SEUserID ,
                  SchoolCode ,
                  DistrictCode ,
                  IsPrimary
                    
                )
                SELECT DISTINCT
                        seu.seUserId ,
                        ISNULL(sta.schoolCode, '') ,
                        sta.districtCode ,
                        firstEntry
                FROM    EDSStaging sta
                        JOIN seUser seu ON seu.UserName = CONVERT(VARCHAR(20), sta.PersonID)
                                           + '_edsUser'

          
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem inserting UDS' 
                GOTO ErrorHandler
            END 
            
        
		
		UPDATE  SEUserDistrictSchool
        SET     Schoolname = ds.districtSchoolName
        FROM    SEUserDistrictSchool uds
                JOIN SEDistrictSchool ds ON ds.schoolCode = uds.SchoolCode
        WHERE   uds.schoolcode <> ''

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
		    
        INSERT  dbo.locationRoleClaim
                ( UserName ,
                  Location ,
                  LocationCode ,
                  RoleString
		        )
                SELECT  seu.userName ,
                        locationName ,
                        locationCode ,
                        roleString
                FROM    EDSStaging sta
                        JOIN seUser seu ON seu.UserName = CONVERT(VARCHAR(20), sta.PersonID)
                                           + '_edsUser'

        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem inserting LRC' 
                GOTO ErrorHandler
            END             


        UPDATE  dbo.SEUser
        SET     FirstName = eu.FirstName ,
                lastName = eu.LastName ,
                DistrictCode = st.districtCode ,
                SchoolCode = ISNULL(st.schoolCode, '') ,
				loginName = eu.loginName ,
				EmailAddressAlternate = eu.EmailAddressAlternate ,
				CertificateNumber = eu.CertificateNumber

        FROM    dbo.EDSStaging st
                JOIN dbo.SEUser u ON u.Username = CONVERT(VARCHAR(20), st.PersonID)
                                     + '_edsUser'
                JOIN dbo.vEDSUsers eu ON eu.personID = st.personID
                WHERE st.firstEntry = 1
		
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem updating user name, location' 
                GOTO ErrorHandler
            END 
            
       
       
            
        UPDATE  dbo.aspnet_membership 
        SET     email = eu.Email
        FROM aspnet_membership m
        JOIN aspnet_users u ON u.userID = m.userId
        JOIN dbo.veDsUsers eu ON u.UserName = CONVERT(VARCHAR(20), eu.PersonID)
                                           + '_edsUser'
		
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem updating user email' 
                GOTO ErrorHandler
            END 
            
        UPDATE  dbo.SEUser
        SET     HasMultipleBuildings = CASE WHEN x.nLocations > 1 THEN 1
                                            ELSE 0
                                       END
        FROM    dbo.SEUser su
                JOIN ( SELECT   COUNT(personID) AS nLocations ,
                                personID
                       FROM     vedsRoles
                       GROUP BY personid
                     ) X ON CONVERT(VARCHAR(20), x.PersonID) + '_edsUser' = su.Username

        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem updating seuser hasMultiple buildings' 
                GOTO ErrorHandler
            END             



       /******************-- now have to get the person's roles from the semi-colon delimited role string        */

        CREATE TABLE #multis
            (
              personId BIGINT ,
              remaining VARCHAR(3000) ,
              leftPart VARCHAR(300)			--as in 'the part that is to the left'
            )
        CREATE TABLE #userNameClaims
            (
              personId BIGINT ,
              seRoleName VARCHAR(300) ,
            )

		-- all the easy ones first 
        INSERT  #userNameClaims
                ( personId ,
                  seRoleName
                )
                SELECT  personId ,
                        REPLACE(roleString, ' ', '')
                FROM    dbo.edsStaging
                WHERE   firstEntry = 1
                        AND roleString NOT LIKE '%;%'
                        

		-- now process multi location users
        INSERT  #multis
                ( personId ,
                  remaining
                )
                SELECT  personId ,
                        REPLACE(roleString, ' ', '')
                FROM    dbo.edsStaging
                WHERE   firstEntry = 1
                        AND rolestring LIKE '%;%'
                       
        
        DECLARE @nRows BIGINT ,
            @Cycles INT
        SELECT  @nRows = COUNT(*) ,
                @cycles = 0
        FROM    #multis



        WHILE ( SELECT  COUNT(*)
                FROM    #multis
              ) > 0 
            BEGIN
		--start a cycle
                UPDATE  #multis
                SET     leftPart = LEFT(remaining,
                                        CHARINDEX(';', remaining) - 1) 
		--... pick up the single claims found
                INSERT  #userNameClaims
                        ( personId ,
                          seRoleName
                        )
                        SELECT  personId ,
                                leftpart
                        FROM    #multis

		--... reset 'remaining'; pick up any that cant' be processed anymore
                UPDATE  #multis
                SET     remaining = SUBSTRING(remaining,
                                              CHARINDEX(';', remaining) + 1,
                                              5000)
                FROM    #multis
                INSERT  #userNameClaims
                        ( personId ,
                          seRoleName
                        )
                        SELECT  personId ,
                                remaining
                        FROM    #multis
                        WHERE   remaining NOT LIKE '%;%'

		--... remove spent records; reset 'leftpart'
                DELETE  #multis
                WHERE   remaining NOT LIKE '%;%'
                UPDATE  #multis
                SET     leftPart = ''

            END
    
		
    
    
        INSERT  aspnet_usersInroles
                ( userId ,
                  roleID
                )
                SELECT  DISTINCT
                        u.userId ,
                        r.roleId
                FROM    #userNameClaims unc
                        JOIN aspnet_users u ON u.userName = CONVERT(VARCHAR(20), unc.PersonId)
                                               + '_edsUser'
                        JOIN aspnet_roles r ON r.roleName = unc.seRoleName
                EXCEPT
                SELECT  userId ,
                        roleId
                FROM    aspnet_usersInRoles
   
        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem inserting new base roles' 
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

