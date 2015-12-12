
/***********************************************************************************/
DECLARE @sql_error INT,@tran_count INT,@sql_error_message NVARCHAR(500), @prevVersion bigint
DECLARE @BugFixed bigint, @title varchar(100), @comment varchar(400), @ahora dateTime
SELECT  @ahora = GETDATE(), @sql_error= 0,@tran_count = @@TRANCOUNT 
IF @tran_count = 0
   BEGIN TRANSACTION
/***********************************************************************************/
/* ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** ***UPDATE ME*** */
select @bugFixed = 2721
, @title = 'Evaluation table changes'
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

CREATE TABLE [dbo].[SESchoolYear](
	[SchoolYear] [smallint] NOT NULL,
	[Description] [nvarchar](255) NOT NULL,
	[YearRange] [varchar](255) NULL,
 CONSTRAINT [PK_SESchoolYear] PRIMARY KEY CLUSTERED 
(
	[SchoolYear] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Evaluation table changes failed: ' 
		+ @bugFixed
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END



INSERT INTO SESchoolYear(SchoolYear, Description, YearRange) VALUES( 2012, '2011-2012 school year', '2011-2012') 
INSERT INTO SESchoolYear(SchoolYear, Description, YearRange) VALUES( 2013, '2012-2013 school year', '2012-2013') 
INSERT INTO SESchoolYear(SchoolYear, Description, YearRange) VALUES( 2014, '2013-2014 school year', '2013-2014') 




CREATE TABLE [dbo].[SEEvaluation](
	[EvaluationID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluateeID] [bigint] NOT NULL,
	[EvaluatorID] [bigint] NULL,
	[EvaluationTypeID] [smallint] NOT NULL,
	[PerformanceLevelID] [smallint] NULL,
	[HasBeenSubmitted] [bit] NOT NULL DEFAULT((0)),
	[SubmissionDate] [datetime] NULL,
	[SchoolYear] [smallint] NOT NULL,
	[Complete] [bit] NOT NULL DEFAULT ((0)) ,
	[Locked] [bit] NOT NULL DEFAULT ((0)) ,
	[LockUserID] [bigint] NULL,
	[LockDate] [datetime] NULL,
	[CreateDate] [datetime] NOT NULL DEFAULT (getutcdate()),
	[CreatedBy] [bigint] NULL,
	[ModifyDate] [datetime] NULL DEFAULT (getutcdate()),
	[EvaluateePlanTypeID] [smallint] NULL,
 CONSTRAINT [PK_SEEvaluation] PRIMARY KEY CLUSTERED 
(
	[EvaluationID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Evaluation table changes failed: ' 
		+ @bugFixed
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

ALTER TABLE [dbo].[SEEvaluation] ADD  CONSTRAINT [DF_SEEvaluation_EvaluateePlanTypeID]  DEFAULT ((1)) FOR [EvaluateePlanTypeID]

ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEEvaluationType] FOREIGN KEY([EvaluationTypeID])
REFERENCES [dbo].[SEEvaluationType] ([EvaluationTypeID])

ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SEEvaluationType]

ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SERubricPerformanceLevel] FOREIGN KEY([PerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])

ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SERubricPerformanceLevel]

ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SESchoolYear] FOREIGN KEY([SchoolYear])
REFERENCES [dbo].[SESchoolYear] ([SchoolYear])

ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SESchoolYear]

ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEUser] FOREIGN KEY([EvaluateeID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SEUser]

ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEUser1] FOREIGN KEY([EvaluatorID])
REFERENCES [dbo].[SEUser] ([SEUserID])

ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SEUser1]

ALTER TABLE [dbo].[SEEvaluation]  WITH CHECK ADD  CONSTRAINT [FK_SEEvaluation_SEEvaluateePlanType] FOREIGN KEY([EvaluateePlanTypeID])
REFERENCES [dbo].[SEEvaluateePlanType] ([EvaluateePlanTypeID])

ALTER TABLE [dbo].[SEEvaluation] CHECK CONSTRAINT [FK_SEEvaluation_SEEvaluateePlanType]




