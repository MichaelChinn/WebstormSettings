IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.FlushFramework')
                    AND sysstat & 0xf = 4 ) 
    BEGIN
        PRINT '.. Dropping sproc FlushFramework.'
        DROP PROCEDURE dbo.FlushFramework
    END
GO
PRINT '.. Creating sproc FlushFramework.'
GO
CREATE PROCEDURE FlushFramework
    @pDistrictCode VARCHAR(10) ,
    @pEvalType VARCHAR(20) ,
    @pSchoolYear INT ,
    @pDebug SMALLINT = 0
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
	
		/***** USE THIS ONE!!!! ******
		this is the one that is to be used... ignore all other flush* sprocs
	drop table #fw
	drop table #nodes
	drop table #rr
	*/
	/*
	declare @pDistrictCode varchar (20), @pTeetype varchar(20)
	select @pDistrictCode = '22017', @pTeeType = 'principal'
*/
        DECLARE @IsPrincipalEval BIT ,
            @evalType INT
        SELECT  @IsPrincipalEval = CASE WHEN @pEvalType = 'TEACHER' THEN 0
                                        ELSE 1
                                   END ,
                @evalType = CASE WHEN @pEvalType = 'Teacher' THEN 2
                                 ELSE 1
                            END
	
        CREATE TABLE #fw ( frameworkId BIGINT )
        INSERT  #fw
                ( frameworkId
                )
                SELECT  frameworkID
                FROM    SEFramework fw
                        JOIN SEFrameworkType ft ON ft.FrameworkTypeID = fw.FrameworkTypeID
                WHERE   DistrictCode = @pDistrictCode
                        AND ft.IsPrincipalEval = @IsPrincipalEval
                        AND fw.SchoolYear = @pSchoolYear

        DELETE  SEDistrictConfiguration
        WHERE   DistrictCode = @pDistrictCode
                AND EvaluationTypeID = @evalType
                AND schoolyear = @pSchoolYear
	
        DELETE  seSchoolConfiguration
        WHERE   DistrictCode = @pDistrictCode
                AND SchoolYear = @pSchoolYear
        DELETE  seFrameworkPerformanceLevel
        WHERE   frameworkId IN ( SELECT frameworkID
                                 FROM   #fw )
 
        CREATE TABLE #nodes
            (
              frameworkNodeID BIGINT
            )
        INSERT  #nodes
                ( frameworKNodeid
                )
                SELECT  frameworkNodeID
                FROM    SEFrameworkNode fn
                        JOIN #fw f ON f.FrameworkID = fn.FrameworkID

        CREATE TABLE #rr ( rubricRowID BIGINT )
        INSERT  #rr
                ( rubricRowID
                )
                SELECT  rubricRowID
                FROM    SERubricRowFrameworkNode rrfn
                        JOIN #nodes n ON n.frameworkNodeID = rrfn.FrameworkNodeID
	
        IF ( @pDebug = 1 ) 
            BEGIN
                SELECT  'fw' ,
                        frameworkId
                FROM    #fw
                ORDER BY frameworkID
                SELECT  'fwn' ,
                        frameworknodeID
                FROM    #nodes
                ORDER BY frameworkNodeID
                SELECT  'rr' ,
                        rubricRowID
                FROM    #rr
                ORDER BY rubricRowID
            END

	--added 10/26 when i couldn't remove 22207's framework choice
        DELETE  dbo.SEUserPromptRubricRowAlignment
        WHERE   RubricRowID IN ( SELECT RubricRowID
                                 FROM   #rr )


	--break the link between rr & fn
        DELETE  SERubricRowFrameworkNode
        WHERE   FrameworkNodeID IN ( SELECT FrameworkNodeid
                                     FROM   #nodes )


	--finally...
        DELETE  SERubricRow
        WHERE   RubricRowID IN ( SELECT RubricRowID
                                 FROM   #rr )
        DELETE  SEFrameworkNode
        WHERE   FrameworkNodeID IN ( SELECT FrameworkNodeID
                                     FROM   #nodes )
        DELETE  SEFramework
        WHERE   FrameworkID IN ( SELECT FrameworkID
                                 FROM   #fw )


        SELECT  @sql_error = @@ERROR
        IF @sql_error <> 0 
            BEGIN
                SELECT  @sql_error_message = 'Problem' 

                GOTO ErrorHandler
            END


/*check these!!!
	SELECT * FROM dbo.SEPullQuote pq JOIN #nodes n ON n.frameworkNodeID = pq.FrameworkNodeID
	SELECT * FROM dbo.seFrameworkNodeScore fns JOIN #nodes n ON n.frameworkNodeID = fns.FrameworkNodeID
	SELECT * FROM dbo.SERubricRowAnnotation rra JOIN #rr rr ON rr.rubricRowID = rra.RubricRowID
	SELECT * FROM dbo.seRubricRowScore rrs JOIN #rr rr ON rr.rubricRowID = rrs.RubricRowID
	SELECT * FROM dbo.SESummativeFrameworkNodeScore sfns JOIN #nodes n ON n.frameworkNodeID = sfns.FrameworkNodeID
	SELECT * FROM dbo.SESummativeRubricRowScore srrs JOIN #rr rr ON rr.rubricRowID = srrs.RubricRowID
	SELECT * FROM dbo.SEArtifact a
		JOIN dbo.SEArtifactFrameworkNodeAlignment afna ON afna.ArtifactID = a.ArtifactID
		JOIN #nodes n ON n.frameworkNodeID = afna.FrameworkNodeID
	SELECT * FROM dbo.SEArtifact a
		JOIN dbo.SEArtifactRubricRowAlignment arra ON arra.ArtifactID = a.ArtifactID
		JOIN #rr rr ON rr.rubricRowID = arra.RubricRowID
		
	SELECT * FROM dbo.SEEvalSession WHERE districtcode = @pDistrictCode and schoolyear = @pSchoolYear

*/

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
                    + ' ... parameters...' + ' @pDistrictCode ='
                    + @pDistrictCode + ' @pEvalType ='
                    + CONVERT(VARCHAR(10), @pEvalType) + ' @pSchoolYear ='
                    + CONVERT(VARCHAR(10), @pSchoolYear) + '<<<  '



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

GO

