IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.EDSExport_InsertEvaluation')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc EDSExport_InsertEvaluation.'
        DROP PROCEDURE dbo.EDSExport_InsertEvaluation
    END
GO
PRINT '.. Creating sproc EDSExport_InsertEvaluation.'
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE EDSExport_InsertEvaluation
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

		--first, figure out what all the right framework for the latest school years for all the districts
        CREATE TABLE #edsy
            (
              evaluationTypeid SMALLINT ,
              districtcode VARCHAR(10) ,
              schoolyear INT
            )
        INSERT  #edsy
                ( evaluationTypeid ,
                  districtcode ,
                  schoolYear
                )
                SELECT DISTINCT
                        evaluationTypeid ,
                        districtcode ,
                        MAX(schoolYear)
                FROM    seFramework
                WHERE   schoolYear > 2013
                GROUP BY districtcode ,
                        evaluationTypeid


		-- use that to create an exec of sproc InsertEvaluation for district
		-- that has folk who havent' got an SEEvaluation record
        CREATE TABLE #cmdBlock
            (
              cIndex INT IDENTITY(1, 1) ,
              sqlCmd VARCHAR(500)
            )

        INSERT  #cmdBlock
                ( sqlCmd
                )
                SELECT  DISTINCT
                        'declare @sql_error_message varchar(500)   exec dbo.InsertEvaluation @pEvaluationTypeID='
                        + CONVERT(VARCHAR(20), t.EvaluationTypeID)
                        + ', @pSchoolYear=NULL, @pDistrictCode='''
                        + t.DistrictCode
                        + ''', @sql_error_message=@sql_error_message OUTPUT'
                FROM    #edsy t
                        JOIN dbo.SEUser u ON t.DistrictCode = u.DistrictCode
                        JOIN dbo.aspnet_UsersInRoles ur ON u.ASPNetUserID = ur.UserId
                        JOIN dbo.aspnet_Roles r ON ur.RoleID = r.RoleID
                WHERE   u.SEUserID NOT IN (
                        SELECT  EvaluateeID
                        FROM    seEvaluation ev
                        WHERE   ev.DistrictCode = t.districtcode
                                AND ev.EvaluationTypeId = t.evaluationTypeid
                                AND t.schoolyear = ev.SchoolYear )
                        AND t.evaluationTypeid = CASE WHEN r.roleName = 'seschoolprincipal'
                                                      THEN 1
                                                      ELSE 2
                                                 END

		-- select * from #cmdBlock
	           
		--loop through the command block
        DECLARE @idx BIGINT ,
            @cmd VARCHAR(5000)
        SELECT  @idx = MIN(cindex)
        FROM    #cmdBlock
        WHILE @idx IS NOT NULL
            BEGIN
                          
                
                SELECT  @cmd = sqlCmd
                FROM    #cmdBlock
                WHERE   cindex = @idx
                        AND sqlCmd IS NOT NULL	
		
                EXEC (@cmd)
                
                SELECT  @sql_error = @@ERROR
                IF @sql_error <> 0
                    BEGIN
                        SELECT  @sql_error_message = 'Problem in insertEval loop... cmd... '
                                + @cmd 
                        GOTO ErrorHandler
                    END 
              
                SELECT  @idx = MIN(cIndex)
                FROM    #cmdBlock
                WHERE   cIndex > @idx
                        AND sqlCmd IS NOT NULL
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