CREATE TABLE [dbo].[SEEvalVisibility](
	[VisibilityID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvaluationID] [bigint] NOT NULL,
	[FinalScoreVisible] [bit] NOT NULL,
	[FNSummativeScoresVisible] [bit] NOT NULL,
	[FNExcerptsVisible] [bit] NOT NULL,
	[RRSummativeScoresVisible] [bit] NOT NULL,
	[ObservationsVisible] [bit] NOT NULL,
	[EvalCommentsVisible] [bit] NOT NULL,
	[EvalExcerptsVisible] [bit] NOT NULL,
	[RRAnnotationsVisible] [bit] NOT NULL,
	[AdditionalMeasuresVisible] [bit] NOT NULL,
 CONSTRAINT [PK_SEEvalVisibility] PRIMARY KEY CLUSTERED 
(
	[VisibilityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]


SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Evaluation table changes failed: ' 
		+ @bugFixed
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

ALTER TABLE [dbo].[SEEvalVisibility] ADD  CONSTRAINT [DF_SEEvalVisibility_FinalScoreVisible]  DEFAULT ((0)) FOR [FinalScoreVisible]
ALTER TABLE [dbo].[SEEvalVisibility] ADD  CONSTRAINT [DF_SEEvalVisibility_FNSummativeScoresVisible]  DEFAULT ((0)) FOR [FNSummativeScoresVisible]
ALTER TABLE [dbo].[SEEvalVisibility] ADD  CONSTRAINT [DF_SEEvalVisibility_FNExcerptsVisible]  DEFAULT ((0)) FOR [FNExcerptsVisible]
ALTER TABLE [dbo].[SEEvalVisibility] ADD  CONSTRAINT [DF_SEEvalVisibility_RRSummativeScoresVisible]  DEFAULT ((0)) FOR [RRSummativeScoresVisible]
ALTER TABLE [dbo].[SEEvalVisibility] ADD  CONSTRAINT [DF_SEEvalVisibility_ObservationsVisible]  DEFAULT ((0)) FOR [ObservationsVisible]
ALTER TABLE [dbo].[SEEvalVisibility] ADD  CONSTRAINT [DF_SEEvalVisibility_EvalCommentsVisible]  DEFAULT ((0)) FOR [EvalCommentsVisible]
ALTER TABLE [dbo].[SEEvalVisibility] ADD  CONSTRAINT [DF_SEEvalVisibility_EvalExcerptsVisible]  DEFAULT ((0)) FOR [EvalExcerptsVisible]
ALTER TABLE [dbo].[SEEvalVisibility] ADD  CONSTRAINT [DF_SEEvalVisibility_RRAnnotationsVisible]  DEFAULT ((0)) FOR [RRAnnotationsVisible]
ALTER TABLE [dbo].[SEEvalVisibility] ADD  CONSTRAINT [DF_SEEvalVisibility_AdditionalMeasuresVisible]  DEFAULT ((0)) FOR [AdditionalMeasuresVisible]


ALTER TABLE [dbo].[SEEvalVisibility]  WITH CHECK ADD  CONSTRAINT [FK_SEEvalVisibility_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])



-- add the EvaluationID column to the SEEvalSession table

ALTER TABLE SEEvalSession ADD EvaluationID BIGINT NULL

ALTER TABLE SEEvalSession ADD  CONSTRAINT [FK_SEEvalSession_SEEvaluation] FOREIGN KEY([EvaluationID])
REFERENCES [dbo].[SEEvaluation] ([EvaluationID])




CREATE TABLE [dbo].[SERubricPLDTextOverride](
	[SERubricPLDTextOverrideID] [bigint] IDENTITY(1,1) NOT NULL,
	[EvalSessionID] [bigint] NOT NULL,
	[RubricRowID] [bigint] NOT NULL,
	[RubricPerformanceLevelID] [smallint] NOT NULL,
	[DescriptorText] varchar(max) NULL
 CONSTRAINT [PK_SERubricPLDTextOverride] PRIMARY KEY CLUSTERED 
(
	[SERubricPLDTextOverrideID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE SERubricPLDTextOverride ADD  CONSTRAINT [FK_SERubricPLDTextOverride_SEEvalSession] FOREIGN KEY([EvalSessionID])
REFERENCES [dbo].[SEEvalSession] ([EvalSessionID])

ALTER TABLE SERubricPLDTextOverride ADD  CONSTRAINT [FK_SERubricPLDTextOverride_SERubricRow] FOREIGN KEY([RubricRowID])
REFERENCES [dbo].[SERubricRow] ([RubricRowID])


ALTER TABLE SERubricPLDTextOverride ADD  CONSTRAINT [FK_SERubricPLDTextOverride_SERubricPerformanceLevel] FOREIGN KEY([RubricPerformanceLevelID])
REFERENCES [dbo].[SERubricPerformanceLevel] ([PerformanceLevelID])


--set up for users that weren't in sefinal score and were supposed to be
CREATE TABLE #teeID (seUserID BIGINT, valType smallint)
INSERT #teeID (seUserID)
SELECT distinct SEUserID FROM seUser su 
JOIN aspnet_usersInRoles uir on uir.userID = su.aspnetuserID
JOIN aspnet_roles r ON r.roleID = uir.roleID
WHERE rolename LIKE '%prin%' OR rolename LIKE '%teach%'
AND su.SEUserID <> 210


UPDATE #teeID SET valType = 2
UPDATE #teeID SET valtype = 1
WHERE seUserId IN 
(
	SELECT seUserID FROM seUser su
	JOIN aspnet_usersInRoles uir ON uir.userid = su.ASPNetUserID
	JOIN aspnet_roles r ON r.roleID = uir.roleID
	WHERE RoleName = 'seschoolprincipal'
)

--SELECT *  FROM #teeID


create table #msg(teeId BIGINT)
INSERT #msg(teeID)
SELECT seUserID FROM #teeID
WHERE seUserID NOT IN 
(SELECT evaluateeID FROM dbo.SEFinalScore)


--select COUNT(*) FROM #msg

-- 2012 seEvaluation records directly from seFinalScore
DECLARE @Query VARCHAR(MAX)
SELECT @Query = 
'INSERT dbo.SEEvaluation(EvaluateeID, EvaluatorID, EvaluationTypeID, HasBeenSubmitted, SubmissionDate, PerformanceLevelID, SchoolYear) 
SELECT distinct fs.EvaluateeId,
	   fs.EvaluatorId,
	   fs.EvaluationTypeID,
	   fs.HasBeenSubmitted,
	   fs.SubmissionDate,
	   fs.PerformanceLevelID,
	   2012
  FROM dbo.SEFinalScore fs where evaluateeID <> 210'
EXEC (@Query)

--select '===2012 seEvaluation records for users from missing list...'
SELECT @Query = 
'INSERT dbo.SEEvaluation(EvaluateeID, EvaluationTypeID, SchoolYear) 
SELECT t.seUserID, t.valType, 2012
from #msg m
join #teeId t on t.seUserID = m.teeid'

EXEC (@Query)


--SELECT '===2013 seEvaluation records, easily done from #teeIds'

SELECT @Query = 
'INSERT dbo.SEEvaluation(EvaluateeID, EvaluationTypeID, SchoolYear) 
SELECT seUserid, valType, 2013 from #TeeId'
EXEC (@Query)

SELECT @Query = 
'UPDATE dbo.SEEvaluation 
   SET EvaluatorId=e_2012.EvaluatorID
  FROM dbo.SEEvaluation e_2013
  JOIN (SELECT EvaluatorID, EvaluateeID
          FROM dbo.SEEvaluation 
         WHERE SchoolYear=2012) e_2012 ON e_2012.EvaluateeID=e_2013.EvaluateeID
 WHERE e_2013.SchoolYear=2013'
EXEC (@Query)

SELECT @Query = 
'INSERT dbo.SEEvalVisibility(EvaluationID) 
SELECT EvaluationID
  FROM dbo.SEEvaluation'
  
EXEC (@Query)


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