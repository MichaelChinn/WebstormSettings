
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 60641116
, @title = '60641116_redLeadershipDescriptors'
, @comment = 'change the font color of student growth descriptor text to red for 2014 rubric'
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

INSERT dbo.UpdateLog (bugNumber, UpdateName, TimeStamp, comment) values (@bugFixed, @title, @ahora, @comment)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

-- First update the ones that have been overriden
UPDATE dbo.SERubricPLDTextOverride
   SET DescriptorText='<span style="color:red">' + DescriptorText + '</span>'
 WHERE SERubricPLDTextOverrideID IN
(SELECT  o.SERubricPLDTextOverrideID
  FROM dbo.SERubricPLDTextOverride o
  JOIN serubricrow rr ON o.RubricRowID=rr.RubricRowID
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
  WHERE f.SchoolYear=2014
    AND f.DerivedFromFrameworkName='Prin, StateView'
    AND rr.IsStudentGrowthAligned=1)
    
-- Next, update the standard ones
UPDATE dbo.SERubricRow
   SET	PL1Descriptor='<span style="color:red">' + PL1Descriptor + '</span>',
		PL2Descriptor='<span style="color:red">' + PL2Descriptor + '</span>',
		PL3Descriptor='<span style="color:red">' + PL3Descriptor + '</span>',
		PL4Descriptor='<span style="color:red">' + PL4Descriptor + '</span>'
 WHERE RubricRowID IN
(SELECT  rr.RubricRowID
  FROM serubricrow rr
  JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
  JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
  WHERE f.SchoolYear=2014
    AND f.DerivedFromFrameworkName='Prin, StateView'
    AND rr.IsStudentGrowthAligned=1)


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


