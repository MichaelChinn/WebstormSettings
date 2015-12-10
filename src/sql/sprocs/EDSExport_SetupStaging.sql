IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.EDSExport_SetupStaging')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc EDSExport_SetupStaging.';
        DROP PROCEDURE dbo.EDSExport_SetupStaging;
    END;
GO
PRINT '.. Creating sproc EDSExport_SetupStaging.';
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE EDSExport_SetupStaging
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
      
		/**************************************************************************************************************/
        /*need a staging table to handle adds, modifies..      
            drop table edsstaging
            
        CREATE TABLE EDSStaging
            (
              stagingId BIGINT IDENTITY(1, 1) ,
              personID BIGINT,
              locationCode VARCHAR(20) ,
              locationName VARCHAR(200) ,
              roleString VARCHAR(6000) ,
              districtCode VARCHAR(10) ,
              schoolCode VARCHAR(10) ,
              seEvaluationTypeID SMALLINT ,
              cAspnetUsers VARCHAR(200) ,
              cAspnetUIR VARCHAR(200) ,
              cInsertEval VARCHAR(200) ,
              isNew BIT ,
              firstEntry BIT
            )*/     
        TRUNCATE TABLE EDSStaging;

        INSERT  EDSStaging
                ( personID ,
                  locationCode ,
                  roleString ,
                  rawRoleString ,
                  isNew ,
                  firstEntry ,
                  PrevousPersonId
                )
                SELECT  DISTINCT
                        eu.personId ,
                        OSPILegacyCode ,
                        OrganizationRoleName ,
                        OrganizationRoleName ,
                        0 ,
                        0 ,
                        PreviousPersonId
                FROM    vedsUsers eu
                        JOIN vedsRoles er ON er.PersonId = eu.PersonId;   
           
         
		--translate roles here using string substitution ***********************************
		/*
		--was going to use a table to do this, but have to do this here so that we can eliminate duplicate Prin- and Teach- evaluator roles
		insert #rx(edsRoleName, eValRoleName) values ('eValSuperAdmin'               ,  'SESuperAdmin'                            )
		insert #rx(edsRoleName, eValRoleName) values ('eValStateAdmin'               ,  'SEStateAdmin'                            )
		
		insert #rx(edsRoleName, eValRoleName) values ('eValDistrictAdmin'            ,  'SEDistrictAdmin'                         )
		insert #rx(edsRoleName, eValRoleName) values ('eValDistrictEvaluator'        ,  'SEDistrictEvaluator')
		insert #rx(edsRoleName, eValRoleName) values ('eValDistrictTeacherEvaluator' ,  'SEDistrictWideTeacherEvaluator'                      )
	    
		insert #rx(edsRoleName, eValRoleName) values ('eValSchoolAdmin'              ,  'SESchoolAdmin'                           )
		insert #rx(edsRoleName, eValRoleName) values ('eValSchoolPrincipal'          ,  'SESchoolPrincipal'    )
		insert #rx(edsRoleName, eValRoleName) values ('eValHeadPrincipal'            ,  'SESchoolHeadPrincipal'  )
		
		insert #rx(edsRoleName, eValRoleName) values ('eValSchoolTeacher'            ,  'SESchoolTeacher'                         )
		insert #rx(edsRoleName, eValRoleName) values ('eValDistrictViewer'            ,  'SEDistrictViewer'                         )
		insert #rx(edsRoleName, eValRoleName) values ('eValDistrictAssignmentManager'            ,  'SEDistrictAssignmentManager'                         )

		*/
        UPDATE  EDSStaging
        SET     roleString = REPLACE(roleString, 'eValDistrictAdmin',
                                     'SEDistrictAdmin');
        UPDATE  EDSStaging
        SET     roleString = REPLACE(roleString, 'eValDistrictEvaluator',
                                     'SEDistrictEvaluator');
        UPDATE  EDSStaging
        SET     roleString = REPLACE(roleString,
                                     'eValDistrictTeacherEvaluator',
                                     'SEDistrictWideTeacherEvaluator');

		UPDATE  EDSStaging
        SET     roleString = REPLACE(roleString, 'eValSchoolLibrarian',
                                     'SESchoolLibrarian');

        UPDATE  EDSStaging
        SET     roleString = REPLACE(roleString, 'eValSchoolAdmin',
                                     'SESchoolAdmin');
        UPDATE  EDSStaging
        SET     roleString = REPLACE(roleString, 'eValSchoolPrincipal',
                                     'SESchoolPrincipal');
        UPDATE  EDSStaging
        SET     roleString = REPLACE(roleString, 'eValHeadPrincipal',
                                     'SESchoolHeadPrincipal');

		--add SchoolPrincipal role to all head principals; note that Replace properties does
		--a 'select distinct' when inserting the roles, so we can just stuff the input string
		--as much as we want and we should still get only a unique set of roles.
		UPDATE  dbo.EDSStaging
		SET		roleString = Replace (roleString, 'SESchoolHeadPrincipal', 'SESchoolPrincipal,SESchoolHeadPrincipal')


		
        UPDATE  EDSStaging
        SET     roleString = REPLACE(roleString, 'eValSchoolTeacher',
                                     'SESchoolTeacher');
        UPDATE  EDSStaging
        SET     roleString = REPLACE(roleString, 'eValDistrictViewer',
                                     'SEDistrictViewer');
        UPDATE  EDSStaging
        SET     roleString = REPLACE(roleString,
                                     'eValDistrictAssignmentManager',
                                     'SEDistrictAssignmentManager');


        UPDATE  EDSStaging
        SET     roleString = REPLACE(roleString, ',', ';');

        UPDATE  EDSStaging
        SET     locationName = sn.SchoolName ,
                schoolCode = sn.schoolCode ,
                districtCode = sn.districtCode
        FROM    EDSStaging ta
                JOIN vSchoolName sn ON sn.schoolCode = ta.locationCode;
         
        UPDATE  EDSStaging
        SET     locationName = dn.DistrictName ,
                districtCode = dn.districtCode
        FROM    EDSStaging ta
                JOIN vDistrictName dn ON dn.districtCode = ta.locationCode;
                
        UPDATE  EDSStaging
        SET     seEvaluationTypeID = CASE WHEN rolestring LIKE '%seSchoolTeacher%'
                                          THEN 2
                                          WHEN rolestring LIKE '%seSchoolPrincipal%'
                                          THEN 1
                                          ELSE NULL
                                     END;

        UPDATE  EDSStaging
        SET     isNew = 1
        WHERE   CONVERT(VARCHAR(20), personId) + '_edsUser' NOT IN ( SELECT
                                                              userName
                                                              FROM
                                                              dbo.aspnet_users ); 
        
        UPDATE  EDSStaging
        SET     FirstEntry = 1  --used so we don't insert multiple records in aspnet and seUser tables
        FROM    EDSStaging s1
                JOIN ( SELECT   MIN(stagingId) AS FirstID ,
                                personId
                       FROM     EDSStaging
                       GROUP BY personId
                     ) AS s2 ON s2.FirstID = s1.stagingId; 

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

