
 
SELECT a.SchoolYear, a.AnchorTypeID, p.EvalSessionID, p.AnchorSessionID, a.Title, a.EvalSessionID
  FROM dbo.SEEvalSession p
  JOIN dbo.SEEvalSession a ON p.AnchorSessionID=a.EvalSessionID
 -- WHERE a.EvalSessionID NOT IN ( 33565, 1617, 2187, 4987)
 ORDER BY a.SchoolYear
 
 DECLARE @EvalSessionID BIGINT
 SELECT @EvalSessionID = 7356
 
 SELECT PerformanceLevelID FROM SEEvalSession WHERE EvalSessionID IN (@EvalSessionID)
 SELECT PerformanceLevelID FROM dbo.SEFrameworkNodeScore WHERE EvalSessionID IN (@EvalSessionID)
 SELECT PerformanceLevelID FROM dbo.SERubricRowScore WHERE EvalSessionID IN (@EvalSessionID)
 
SELECT  * FROM seevalsession WHERE evalsessionid=33565

-- get rid of all the participant sessions that don't have any scores
SELECT DISTINCT p.AnchorSessionID, p.EvalSessionID, 'EXEC RemoveEvalSession ' + CONVERT(VARCHAR, p.EvalSessionID) + ', @sql_error_message OUTPUT'
  FROM dbo.SEEvalSession p
 WHERE p.AnchorSessionID IS NOT NULL
   AND p.PerformanceLevelID IS NULL
   AND p.EvalSessionID NOT IN (SELECT EvalSessionID FROM SEFrameworkNodeScore)
   AND p.EvalSessionID NOT IN (SELECT EvalSessionID FROM SERubricRowScore)
 ORDER BY p.AnchorSessionID
  
      
-- remove all the practice sessions that don't have an participants
SELECT a.SchoolYear, a.AnchorTypeID, a.Title, a.EvalSessionID, 'EXEC RemovePracticeEvalSession ' + CONVERT(VARCHAR, a.EvalSessionID)
  FROM dbo.SEEvalSession a 
 WHERE a.EvaluationScoreTypeID=2
   AND a.EvalSessionID NOT IN (SELECT AnchorSessionID FROM SEEvalSession WHERE AnchorSessionID IS NOT NULL)
 ORDER BY a.SchoolYear

 

  
  


  SELECT anchorsessionid FROM seevalsession WHERE anchorsessionid=701
  
  SELECT * FROM seevalsession WHERE AnchorSessionID=701
  
  
  SELECT * FROM seevalsession WHERE evalsessionid=9222
  SELECT * FROM seevaluationscoretype
  SELECT * FROM seanchortype
  
