

DECLARE @OldUserID BIGINT, @NewUserID BIGINT

SELECT @OldUserID = 5147 
SELECT @NewUserID = 36574
-- DROP TABLE #Sessions
CREATE TABLE #Sessions(SessionID BIGINT)
INSERT INTO #Sessions(SessionID)
select EvalSessionID from SEEvalSession where evaluateeuserid=@OldUserID
-- select * from #Sessions

SELECT '-- UPDATING SEEvalSession.EvaluateeUserID'
SELECT 'UPDATE SEEvalSession SET EvaluateeUserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE EvalSessionID=' + CONVERT(VARCHAR, s.EvalSessionID)
  FROM dbo.SEEvalSession s
  JOIN dbo.#Sessions s2 ON s.EvalSessionID=s2.SessionID
 WHERE EvaluateeUserID=@OldUserID   

SELECT '-- UPDATING SERubricRowAnnotation.UserID'
SELECT 'UPDATE SERubricRowAnnotation SET UserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE SERubricRowAnnotationID=' + CONVERT(VARCHAR, SERubricRowAnnotationID)
  FROM SERubricRowAnnotation a
  JOIN dbo.#Sessions s2 ON a.EvalSessionID=s2.SessionID
 WHERE UserID=@OldUserID
 
SELECT '-- UPDATING SERubricPLDTextOverride.UserID'
 SELECT 'UPDATE SERubricPLDTextOverride SET UserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE SERubricPLDTextOverrideID=' + CONVERT(VARCHAR, SERubricPLDTextOverrideID)
  FROM dbo.SERubricPLDTextOverride o
  JOIN dbo.#Sessions s2 ON o.EvalSessionID=s2.SessionID
 WHERE UserID=@OldUserID
 
SELECT '-- UPDATING SEFrameworkNodeScore.SEUserID'
SELECT 'UPDATE SEFrameworkNodeScore SET SEUserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE FrameworkNodeScoreID=' + CONVERT(VARCHAR, FrameworkNodeScoreID)
  FROM dbo.SEFrameworkNodeScore s
  JOIN dbo.#Sessions s2 ON s.EvalSessionID=s2.SessionID
 WHERE SEUserID=@OldUserID

SELECT '-- UPDATING SERubricRowScore.SEUserID'
SELECT 'UPDATE SERubricRowScore SET SEUserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE SEUserID=' + CONVERT(VARCHAR, @OldUserID) + ' AND RubricRowID=' + CONVERT(VARCHAR, RubricRowID) + ' AND EvalSessionID=' + CONVERT(VARCHAR, EvalSessionID)
  FROM dbo.SERubricRowScore s
  JOIN dbo.#Sessions s2 ON s.EvalSessionID=s2.SessionID
 WHERE SEUserID=@OldUserID
 
 SELECT '-- UPDATING SEUserPromptResponseEntry.UserID'
 SELECT 'UPDATE SEUserPromptResponseEntry SET UserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptResponseEntryID=' + CONVERT(VARCHAR, UserPromptResponseEntryID)
  FROM dbo.SEUserPromptResponseEntry e
  JOIN dbo.SEUserPromptResponse r ON e.UserPromptResponseID=r.UserPromptResponseID
  JOIN dbo.#Sessions s2 ON r.EvalSessionID=s2.SessionID
 WHERE e.UserID=@oldUserID
 
SELECT '-- UPDATING SEUserPromptResponse.EvaluateeID'
SELECT 'UPDATE SEUserPromptResponse SET EvaluateeID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptResponseID=' + CONVERT(VARCHAR, UserPromptResponseID)
  FROM dbo.SEUserPromptResponse r
  JOIN dbo.#Sessions s2 ON r.EvalSessionID=s2.SessionID
 WHERE EvaluateeID=@OldUserID

SELECT '-- UPDATING SEUserPrompt.EvaluateeID'
SELECT 'UPDATE SEUserPrompt SET EvaluateeID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptID=' + CONVERT(VARCHAR, UserPromptID)
  FROM dbo.SEUserPrompt p
  JOIN dbo.#Sessions s2 ON p.EvalSessionID=s2.SessionID
 WHERE EvaluateeID=@OldUserID




 
 
 
 
 
 
 
 