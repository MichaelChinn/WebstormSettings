if exists (select * from sysobjects 
where id = object_id('dbo.InsertEvaluation') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertEvaluation.'
      drop procedure dbo.InsertEvaluation
   END
GO
PRINT '.. Creating sproc InsertEvaluation.'
GO
CREATE PROCEDURE InsertEvaluation
	@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT = NULL
	,@pDistrictCode VARCHAR(20)
	,@pEvaluateeID BIGINT = NULL
	,@sql_error_message VARCHAR(500) OUTPUT

AS
SET NOCOUNT ON 

---------------
-- VARIABLES --
---------------
DECLARE @sql_error                 INT
       ,@ProcName                  SYSNAME
       ,@tran_count                INT


---------------------
-- INITIALIZATIONS --
---------------------
SELECT  @sql_error              = 0
       ,@tran_count             = @@TRANCOUNT
       ,@ProcName               = OBJECT_NAME(@@PROCID)

------------------
-- TRAN CONTROL --
------------------
IF @tran_count = 0
   BEGIN TRANSACTION

DECLARE @SchoolYear SMALLINT
SELECT @SchoolYear = @pSchoolYear
IF (@pSchoolYear IS NULL)
BEGIN
	SELECT @SchoolYear = MAX(SchoolYear) FROM dbo.SESchoolYearDistrictConfig WHERE DistrictCode=@pDistrictCode
END


CREATE TABLE #User(UserID BIGINT, 
	DistrictCode VARCHAR(20)
	 )
IF (@pEvaluateeID IS NOT NULL)
BEGIN
	INSERT INTO #User(UserID, DistrictCode)
	SELECT u.SEUserID
	      ,u.DistrictCode
	  FROM dbo.SEUser u
	 WHERE u.SEUserID=@pEvaluateeID
	   AND u.SEUserID NOT IN
		   (SELECT EvaluateeID
		      FROM dbo.SEEvaluation
		     WHERE DistrictCode=@pDistrictCode
		       AND EvaluationTypeID=@pEvaluationTypeID
		       AND SchoolYear=@SchoolYear)
END
ELSE
BEGIN
	INSERT INTO #User(UserID, DistrictCode)
	SELECT DISTINCT u.SEUserID
	      ,u.DistrictCode
	  FROM dbo.SEUser u
	  JOIN dbo.aspnet_UsersInRoles ur ON u.ASPNetUserID=ur.UserId
	  JOIN dbo.aspnet_Roles r ON ur.RoleID=r.RoleID
	 WHERE u.DistrictCode=@pDistrictCode
	   AND r.RoleName=CASE WHEN @pEvaluationTypeID=1 THEN 'SESchoolPrincipal' ELSE 'SESchoolTeacher' END
	   AND u.SEUserID NOT IN
	       (SELECT EvaluateeID
	          FROM dbo.SEEvaluation 
	         WHERE DistrictCode=@pDistrictCode
		       AND EvaluationTypeID=@pEvaluationTypeID
	           AND SchoolYear=@SchoolYear)
END


DECLARE @EvalID BIGINT

INSERT dbo.SEEvaluation(EvaluateeID, EvaluatorID, EvaluationTypeID, SchoolYear, DistrictCode, WfStateID) 
SELECT u.UserID, NULL, @pEvaluationTypeID, @SchoolYear, @pDistrictCode, 1
  FROM dbo.#User u

  UPDATE u2
   SET u2.EvaluationID=e.EvaluationID
  FROM dbo.SEUser u2
  JOIN dbo.SEEvaluation e ON u2.SEUserID=e.EvaluateeID
  JOIN dbo.#User u ON e.EvaluateeID=u.UserID
 WHERE u.DistrictCode=e.DistrictCode
   AND e.SchoolYear=@SchoolYear
   AND e.EvaluationTypeID=@pEvaluationTypeID
 
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not update SEUser.EvaluationID failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END
  
-- pull forward the evaluationplan for next year

CREATE TABLE #fnMap (fnLast BIGINT, fnThis BIGINT, districtCode VARCHAR (20), evaluationTypeId smallint)
INSERT #fnMap(fnLast, fnthis, districtCode, evaluationTypeId)
SELECT fnLast.frameworkNodeId, fnThis.frameworkNodeID, flast.districtcode, flast.EvaluationTypeID
FROM seframework fLast
JOIN seFRamework fThis ON fThis.districtcode = fLast.DistrictCode
		AND fThis.frameworkTypeid = fLast.frameworkTypeid
JOIN seFrameworkNode fnLast ON fnLast.frameworkId = fLast.FrameworkID
JOIN seFrameworkNode fnThis ON fnThis.frameworkId = fThis.frameworkID
WHERE fLast.schoolyear = @pSchoolYear-1 AND fThis.schoolyear = @pSchoolYear
AND fnLast.shortname = fnThis.shortname
AND fLast.frameworktypeid IN (1,3)
ORDER BY fThis.districtcode, fThis.FrameworkTypeID

UPDATE  e_thisYear
SET     e_thisYear.EvaluateePlanTypeID = e_lastYear.NextYearEvaluateePlanTypeID ,
		e_thisYear.FocusedFrameworkNodeID = fnm.fnThis
