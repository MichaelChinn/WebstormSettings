IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetGoalTemplateScoresForEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalTemplateScoresForEvaluatee.'
      DROP PROCEDURE dbo.GetGoalTemplateScoresForEvaluatee
   END
GO
PRINT '.. Creating sproc GetGoalTemplateScoresForEvaluatee.'
GO

CREATE PROCEDURE dbo.GetGoalTemplateScoresForEvaluatee
	@pEvaluateeID BIGINT
	,@pFrameworkID BIGINT
AS

SET NOCOUNT ON 

CREATE TABLE #Scores(GoalTemplateID BIGINT, FrameworkNodeID BIGINT, FrameworkNodeSeq INT, RubricRowID BIGINT, RubricRowSeq INT, ShortName VARCHAR(200), Title VARCHAR(600), PL SMALLINT)


INSERT INTO #Scores(GoalTemplateID, FrameworkNodeID, FrameworkNodeSeq, RubricRowID, RubricRowSeq, ShortName, Title, PL)
SELECT g.GoalTemplateID
      ,fn.FrameworkNodeID
	  ,fn.Sequence
	  ,rr.RubricRowID
	  ,rrfn.Sequence
	  ,rr.ShortName
	  ,rr.Title
	  ,0
 FROM dbo.SERubricRow rr 
 JOIN dbo.SERubricRowFrameworkNode rrfn
   ON rr.RubricRowID=rrfn.RubricRowID
 JOIN dbo.SEFrameworkNode fn
   ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
 JOIN dbo.SEGoalTEmplate g
   ON g.UserID=@pEvaluateeID
 WHERE fn.FrameworkID=@pFrameworkID
 
UPDATE #Scores
   SET PL=ISNULL(rrs.PerformanceLevelID,0)
 FROM dbo.SERubricRow rr 
 JOIN dbo.SERubricRowFrameworkNode rrfn
   ON rr.RubricRowID=rrfn.RubricRowID
 JOIN dbo.SEFrameworkNode fn
   ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
  JOIN dbo.SEGoalTemplateRubricRowScore rrs
	ON rr.RubricRowID=rrs.RubricRowID
  JOIN dbo.SEGoalTemplate g
	ON g.GoalTemplateID=rrs.GoalTemplateID
 WHERE fn.FrameworkID=@pFrameworkID
   AND fn.FrameworkNodeID=#Scores.FrameworkNodeID 
   AND rr.RubricRowID=#Scores.RubricRowID
   AND rrs.GoalTemplateID = #Scores.GoalTemplateID

SELECT scores.*, g.GoalTemplateID, g.Title
  FROM dbo.#Scores scores
  JOIN dbo.vGoalTemplate g
    ON scores.GoalTemplateID=g.GoalTemplateID
 ORDER BY scores.GoalTemplateID, scores.FrameworkNodeSeq, scores.RubricRowSeq