
/***********************************************************************************/
DECLARE @sql_error INT ,
    @tran_count INT ,
    @sql_error_message NVARCHAR(500) ,
    @prevVersion BIGINT;
DECLARE @BugFixed BIGINT ,
    @title VARCHAR(100) ,
    @comment VARCHAR(400) ,
    @ahora DATETIME;
SELECT  @ahora = GETDATE() ,
        @sql_error = 0 ,
        @tran_count = @@TRANCOUNT; 
IF @tran_count = 0
    BEGIN TRANSACTION;
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/*  Notes...
	a) update the @bugFixed, @dependsOnBug (if necessary) title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/

SELECT  @BugFixed = 103871758 ,
        @title = '103871758_RepairMissingEvaluationRecords' ,
        @comment = '';


DECLARE @dependsOnBug INT ,
    @dependsOnBug2 INT;
SET @dependsOnBug = 2461;
SET @dependsOnBug2 = 2461;


/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/

IF EXISTS ( SELECT  bugNumber
            FROM    dbo.updateLog
            WHERE   bugNumber = @BugFixed )
    BEGIN
        SELECT  @sql_error = -1 ,
                @sql_error_message = 'Error: fix for bugNumber #'
                + CONVERT(VARCHAR(20), @BugFixed)
                + ' has already been applied';
        GOTO ProcEnd;
    END;

IF NOT EXISTS ( SELECT  bugNumber
                FROM    UpdateLog
                WHERE   bugNumber = @dependsOnBug )
    BEGIN
        SELECT  @sql_error = -1 ,
                @sql_error_message = 'Fail Bug patch : '
                + CONVERT(VARCHAR(20), @BugFixed)
                + ' DEPENDS ON BUG NOT APPLIED: '
                + CAST(@dependsOnBug AS VARCHAR(10)) + ' >>>'
                + ISNULL(@sql_error_message, '');
        GOTO ErrorHandler;
    END;

IF NOT EXISTS ( SELECT  bugNumber
                FROM    UpdateLog
                WHERE   bugNumber = @dependsOnBug2 )
    BEGIN
        SELECT  @sql_error = -1 ,
                @sql_error_message = 'Fail Bug patch : '
                + CONVERT(VARCHAR(20), @BugFixed)
                + ' DEPENDS ON BUG NOT APPLIED: '
                + CAST(@dependsOnBug2 AS VARCHAR(10)) + ' >>>'
                + ISNULL(@sql_error_message, '');
        GOTO ErrorHandler;
    END;

INSERT  dbo.UpdateLog
        ( bugNumber ,
          UpdateName ,
          TimeStamp ,
          comment
        )
VALUES  ( @BugFixed ,
          @title ,
          @ahora ,
          @comment
        );
SELECT  @sql_error = @@ERROR;
IF @sql_error <> 0
    BEGIN
        SELECT  @sql_error_message = 'insert log entry failed'; 

        GOTO ErrorHandler;
    END;


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

CREATE TABLE #cmdBlock
    (
      cIndex INT IDENTITY(1, 1) ,
      sqlCmd VARCHAR(500)
    );

INSERT  #cmdBlock
        ( sqlCmd
        )
        SELECT  DISTINCT
                'declare @sql_error_message varchar(500)   exec dbo.InsertEvaluation @pEvaluationTypeID=1, @pSchoolYear=NULL, @pDistrictCode='''
                + DistrictCode
                + ''', @sql_error_message=@sql_error_message OUTPUT'
        FROM    seDistrictSchool;


INSERT  #cmdBlock
        ( sqlCmd
        )
        SELECT  DISTINCT
                'declare @sql_error_message varchar(500)   exec dbo.InsertEvaluation @pEvaluationTypeID=2, @pSchoolYear=NULL, @pDistrictCode='''
                + DistrictCode
                + ''', @sql_error_message=@sql_error_message OUTPUT'
        FROM    seDistrictSchool;
		-- select * from #cmdBlock
	           
		--loop through the command block
DECLARE @idx BIGINT ,
    @cmd VARCHAR(5000);
SELECT  @idx = MIN(cIndex)
FROM    #cmdBlock;
WHILE @idx IS NOT NULL
    BEGIN
                          
                
        SELECT  @cmd = sqlCmd
        FROM    #cmdBlock
        WHERE   cIndex = @idx
                AND sqlCmd IS NOT NULL;	
		
        EXEC (@cmd);
                
        SELECT  @sql_error = @@ERROR;
        IF @sql_error <> 0
            BEGIN
                SELECT  @sql_error_message = 'Problem in insertEval loop... cmd... '
                        + @cmd; 
                GOTO ErrorHandler;
            END; 
              
        SELECT  @idx = MIN(cIndex)
        FROM    #cmdBlock
        WHERE   cIndex > @idx
                AND sqlCmd IS NOT NULL;
    END;
		
	    



/***** ^^^^                  ^^^^^^ ************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
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


        SELECT  @sql_error_message = CONVERT(VARCHAR(20), @sql_error)
                + 'Patch Error!!!>>>' + ISNULL(@sql_error_message, '');

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

GO
