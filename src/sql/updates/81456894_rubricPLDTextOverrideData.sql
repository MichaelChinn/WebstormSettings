
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 81456894
, @title = 'SERubricPLDTextOverride performance data'
, @comment = ''
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

ALTER TABLE [dbo].[SERubricPLDTextOverride] DROP CONSTRAINT [FK_SERubricPLDTextOverride_SERubricPerformanceLevel]

INSERT dbo.SERubricPLDTextOverride(EvalSessionID, RubricRowID, RubricPerformanceLevelID, DescriptorText, UserID, PL1DescriptorText, PL2DescriptorText, PL3DescriptorText, PL4DescriptorText)
SELECT DISTINCT 
       EvalSessionID
      ,o.RubricRowID
      ,0
      ,''
      ,UserID
      ,rr.PL1Descriptor
      ,rr.PL2Descriptor
      ,rr.PL3Descriptor
      ,rr.PL4Descriptor
  FROM dbo.SERubricPLDTextOverride o
  JOIN dbo.SERubricRow rr ON o.RubricRowID=rr.RubricRowID
 
UPDATE o_new
   SET o_new.PL1DescriptorText=o_old.DescriptorText
  FROM dbo.SERubricPLDTextOverride o_new
  JOIN dbo.SERubricPLDTextOverride o_old ON o_old.EvalSessionID=o_new.EvalSessionID
 WHERE o_old.RubricRowID=o_new.RubricRowID
   AND o_old.UserID=o_new.UserID
   AND o_new.RubricPerformanceLevelID=0
   AND o_old.RubricPerformanceLevelID=1
   
UPDATE o_new
   SET o_new.PL2DescriptorText=o_old.DescriptorText
  FROM dbo.SERubricPLDTextOverride o_new
  JOIN dbo.SERubricPLDTextOverride o_old ON o_old.EvalSessionID=o_new.EvalSessionID
 WHERE o_old.RubricRowID=o_new.RubricRowID
   AND o_old.UserID=o_new.UserID
   AND o_new.RubricPerformanceLevelID=0
   AND o_old.RubricPerformanceLevelID=2
   
UPDATE o_new
   SET o_new.PL3DescriptorText=o_old.DescriptorText
  FROM dbo.SERubricPLDTextOverride o_new
  JOIN dbo.SERubricPLDTextOverride o_old ON o_old.EvalSessionID=o_new.EvalSessionID
 WHERE o_old.RubricRowID=o_new.RubricRowID
   AND o_old.UserID=o_new.UserID
   AND o_new.RubricPerformanceLevelID=0
   AND o_old.RubricPerformanceLevelID=3
   
UPDATE o_new
   SET o_new.PL4DescriptorText=o_old.DescriptorText
  FROM dbo.SERubricPLDTextOverride o_new
  JOIN dbo.SERubricPLDTextOverride o_old ON o_old.EvalSessionID=o_new.EvalSessionID
 WHERE o_old.RubricRowID=o_new.RubricRowID
   AND o_old.UserID=o_new.UserID
   AND o_new.RubricPerformanceLevelID=0
   AND o_old.RubricPerformanceLevelID=4
   
DELETE dbo.SERubricPLDTextOverride WHERE RubricPerformanceLevelID <> 0

ALTER TABLE [dbo].[SERubricPLDTextOverride] DROP COLUMN RubricPerformanceLevelID 
ALTER TABLE [dbo].[SERubricPLDTextOverride] DROP COLUMN DescriptorText 


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


