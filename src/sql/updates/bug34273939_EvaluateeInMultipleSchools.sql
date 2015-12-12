
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
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

select @bugFixed = 34273939
, @title = 'bug34273939_EvaluateeInMultipleSchools'
, @comment = ''


DECLARE @dependsOnBug INT, @dependsOnBug2 int
SET @dependsOnBug = 2700
SET @dependsOnBug2 = 2461


/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
/***********************************************************************************/

if EXISTS (select bugNumber from dbo.updateLog WHERE bugNumber = @bugFixed) 
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Error: fix for bugNumber #' + Convert(varchar(20), @bugFixed) + ' has already been applied'
    GOTO ProcEnd
END

IF NOT EXISTS( SELECT bugNumber FROM UpdateLog WHERE bugNumber = @dependsOnBug)
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Fail Bug patch : ' 
		+ Convert(varchar(20), @bugFixed) + ' DEPENDS ON BUG NOT APPLIED: ' + CAST(@dependsOnBug AS VARCHAR(10))
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

IF NOT EXISTS( SELECT bugNumber FROM UpdateLog WHERE bugNumber = @dependsOnBug2)
BEGIN
	SELECT @sql_error = -1, @sql_error_message = 'Fail Bug patch : ' 
		+ Convert(varchar(20), @bugFixed) + ' DEPENDS ON BUG NOT APPLIED: ' + CAST(@dependsOnBug2 AS VARCHAR(10))
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
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

	alter table dbo.seUserLocationRole DROP constraint FK_SEUserLocationRole_SEUser
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Failed to drop FK_SEUserLocationRole_SEUser field. In: ' 
			+ Convert(varchar(20), @bugFixed)
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END

	alter table dbo.seUserLocationRole drop constraint FK_SEUserLocationRole_AppRole
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Failed to drop constraint FK_SEUserLocationRole_AppRole field. In: ' 
			+ Convert(varchar(20), @bugFixed)
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END

	DROP TABLE dbo.SEUserLocationRole
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Failed to drop table SEUserLocationRole field. In: ' 
			+ Convert(varchar(20), @bugFixed)
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END

	SET ANSI_PADDING OFF
	
	SET ANSI_NULLS ON
	
	SET QUOTED_IDENTIFIER ON
	
	SET ANSI_PADDING ON
		
	CREATE TABLE [dbo].[SEUserLocationRole](
		[UserLocationRoleID] [bigint] IDENTITY(1,1) NOT NULL,
		[UserName] [nvarchar](255) NOT NULL,
		[RoleName] [nvarchar](255) NOT NULL,
		[DistrictCode] [nvarchar](25) NOT NULL,
		[SchoolCode] [nvarchar](25) NULL,
		[LastActiveRole] [bit] NULL,
		[CreateDate] [datetime] NOT NULL,			
						
	 CONSTRAINT [PK_SEUserLocationROle] PRIMARY KEY CLUSTERED 
	(
		[UserLocationRoleID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	BEGIN
		SELECT @sql_error_message = 'Failed to rebuild table SEUserLocationRole. In: ' 
			+ Convert(varchar(20), @bugFixed)
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
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
