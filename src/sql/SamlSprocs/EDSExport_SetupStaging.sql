IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.EDSExport_SetupStaging')
                    AND sysstat & 0xf = 4 ) 
    BEGIN
        PRINT '.. Dropping sproc EDSExport_SetupStaging.'
        DROP PROCEDURE dbo.EDSExport_SetupStaging
    END
GO
PRINT '.. Creating sproc EDSExport_SetupStaging.'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE EDSExport_SetupStaging
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
        TRUNCATE TABLE EDSStaging

        INSERT  EDSStaging
                ( personID ,
                  locationCode ,
                  roleString ,
                  rawRoleString ,
                  isNew , 
                  firstEntry ,
				  PrevousPersonId
                )
                SELECT  distinct eu.personId ,
                        OSPILegacyCode ,
                        OrganizationRoleName ,
                        OrganizationRoleName ,
                        0 ,
                        0 ,
						PreviousPersonId
                FROM    vedsUsers eu
                        JOIN vedsRoles er ON er.PersonId = eu.PersonId   
           
         
		--translate roles here using string substitution ***********************************
		/*  this is directly from CustomClaimsAuthMgr; ***ignore StateAdmin and SuperAdmin***

            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictAdmin)) _roleXlate.Add(EdsIdentity.RoleDistrictAdmin, UserRole.SEDistrictAdmin);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictEvaluator)) _roleXlate.Add(EdsIdentity.RoleDistrictEvaluator, UserRole.SEDistrictEvaluator);

            if (!_roleXlate.ContainsKey(EdsIdentity.RoleSchoolAdmin)) _roleXlate.Add(EdsIdentity.RoleSchoolAdmin, UserRole.SESchoolAdmin);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleSchoolPrincipal)) _roleXlate.Add(EdsIdentity.RoleSchoolPrincipal, UserRole.SESchoolPrincipal);

            if (!_roleXlate.ContainsKey(EdsIdentity.RoleSchoolTeacher)) _roleXlate.Add(EdsIdentity.RoleSchoolTeacher, UserRole.SESchoolTeacher);

            --if (!_roleXlate.ContainsKey(EdsIdentity.RoleStateAdmin)) _roleXlate.Add(EdsIdentity.RoleStateAdmin, UserRole.SEStateAdmin);
            --if (!_roleXlate.ContainsKey(EdsIdentity.RoleSuperAdmin)) _roleXlate.Add(EdsIdentity.RoleSuperAdmin, UserRole.SESuperAdmin);
            
			if (!_roleXlate.ContainsKey(EdsIdentity.RoleHeadPrincipal)) _roleXlate.Add(EdsIdentity.RoleHeadPrincipal, UserRole.SESchoolHeadPrincipal);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictTeacherEvaluator)) _roleXlate.Add(EdsIdentity.RoleDistrictTeacherEvaluator, UserRole.SEDistrictWideTeacherEvaluator);

            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictViewer)) _roleXlate.Add(EdsIdentity.RoleDistrictViewer, UserRole.SEDistrictViewer);
            if (!_roleXlate.ContainsKey(EdsIdentity.RoleDistrictAssignmentManager)) _roleXlate.Add(EdsIdentity.RoleDistrictAssignmentManager, UserRole.SEDistrictAssignmentManager);

	    */
 
		 UPDATE EDSStaging
		 SET    roleString = REPLACE(roleString, 'eValDistrictAdmin',
									 'SEDistrictAdmin');                   
		 UPDATE EDSStaging
		 SET    roleString = REPLACE(roleString, 'eValDistrictEvaluator',
									 'SEDistrictEvaluator');                 
		 UPDATE EDSStaging
		 SET    roleString = REPLACE(roleString, 'eValSchoolAdmin', 'SESchoolAdmin');                 
		 UPDATE EDSStaging
		 SET    roleString = REPLACE(roleString, 'eValSchoolPrincipal',
									 'SESchoolPrincipal');                 
		 UPDATE EDSStaging
		 SET    roleString = REPLACE(roleString, 'eValSchoolTeacher',
									 'SESchoolTeacher');                 
		 UPDATE EDSStaging
		 SET    roleString = REPLACE(roleString, 'eValHeadPrincipal',
									 'SESchoolHeadPrincipal');                 
		 UPDATE EDSStaging
		 SET    roleString = REPLACE(roleString, 'eValDistrictTeacherEvaluator',
									 'SEDistrictWideTeacherEvaluator');                 
		 UPDATE EDSStaging
		 SET    roleString = REPLACE(roleString, 'eValDistrictViewer',
									 'SEDistrictViewer');                 
		 UPDATE EDSStaging
		 SET    roleString = REPLACE(roleString, 'eValDistrictAssignmentManager',
									 'SEDistrictAssignmentManager');                 
                               

        UPDATE  EDSStaging
        SET     roleString = REPLACE(roleString, ',', ';')

        UPDATE  EDSStaging
        SET     locationName = sn.SchoolName ,
                schoolCode = sn.schoolCode ,
                districtCode = sn.districtCode
        FROM    EDSStaging ta
                JOIN vSchoolName sn ON sn.schoolCode = ta.locationCode
         
        UPDATE  EDSStaging
        SET     locationName = dn.DistrictName ,
                districtCode = dn.districtCode
        FROM    EDSStaging ta
                JOIN vDistrictName dn ON dn.districtCode = ta.locationCode
                
        UPDATE  EDSStaging
        SET     seEvaluationTypeID = CASE WHEN rolestring LIKE '%seSchoolTeacher%'
                                          THEN 2
                                          WHEN rolestring LIKE '%seSchoolPrincipal%'
                                          THEN 1
                                          ELSE NULL
                                     END

        UPDATE  EDSStaging
        SET     isNew = 1
        WHERE   CONVERT(VARCHAR(20), personId)+'_edsUser' NOT IN ( SELECT    userName
                                  FROM      dbo.aspnet_users ) 
        
        UPDATE  EDSStaging
        SET     FirstEntry = 1
        FROM    EDSStaging s1
                JOIN ( SELECT   MIN(stagingId) AS FirstID ,
                                personId
                       FROM     EDSStaging
                       GROUP BY personId
                     ) AS s2 ON s2.firstID = s1.stagingId 

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

