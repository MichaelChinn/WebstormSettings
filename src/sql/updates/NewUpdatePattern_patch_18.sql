DECLARE @ahora dateTime
SELECT @ahora = GETDATE()

if ( (select max(versionnumber) from updateLog) is null)
begin
	INSERT updateLog(versionnumber, updateName, comment, timestamp)
	values (1, 'Initial Entry', 'A Do Nothing update', @ahora)
end


/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @thisVersion bigint, @title varchar(100), @comment varchar(400)
SELECT  @sql_error= 0,@tran_count = @@TRANCOUNT , @prevVersion = ISNULL(max(versionNumber), 0) from dbo.UpdateLog

IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @thisVersion = 18
, @title = 'Schema Patch for update log'
, @comment = 'enable new update strategy of non-sequence update numbers'
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

INSERT dbo.UpdateLog (VersionNumber, UpdateName, TimeStamp, comment) values (@thisVersion, @title, @ahora, @comment)
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
   BEGIN
	  SELECT @sql_error_message = 'insert log entry failed' 

	  GOTO ErrorHandler
   END


/***********************************************************************************/
/***** ||||  UPDATE CONTENT  ||||||*************************************************/
/***** VVVV                  VVVVVV ************************************************/



if NOT Exists(select * from sys.columns where Name = N'bugNumber'   
            and Object_ID = Object_ID(N'updateLog')) 
begin 
	CREATE TABLE #t (
		[UpdateName] [varchar](200) NOT NULL,
		[Comment] [varchar](200) NULL,
		[TimeStamp] [datetime] NOT NULL,
		)
		
	INSERT #t (updateName, comment, timestamp)
	SELECT  updateName, comment, TIMESTAMP
	FROM dbo.UPdateLog ORDER by timestamp

	DROP TABLE dbo.UpdateLog
	 
	CREATE TABLE [dbo].[UpdateLog](
		[UpdateLogID] [bigint] IDENTITY(1,1) NOT NULL,
		[BugNumber] [bigint] NOT NULL,
		[UpdateName] [varchar](100) NOT NULL,
		[Comment] [varchar](200) NOT NULL,
		[timestamp] [datetime] NOT NULL,
		
		
	 CONSTRAINT [PK_UpdateLog] PRIMARY KEY CLUSTERED 
	(
		[UpdateLogID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]


	INSERT UpdateLog (bugNumber, updateName, comment, TIMESTAMP)
	SELECT 0, UpdateName, ISNULL(comment,''), Timestamp FROM #t
	
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Failed while trying to update the update log schema. In: ' 
			+ @thisVersion
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END

end 






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