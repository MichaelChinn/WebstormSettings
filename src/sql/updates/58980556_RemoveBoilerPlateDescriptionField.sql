
/***********************************************************************************/
DECLARE @sql_error INT ,
    @tran_count INT ,
    @sql_error_message NVARCHAR(500) ,
    @prevVersion BIGINT
DECLARE @BugFixed BIGINT ,
    @title VARCHAR(100) ,
    @comment VARCHAR(400) ,
    @ahora DATETIME
SELECT  @ahora = GETDATE() ,
        @sql_error = 0 ,
        @tran_count = @@TRANCOUNT 
IF @tran_count = 0
    BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
SELECT  @bugFixed = 58980556 ,
        @title = '58980556_RemoveBoilerPlateDescriptionField, 3/28' ,
        @comment = ''
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/
/*  Notes...
	a) update the @bugFixed, title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version log), but the change won't be
        made again.
*/
IF EXISTS ( SELECT  bugNumber
            FROM    dbo.updateLog
            WHERE   bugNumber = @bugFixed )
    BEGIN
        SELECT  @sql_error_message = 'Error: fix for bugNumber #'
                + CONVERT(VARCHAR(20), @bugFixed)
                + ' has already been applied'
        GOTO ProcEnd
    END

INSERT  dbo.UpdateLog
        ( bugNumber ,
          UpdateName ,
          TimeStamp ,
          comment
        )
VALUES  ( @bugFixed ,
          @title ,
          @ahora ,
          @comment
        )
SELECT  @sql_error = @@ERROR
IF @sql_error <> 0
    BEGIN
        SELECT  @sql_error_message = 'insert log entry failed' 

        GOTO ErrorHandler
    END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

UPDATE  dbo.SERubricRow
SET     Description = ''
WHERE   RubricRowID IN (
        SELECT  distinct rr.rubricRowID
        FROM    serubricrow rr
                JOIN stateeval_proto.dbo.SERubricRow protoRR ON protoRR.Description = rr.description
                WHERE rr.description <> '' )

INSERT  dbo.UpdateLog
        ( bugNumber ,
          UpdateName ,
          TimeStamp ,
          comment
        )
VALUES  ( @bugFixed ,
          @title ,
          @ahora ,
          @comment
        )
        
SELECT  @sql_error = @@ERROR
IF @sql_error <> 0
    BEGIN
        SELECT  @sql_error_message = 'description removal failed' 

        GOTO ErrorHandler
    END

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
                ROLLBACK TRANSACTION
            END


        SELECT  @sql_error_message = CONVERT(VARCHAR(20), @sql_error)
                + 'Patch Error!!!>>>' + ISNULL(@sql_error_message, '')

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

GO