if exists (select * from sysobjects 
where id = object_id('dbo.InsertEvaluation') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc InsertEvaluation.'
      drop procedure dbo.InsertEvaluation
   END
GO
PRINT '.. Creating sproc InsertEvaluation.'
GO

-- TOOD: should take FrameworkSetID
CREATE PROCEDURE InsertEvaluation
	@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT = NULL
	,@pDistrictCode VARCHAR(20)
	,@pEvaluateeID BIGINT = NULL
	,@pDebug BIT = 0
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
	SELECT @SchoolYear = MAX(SchoolYear) 
	  FROM dbo.SEFrameworkContext 
	 WHERE DistrictCode=@pDistrictCode
	   AND EvaluationTypeID=@pEvaluationTypeID
END


CREATE TABLE #User(UserID BIGINT, 
	DistrictCode VARCHAR(20)
	 )
IF (@pEvaluateeID IS NOT NULL)
BEGIN
	INSERT INTO #User(UserID, DistrictCode)
	SELECT u.SEUserID
	      ,ulr.DistrictCode
	  FROM dbo.SEUser u
	  JOIN dbo.SEUserLocationRole ulr ON ulr.SEUserId = u.SEUserID
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
	      ,ulr.DistrictCode
	  FROM dbo.SEUser u
	  JOIN dbo.SEUserLocationRole ulr ON ulr.seUserid = u.SEUserID
  	  JOIN dbo.aspnet_Roles r ON ulr.RoleID=r.RoleID
	 WHERE ulr.DistrictCode=@pDistrictCode
	   AND r.RoleName=CASE WHEN @pEvaluationTypeID=1 THEN 'SESchoolPrincipal' ELSE 'SESchoolTeacher' END
	   AND u.SEUserID NOT IN
	       (SELECT EvaluateeID
	          FROM dbo.SEEvaluation 
	         WHERE DistrictCode=@pDistrictCode
		       AND EvaluationTypeID=@pEvaluationTypeID
	           AND SchoolYear=@SchoolYear) 
END


IF @pDebug=1 SELECT '#users', * FROM #user

DECLARE @EvalID BIGINT

INSERT dbo.SEEvaluation(EvaluateeID, EvaluatorID, EvaluationTypeID, SchoolYear, DistrictCode, WfStateID) 
SELECT u.UserID, NULL, @pEvaluationTypeID, @SchoolYear, @pDistrictCode, 1
  FROM dbo.#User u
  

/*
-- TODO: pull forward the evaluationplan for next year

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
*/

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


