
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 36474501
, @title = 'Report Snapshots'
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

CREATE TABLE [dbo].[SEReportType](
	[ReportTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nchar](50) NOT NULL,
 CONSTRAINT [PK_SEReportType] PRIMARY KEY CLUSTERED 
(
	[ReportTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[SEReportSnapshot](
	[ReportSnapshotID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportTypeID] [smallint] NOT NULL,
	[RepositoryItemID] [bigint] NULL,
	[SchoolYear] [smallint] NOT NULL,
	[IsPublic] [bit] NOT NULL
 CONSTRAINT [PK_SEReportSnapshot] PRIMARY KEY CLUSTERED 
(
	[ReportSnapshotID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEReportSnapshot]  WITH CHECK ADD  CONSTRAINT [FK_SEReportSnapshot_SEReportType] FOREIGN KEY([ReportTypeID])
REFERENCES [dbo].[SEReportType] ([ReportTypeID])

ALTER TABLE [dbo].[SEReportSnapshot]  WITH CHECK ADD  CONSTRAINT [FK_SEReportSnapshot_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

DECLARE @Query VARCHAR(MAX)
SELECT @Query = 'INSERT SEReportType(Name) VALUES(''' + 'Final' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportType(Name) VALUES(''' + 'Observation' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportType(Name) VALUES(''' + 'SelfAssessment' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportType(Name) VALUES(''' + 'Discrepancy' + ''')'
EXEC(@Query)

CREATE TABLE [dbo].[SEReportPrintOptionType](
	[ReportPrintOptionTypeID] [smallint] IDENTITY(1,1) NOT NULL,
	[Name] [nchar](50) NOT NULL,
 CONSTRAINT [PK_SEReportPrintOptionType] PRIMARY KEY CLUSTERED 
(
	[ReportPrintOptionTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

SELECT @Query = 'INSERT SEReportPrintOptionType(Name) VALUES(''' + 'FINAL_OBSERVATION' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportPrintOptionType(Name) VALUES(''' + 'FINAL_SELF_ASSESSMENT' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportPrintOptionType(Name) VALUES(''' + 'FINAL_FINAL' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportPrintOptionType(Name) VALUES(''' + 'FINAL_GLOBAL' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportPrintOptionType(Name) VALUES(''' + 'DISCREPANCY_OBSERVATION' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportPrintOptionType(Name) VALUES(''' + 'DISCREPANCY_SELF_ASSESSMENT' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportPrintOptionType(Name) VALUES(''' + 'DISCREPANCY_GLOBAL' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportPrintOptionType(Name) VALUES(''' + 'OBSERVATION_OBSERVATION' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportPrintOptionType(Name) VALUES(''' + 'OBSERVATION_GLOBAL' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportPrintOptionType(Name) VALUES(''' + 'SELFASSESS_ASSESS' + ''')'
EXEC(@Query)
SELECT @Query = 'INSERT SEReportPrintOptionType(Name) VALUES(''' + 'SELFASSESS_GLOBAL' + ''')'
EXEC(@Query)

CREATE TABLE [dbo].[SEReportPrintOption](
	[ReportPrintOptionID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportPrintOptionTypeID] [smallint] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[ParentReportOptionID] [BIGINT] NULL,
 CONSTRAINT [PK_SEReportPrintOption] PRIMARY KEY CLUSTERED 
(
	[ReportPrintOptionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEReportPrintOption]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOption_SEReportPrintOptionType] FOREIGN KEY([ReportPrintOptionTypeID])
REFERENCES [dbo].[SEReportPrintOptionType] ([ReportPrintOptionTypeID])

CREATE TABLE [dbo].[SEReportPrintOptionUser](
	[ReportPrintOptionID] [BIGINT] NOT NULL,
	[UserID] [BIGINT] NOT NULL,
)

ALTER TABLE [dbo].[SEReportPrintOptionUser]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionUser_SEUser] FOREIGN KEY([UserID])
REFERENCES [dbo].[SEUser] ([SEUserID])

DROP TABLE dbo.SEFinalReportSettings

ALTER TABLE [dbo].[SEEvalVisibility] ADD ReportSnapshotVisible BIT NOT NULL DEFAULT ((0))

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


