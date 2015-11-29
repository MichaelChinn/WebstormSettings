
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime , @NextVersion bigint
SELECT  @ahora = GETDATE()
SELECT @sql_error= 0,@tran_count = @@TRANCOUNT  FROM dbo.updateLog

IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 49071583
, @title = '49071345_HydrateStickyId'
, @comment = 'hydrate stickyID'
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
if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

INSERT dbo.UpdateLog ( bugNumber, UpdateName, TimeStamp, comment) values (@bugFixed, @title, @ahora, @comment)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/
UPDATE dbo.seFramework SET StickyID = pf.StickyId
FROM dbo.SEFramework f 
JOIN Stateeval_proto.dbo.SEFramework pf ON f.DerivedFromFrameworkID = pf.FrameworkID

UPDATE dbo.SERubricRow SET StickyID = prr.StickyId
FROM seRubricRow rr
JOIN dbo.SERubricRowFrameworkNode rrfn ON rrfn.RubricRowID = rr.RubricRowID
JOIN dbo.SEFrameworkNode fn ON fn.FrameworkNodeID = rrfn.FrameworkNodeID
JOIN dbo.SEFramework f ON fn.FrameworkID = f.FrameworkID

JOIN Stateeval_proto.dbo.SEFramework pf ON f.DerivedFromFrameworkID = pf.FrameworkID
JOIN Stateeval_proto.dbo.SEFrameworkNode pfn ON pfn.FrameworkID = pf.FrameworkID
JOIN Stateeval_proto.dbo.SERubricRowFrameworkNode prrfn ON prrfn.FrameworkNodeID = pfn.FrameworkNodeID
JOIN Stateeval_proto.dbo.seRubricRow prr ON prr.RubricRowID = prrfn.RubricRowID AND prr.title = rr.title

UPDATE dbo.seFrameworkNode SET StickyID = pfn.StickyId
FROM dbo.SEFrameworkNode fn
JOIN dbo.SEFramework f ON fn.FrameworkID = f.FrameworkID
JOIN Stateeval_proto.dbo.SEFramework pf ON f.DerivedFromFrameworkID = pf.FrameworkID
JOIN Stateeval_proto.dbo.SEFrameworkNode pfn ON pfn.FrameworkID = pf.FrameworkID AND fn.title = pfn.title


/***** ^^^^                  ^^^^^^ ************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***********************************************************************************/
-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      IF (@tran_count = 0) AND (@@TRANCOUNT <> 0)
         BEGIN
            ROLLBACK TRANSACTION
         END


	  SELECT @sql_error_message = Convert(varchar(20), @sql_error) 
		+ 'Patch Error!!!>>>' + ISNULL(@sql_error_message, '')

      RAISERROR(@sql_error_message, 15, 10)
   END

----------------------
-- End of Procedure --
----------------------
ProcEnd:

IF (@tran_count = 0) AND (@@TRANCOUNT = 1)
   BEGIN
     COMMIT TRANSACTION
   END

GO