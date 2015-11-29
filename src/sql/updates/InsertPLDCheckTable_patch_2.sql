DECLARE @ahora dateTime
SELECT @ahora = GETDATE()

if ( (select max(versionnumber) from updateLog) is null)
begin
	INSERT updateLog(versionnumber, updateName, comment, timestamp)
	values (1, 'Initial Entry', 'A Do Nothing update, here to insert an entry into the update log if necessary', @ahora)
end


/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @thisVersion bigint, @title varchar(100), @comment varchar(400)
SELECT  @sql_error= 0,@tran_count = @@TRANCOUNT , @prevVersion = ISNULL(max(versionNumber), 0) from dbo.UpdateLog

IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @thisVersion = 2
, @title = 'PLD Check Schema change'
, @comment = 'add table to record checks *within* a performance level descriptor'
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/
/*  Notes...
	a) update the version number, title and comment variables above
	b) update the body of the patch, (below) checking for errors to roll back if necessary
	c) in the case of a schema update, you must also check the existence of the change,
        as schema changes should also have been made in SchemaCreate.  This way, you
        can still run the patch (to update the version table), but the change won't be
        made again.
*/
if ((select versionNumber from dbo.updateLog where versionNumber = @thisVersion) is not null)
BEGIN
	SELECT @sql_error_message = 'Error: Patch #' + Convert(varchar(20), @thisVersion) + ' has already been applied'
    GOTO ProcEnd
END
if (@prevVersion <> @thisVersion -1)
BEGIN
  SELECT @sql_Error = -1, @sql_error_message = 'Version mismatch... this version:' 
		+ Convert(varchar (20),@thisVersion) + '... prevVersion: ' + Convert(varchar(20),@prevVersion)
  GOTO ErrorHandler
END

INSERT dbo.UpdateLog (VersionNumber, UpdateName, TimeStamp) values (@thisVersion, @title, @ahora)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/

/* for a schema change, you have to check to see if the column is already there, 
because the schema create might have been updated to create the column on commit.

the wrinkle is, that even if it was created previously, you still have to put
an entry in the update log, else following updates will fail

so, we leave the top part of this boiler plate to insert the log entry,
but note that nothing actually happens is this stuff is already there...
*/
BEGIN

	SET ANSI_NULLS ON
	
	SET QUOTED_IDENTIFIER ON
	
	IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SEPLDCheck]') AND type in (N'U'))
	BEGIN
	CREATE TABLE [dbo].[SEPLDCheck](
		[PLDCheckId] [bigint] IDENTITY(1,1) NOT NULL,
		[RubricRowID] [bigint] NOT NULL,
		[PerformanceLevelID] [smallint] NOT NULL,
		[CheckId] [smallint] NOT NULL,
		[EvalSessionID] [bigint] NOT NULL,
		[IsChecked] [bit] NOT NULL,
	 CONSTRAINT [PK_SEPLDCheck] PRIMARY KEY CLUSTERED 
	(
		[PLDCheckId] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
	END
	
	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPLDCheck_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPLDCheck]'))
	ALTER TABLE [dbo].[SEPLDCheck]  WITH CHECK ADD  CONSTRAINT [FK_SEPLDCheck_SEEvalSession] FOREIGN KEY([EvalSessionID])
	REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])
	
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPLDCheck_SEEvalSession]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPLDCheck]'))
	ALTER TABLE [dbo].[SEPLDCheck] CHECK CONSTRAINT [FK_SEPLDCheck_SEEvalSession]
	
	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPLDCheck_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPLDCheck]'))
	ALTER TABLE [dbo].[SEPLDCheck]  WITH CHECK ADD  CONSTRAINT [FK_SEPLDCheck_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
	REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])
	
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPLDCheck_SERubricPerformanceLevel]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPLDCheck]'))
	ALTER TABLE [dbo].[SEPLDCheck] CHECK CONSTRAINT [FK_SEPLDCheck_SERubricPerformanceLevel]
	
	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPLDCheck_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPLDCheck]'))
	ALTER TABLE [dbo].[SEPLDCheck]  WITH CHECK ADD  CONSTRAINT [FK_SEPLDCheck_SERubricRow] FOREIGN KEY([RubricRowID])
	REFERENCES [dbo].[SERubricRow] ([RubricRowID])
	
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_SEPLDCheck_SERubricRow]') AND parent_object_id = OBJECT_ID(N'[dbo].[SEPLDCheck]'))
	ALTER TABLE [dbo].[SEPLDCheck] CHECK CONSTRAINT [FK_SEPLDCheck_SERubricRow]
	



END


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

/*

select * from coeStudentSiteconfig
select * from updatelog


*/