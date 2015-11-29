
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 83900250
, @title = 'Default Print Settings for Reports'
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

CREATE TABLE [dbo].[SEReportPrintOptionEvaluation](
	[ReportPrintOptionEvaluationID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportPrintOptionID] [bigint] NOT NULL,
	[EvaluationID] [bigint] NULL,
 CONSTRAINT [PK_SEReportPrintOptionEvaluation] PRIMARY KEY CLUSTERED 
(
	[ReportPrintOptionEvaluationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEReportPrintOptionEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionEvaluation_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])

ALTER TABLE [dbo].[SEReportPrintOptionEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionEvaluation_SEReportPrintOption] FOREIGN KEY([ReportPrintOptionID])
REFERENCES [dbo].[SEReportPrintOption] ([ReportPrintOptionID])

CREATE TABLE [dbo].[SEReportPrintOptionEvalSession](
	[ReportPrintOptionEvalSessionID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportPrintOptionID] [bigint] NOT NULL,
	[EvalSessionID] [bigint] NULL,
 CONSTRAINT [PK_SEReportPrintOptionEvalSession] PRIMARY KEY CLUSTERED 
(
	[ReportPrintOptionEvalSessionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEReportPrintOptionEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionEvalSession_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])

ALTER TABLE [dbo].[SEReportPrintOptionEvalSession]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionEvalSession_SEReportPrintOption] FOREIGN KEY([ReportPrintOptionID])
REFERENCES [dbo].[SEReportPrintOption] ([ReportPrintOptionID])

CREATE TABLE [dbo].[SEReportPrintOptionEvaluatee](
	[ReportPrintOptionEvaluateeID] [bigint] IDENTITY(1,1) NOT NULL,
	[ReportPrintOptionID] [bigint] NOT NULL,
	[EvaluateeID] [bigint] NOT NULL,
	[SchoolYear] [smallint] NOT NULL
 CONSTRAINT [PK_SEReportPrintOptionEvaluatee] PRIMARY KEY CLUSTERED 
(
	[ReportPrintOptionEvaluateeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[SEReportPrintOptionEvaluatee]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionEvaluatee_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

ALTER TABLE [dbo].[SEReportPrintOptionEvaluatee]  WITH CHECK ADD  CONSTRAINT [FK_SEReportPrintOptionEvaluatee_SEReportPrintOption] FOREIGN KEY([ReportPrintOptionID])
REFERENCES [dbo].[SEReportPrintOption] ([ReportPrintOptionID])



-- get rid of the ones that are there and start fresh with ones that are linked to a specific
-- eval session of evaluation in the new tables
DELETE pou
  FROM dbo.SEReportPrintOptionUser pou
  JOIN dbo.SEReportPrintOption po ON pou.ReportPrintOptionID=po.ReportPrintOptionID
  JOIN dbo.SEReportPrintOptionType pot ON po.ReportPrintOptionTypeID=pot.ReportPrintOptionTypeID
 WHERE pot.Name LIKE 'FINAL%' OR pot.Name LIKE '%OBSERVATION%'


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



