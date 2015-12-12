IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.InsertEDSFormattedRoleClaims')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc InsertEDSFormattedRoleClaims.';
        DROP PROCEDURE dbo.InsertEDSFormattedRoleClaims;
    END;
GO
PRINT '.. Creating sproc InsertEDSFormattedRoleClaims.';
GO

SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE InsertEDSFormattedRoleClaims
    @pUserName VARCHAR(300) ,
    @pAllLocationsString VARCHAR(MAX) ,
    @pAllRoleString VARCHAR(MAX) ,
    @pDebug INT = 0
AS
    SET NOCOUNT ON; 

 ---------------
-- VARIABLES --
---------------
    DECLARE @tran_count INT ,
        @sql_error_message NVARCHAR(1500);

    SELECT  @tran_count = @@TRANCOUNT;


/************************************************************************/

		/*
			this sproc saves all the users roles, and all his locations.
			
			want to coalesce all the users roles in all locations so,
			what we have to do now is to expect that the c# will cat
			all the roles for the user across all his locations; then we'll
			just remove all the roles he has now, and insert the ones passed in

			the old way of calling the the sproc once for each location doesn't 
			work, because in that case, we can only add roles for fear of removing
			one we shouldn't.

			but in *that* case, we might get a role we *want* to remove, but *can't'
		*/

    DECLARE @xml XML ,
        @userId UNIQUEIDENTIFIER ,
        @seUserid BIGINT;

		--what's the user id?
    SELECT  @userId = ASPNetUserID ,
            @seUserid = SEUserID
    FROM    SEUser
    WHERE   Username = @pUserName;

	--setup; process the temp tables first to decrease time needed in the transaction
	-- bust out roles, districts, schools from csv to temp tables

    CREATE TABLE #locations
        (
          districtSchoolString VARCHAR(20) ,
          districtCode VARCHAR(10) ,
          schoolCode VARCHAR(10)
        );
    SET @xml = N'<root><r>' + REPLACE(@pAllLocationsString, ';', '</r><r>')
        + '</r></root>';
    INSERT  #locations
            ( districtSchoolString
            )
            SELECT  t.value('.', 'varchar(max)') AS [delimited items]
            FROM    @xml.nodes('//root/r') AS a ( t );

    UPDATE  #locations
    SET     districtCode = SUBSTRING(districtSchoolString, 1,
                                     CHARINDEX('|', districtSchoolString) - 1);
    UPDATE  #locations
    SET     schoolCode = SUBSTRING(districtSchoolString,
                                   CHARINDEX('|', districtSchoolString) + 1,
                                   50);

    CREATE TABLE #roles ( roleName VARCHAR(50) );
    SET @xml = N'<root><r>' + REPLACE(@pAllRoleString, ';', '</r><r>')
        + '</r></root>';
    INSERT  #roles
            ( roleName
            )
            SELECT  t.value('.', 'varchar(max)') AS [delimited items]
            FROM    @xml.nodes('//root/r') AS a ( t );


	--might as well grab nLocations now as well...

    DECLARE @nLocations INT ,
        @hasMultipleLocations BIT ,
        @nSchools INT ,
        @nDistricts INT;

    SELECT  @nLocations = COUNT(*)
    FROM    ( SELECT DISTINCT
                        *
              FROM      #locations
            ) x;

    IF @nLocations > 1
        SELECT  @hasMultipleLocations = 1;
    ELSE
        SELECT  @hasMultipleLocations = 0;



		
    IF @tran_count = 0
        BEGIN TRANSACTION;
    BEGIN TRY

        ---- deal with the locations first...
        SELECT  @sql_error_message = 'removing current schools and districts of the user';
        DELETE  dbo.SEUserDistrictSchool
        WHERE   SEUserID = @seUserid; 

		-----
        SELECT  @sql_error_message = 'inserting requested districts and schools for user';
        INSERT  dbo.SEUserDistrictSchool
                ( SEUserID ,
                  SchoolCode ,
                  DistrictCode ,
				  IsPrimary
                )
                SELECT  DISTINCT
                        @seUserid ,
                        schoolCode ,
                        districtCode ,
						1
                FROM    #locations;
	
		-----
        SELECT  @sql_error_message = 'updating users for multiple buildings';
        UPDATE  SEUser
        SET     HasMultipleBuildings = @hasMultipleLocations
        WHERE   SEUserID = @seUserid;
           
		-----
        SELECT  @sql_error_message = 'removing current roles of the user';
        DELETE  dbo.aspnet_UsersInRoles
        WHERE   UserId = @userId; 

		-----
        SELECT  @sql_error_message = 'inserting requested roles for user';
        INSERT  dbo.aspnet_UsersInRoles
                ( UserId ,
                  RoleId
                )
                SELECT  DISTINCT
                        @userId ,
                        RoleId
                FROM    aspnet_Roles ar
                        JOIN #roles r ON r.roleName = ar.RoleName;



	/***********************************************************************/
    END TRY

    BEGIN CATCH

        SELECT  @sql_error_message = 'LineNumber... '
                + CONVERT(VARCHAR(20), ERROR_LINE()) + ' of '
                + ERROR_PROCEDURE() + '| UserName ... ' + @pUserName + '...'
                + ' >>> ' + @sql_error_message + +' ... "'
                + '| ERROR_MESSAGE: ' + ERROR_MESSAGE() + '| ErrorNumber: '
                + CONVERT(VARCHAR(20), ERROR_NUMBER()) + '| ErrorSeverity: '
                + CONVERT(VARCHAR(20), ERROR_SEVERITY()) + '| ErrorState: '
                + CONVERT(VARCHAR(20), ERROR_STATE()) + '"<<<';

        IF ( ( @tran_count = 0 )
             AND ( @@TRANCOUNT <> 0 )
           )
            BEGIN
                ROLLBACK TRANSACTION;
            END;

        RAISERROR(@sql_error_message, 15, 10);
   
    END CATCH;


    PROC_END:

    IF ( @tran_count = 0 )
        AND ( @@TRANCOUNT = 1 )
        BEGIN
            COMMIT TRANSACTION;
        END;

GO

