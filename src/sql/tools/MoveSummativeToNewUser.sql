

DECLARE @OldUserID BIGINT, @NewUserID BIGINT
SELECT @OldUserID = 16485 
SELECT @NewUserID = 36430
   
 SELECT '-- UPDATING SEUserPromptResponseEntry.UserID'
 SELECT 'UPDATE SEUserPromptResponseEntry SET UserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptResponseEntryID=' + CONVERT(VARCHAR, UserPromptResponseEntryID)
  FROM dbo.SEUserPromptResponseEntry
 WHERE UserID=@oldUserID

-- evaluationnotes, evaluationrecs
  SELECT '-- UPDATING SEUserPromptResponse.EvaluateeID For evaluation prompts'
SELECT 'UPDATE SEUserPromptResponse SET EvaluateeID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptResponseID=' + CONVERT(VARCHAR, UserPromptResponseID)
  FROM dbo.SEUserPromptResponse r
  JOIN dbo.seuserprompt p ON r.userpromptid=p.UserPromptID
  JOIN dbo.seuserprompttype t ON p.prompttypeid=t.UserPromptTypeID
 WHERE r.EvaluateeID=@OldUserID
   AND p.Title in ('EvaluationNotes', 'EvaluationRecommendations')
 
SELECT '-- UPDATING SESummativeFrameworkNodeScore.EvaluateeID'
SELECT 'UPDATE SESummativeFrameworkNodeScore SET EvaluateeID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE SummativeFrameworkNodeScoreID=' + CONVERT(VARCHAR, SummativeFrameworkNodeScoreID)
  FROM dbo.SESummativeFrameworkNodeScore
 WHERE EvaluateeID=@OldUserID
 
 SELECT '-- UPDATING SESummativeFrameworkNodeScore.SEUserID'
SELECT 'UPDATE SESummativeFrameworkNodeScore SET SEUserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE SummativeFrameworkNodeScoreID=' + CONVERT(VARCHAR, SummativeFrameworkNodeScoreID)
  FROM dbo.SESummativeFrameworkNodeScore
 WHERE SEUserID=@OldUserID
 
 SELECT '-- UPDATING SESummativeRubricRowScore.EvaluateeID'
SELECT 'UPDATE SESummativeRubricRowScore SET EvaluateeID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE SummativeRubricRowScoreID=' + CONVERT(VARCHAR, SummativeRubricRowScoreID)
  FROM dbo.SESummativeRubricRowScore
 WHERE EvaluateeID=@OldUserID
 
 SELECT '-- UPDATING SESummativeRubricRowScore.SEUserID'
SELECT 'UPDATE SESummativeRubricRowScore SET SEUserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE SummativeRubricRowScoreID=' + CONVERT(VARCHAR, SummativeRubricRowScoreID)
  FROM dbo.SESummativeRubricRowScore
 WHERE SEUserID=@OldUserID
 
 

   
 
 
 
 
 
 
 
 
 