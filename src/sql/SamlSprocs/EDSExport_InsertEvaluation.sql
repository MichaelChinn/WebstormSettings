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

		--InsertEvaluation is smart enough to only put in evaluation records for
		--those that need them.  I was trying to make it so that it only got called
		--for the districts that showed up as new in the extract every night; but that didn't
		--work because, sometimes, a user would show up who was already in the seUser table
		--but may have had their roles removed before for some reason or other.
		--
		--In this case, they would show up with a teacher role and need an seEvaluation record
		--but since they weren't marked as new, the sproc may not be called for that district
		--
		--so, i'm just going to call the sproc for all districts...

        CREATE TABLE #cmdBlock
            (
              cIndex INT IDENTITY(1, 1) ,
              sqlCmd VARCHAR(500)
            )

        INSERT  #cmdBlock
                ( sqlCmd
                )
                SELECT  DISTINCT
                        'declare @sql_error_message varchar(500)   exec dbo.InsertEvaluation '
                        + ' @pSchoolYear=NULL, @pDistrictCode='''
                        + npd.DistrictCode
                        + ''', @sql_error_message=@sql_error_message OUTPUT'
						+ ',@pEvaluationTypeID=1'
                FROM    vDistrictName npd

        INSERT  #cmdBlock
                ( sqlCmd
                )
                SELECT  DISTINCT
                        'declare @sql_error_message varchar(500)   exec dbo.InsertEvaluation '
                        + ' @pSchoolYear=NULL, @pDistrictCode='''
                        + npd.DistrictCode
                        + ''', @sql_error_message=@sql_error_message OUTPUT'
						+ ',@pEvaluationTypeID=2'
                FROM    vDistrictName npd

		--select * from #cmdBlock
	           
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

