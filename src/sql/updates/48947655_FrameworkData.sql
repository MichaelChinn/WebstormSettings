
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 48947655
, @title = 'Changes to Framework Schema/Data'
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

UPDATE dbo.SEFramework SET DerivedFromFrameworkID=
  CASE
  WHEN DerivedFromFrameworkName = 'Dan, StateView' THEN 34
  WHEN DerivedFromFrameworkName = 'Dan, IFW View'  THEN 35
  WHEN DerivedFromFrameworkName = 'CEL, StateView' THEN 36
  WHEN DerivedFromFrameworkName = 'CEL, IFW View'  THEN 37
  WHEN DerivedFromFrameworkName = 'Mar, StateView' THEN 38
  WHEN DerivedFromFrameworkName = 'Prin, StateView' THEN 39
  WHEN DerivedFromFrameworkName='Wenatchee PR' THEN 40
  WHEN DerivedFromFrameworkName = 'Mar, IFW View'  THEN 41
  WHEN DerivedFromFrameworkName = 'Mar, Prin StateView' THEN 42
  WHEN DerivedFromFrameworkName='Mar, Prin IFW View'THEN 43
  ELSE 0
  END
  
  
  UPDATE dbo.SEFramework SET DerivedFromFrameworkAuthor=
  CASE
  WHEN DerivedFromFrameworkName = 'Dan, StateView' THEN 'BDAN'
  WHEN DerivedFromFrameworkName = 'Dan, IFW View'  THEN 'BDAN'
  WHEN DerivedFromFrameworkName = 'CEL, StateView' THEN 'BCEL'
  WHEN DerivedFromFrameworkName = 'CEL, IFW View'  THEN 'BCEL'
  WHEN DerivedFromFrameworkName = 'Mar, StateView' THEN 'BMAR'
  WHEN DerivedFromFrameworkName = 'Prin, StateView' THEN 'BPRIN'
  WHEN DerivedFromFrameworkName='Wenatchee PR' THEN 'prWEN'
  WHEN DerivedFromFrameworkName = 'Mar, IFW View'  THEN 'BMAR'
  WHEN DerivedFromFrameworkName = 'Mar, Prin StateView' THEN 'BMARPR'
  WHEN DerivedFromFrameworkName='Mar, Prin IFW View'THEN 'BMARPR'
  ELSE ''
  END
  
 
  -- Set the existing ones to the start of the school year since we don't know exactly when they were loaded
  UPDATE dbo.SEFramework 
     SET LoadDateTime='2011-09-01 00:00:00.000'
   WHERE SchoolYear=2012
   
   UPDATE dbo.SEFramework 
     SET LoadDateTime='2012-09-01 00:00:00.000'
   WHERE SchoolYear=2013
  
   UPDATE dbo.SEFramework 
     SET EvaluationTypeID=
     CASE WHEN FrameworkTypeID IN (3,4, 7,8) THEN 1 ELSE 2 END
          
DECLARE @Query VARCHAR(MAX)
SELECT @Query = 'ALTER TABLE SEFramework ALTER COLUMN DerivedFromFrameworkID BIGINT NOT NULL'
EXEC(@Query)
SELECT @Query = 'ALTER TABLE SEFramework ALTER COLUMN DerivedFromFrameworkAuthor VARCHAR(20) NOT NULL'
EXEC(@Query)
SELECT @Query = 'ALTER TABLE SEFramework ALTER COLUMN LoadDateTime DATETIME NOT NULL'
EXEC(@Query)
SELECT @Query = 'ALTER TABLE SEFramework ALTER COLUMN EvaluationTypeID SMALLINT NOT NULL'
EXEC(@Query)

  -- ALTER TABLE dbo.SEFramework DROP COLUMN DerivedFromFrameworkName

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