FROM    #fnMap fnm
		JOIN SEEvaluation e_lastYear ON fnm.fnLast = e_lastYear.NextYearFocusedFrameworkNodeID
		JOIN SEEvaluation e_thisYear ON e_lastYear.DistrictCode = e_thisYear.DistrictCode
										AND e_lastYear.EvaluationTypeID = e_thisYear.EvaluationTypeID
										AND e_lastYear.EvaluateeID = e_thisYear.EvaluateeID
JOIN    dbo.#User u ON e_lastYear.EvaluateeID=u.UserID
WHERE   e_thisYear.SchoolYear = @pSchoolYear
		AND e_lastYear.SchoolYear = @pSchoolYear - 1
		AND e_lastYear.NextYearFocusedFrameworkNodeID IS NOT NULL;
 
UPDATE  e_thisYear
SET     e_thisYear.EvaluateePlanTypeID = e_lastYear.NextYearEvaluateePlanTypeID ,
        e_thisYear.FocusedSGFrameworkNodeID = fnm.fnThis
FROM    #fnMap fnm
        JOIN SEEvaluation e_lastYear ON fnm.fnLast = e_lastYear.NextYearFocusedSGFrameworkNodeID
        JOIN SEEvaluation e_thisYear ON e_lastYear.DistrictCode = e_thisYear.DistrictCode
                                        AND e_lastYear.EvaluationTypeID = e_thisYear.EvaluationTypeID
                                        AND e_lastYear.EvaluateeID = e_thisYear.EvaluateeID
JOIN    dbo.#User u ON e_lastYear.EvaluateeID=u.UserID
WHERE   e_thisYear.SchoolYear = @pSchoolYear
        AND e_lastYear.SchoolYear = @pSchoolYear - 1
        AND e_lastYear.NextYearFocusedSGFrameworkNodeID IS NOT NULL;

	  
	SELECT @sql_error = @@ERROR
	IF @sql_error <> 0
	BEGIN
		SELECT @sql_error_message = 'Could not update to SEEvaluation  failed. In: ' 
			+ @ProcName
			+ ' >>>' + ISNULL(@sql_error_message, '')
		GOTO ErrorHandler
	END

INSERT dbo.SEEvalVisibility(EvaluationID)
SELECT e.EvaluationID
  FROM dbo.SEEvaluation e
  JOIN dbo.#User u ON e.EvaluateeID=u.UserID
 WHERE u.DistrictCode=e.DistrictCode
   AND e.SchoolYear=@SchoolYear
   AND e.EvaluationTypeID=@pEvaluationTypeID
 
SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEEvalVisibility  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

DECLARE @UserPromptID BIGINT

-- Create Evaluation notes
SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='EvaluationNotes'
   AND EvaluationTypeID=@pEvaluationTypeID
 
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear, DistrictCode)
SELECT @UserPromptID
	  ,u.UserID
	  ,@SchoolYear
	  ,u.DistrictCode
  FROM dbo.SEEvaluation e
  JOIN dbo.#User u ON e.EvaluateeID=u.UserID
 WHERE u.DistrictCode=e.DistrictCode
   AND e.SchoolYear=@SchoolYear
   AND e.EvaluationTypeID=@pEvaluationTypeID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- Create Evaluation Recommendations
SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='EvaluationRecommendations'
   AND EvaluationTypeID=@pEvaluationTypeID
 
INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear, DistrictCode)
SELECT @UserPromptID
	  ,u.UserID
	  ,@SchoolYear
	  ,u.DistrictCode
  FROM dbo.SEEvaluation e
  JOIN dbo.#User u ON e.EvaluateeID=u.UserID
 WHERE u.DistrictCode=e.DistrictCode
   AND e.SchoolYear=@SchoolYear
   AND e.EvaluationTypeID=@pEvaluationTypeID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- Create Artifact Notes
SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='ArtifactNotes'
   AND EvaluationTypeID=@pEvaluationTypeID

INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear, DistrictCode)
SELECT @UserPromptID
	  ,u.UserID
	  ,@SchoolYear
	  ,u.DistrictCode
  FROM dbo.SEEvaluation e
  JOIN dbo.#User u ON e.EvaluateeID=u.UserID
 WHERE u.DistrictCode=e.DistrictCode
   AND e.SchoolYear=@SchoolYear
   AND e.EvaluationTypeID=@pEvaluationTypeID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-- Create Artifact Recommendations
SELECT @UserPromptID = UserPromptID
  FROM dbo.SEUserPrompt
 WHERE Title='ArtifactRecommendations'
   AND EvaluationTypeID=@pEvaluationTypeID

INSERT SEUserPromptResponse(UserPromptID, EvaluateeID, SchoolYear, DistrictCode)
SELECT @UserPromptID
	  ,u.UserID
	  ,@SchoolYear
	  ,u.DistrictCode
  FROM dbo.SEEvaluation e
  JOIN dbo.#User u ON e.EvaluateeID=u.UserID
 WHERE u.DistrictCode=e.DistrictCode
   AND e.SchoolYear=@SchoolYear
   AND e.EvaluationTypeID=@pEvaluationTypeID

SELECT @sql_error = @@ERROR
IF @sql_error <> 0
BEGIN
	SELECT @sql_error_message = 'Could not insert to SEUserPromptResponse  failed. In: ' 
		+ @ProcName
		+ ' >>>' + ISNULL(@sql_error_message, '')
	GOTO ErrorHandler
END

-------------------
-- Handle errors --
-------------------
ErrorHandler:
IF (@sql_error <> 0)
   BEGIN
      ROLLBACK TRANSACTION
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


