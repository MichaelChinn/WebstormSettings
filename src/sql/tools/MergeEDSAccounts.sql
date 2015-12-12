

DECLARE @OldUserID BIGINT, @NewUserID BIGINT
SELECT @OldUserID = 16485 
SELECT @NewUserID = 36430


 SELECT '-- UPDATING SEUserPromptResponseEntry.UserID'
 SELECT 'UPDATE SEUserPromptResponseEntry SET UserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptResponseEntryID=' + CONVERT(VARCHAR, UserPromptResponseEntryID)
  FROM dbo.SEUserPromptResponseEntry
 WHERE UserID=@oldUserID

-- select * from SEUserPrompt where UserPromptID in (6, 5049, 6487, 6489)
-- evaluationnotes, evaluationrecs, artifactnotes, artifactrecs
  SELECT '-- UPDATING SEUserPromptResponse.EvaluateeID For evaluation and artifact prompts'
SELECT 'UPDATE SEUserPromptResponse SET EvaluateeID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptResponseID=' + CONVERT(VARCHAR, UserPromptResponseID)
  FROM dbo.SEUserPromptResponse r
  JOIN dbo.seuserprompt p ON r.userpromptid=p.UserPromptID
  JOIN dbo.seuserprompttype t ON p.prompttypeid=t.UserPromptTypeID
 WHERE r.EvaluateeID=@OldUserID
   AND p.UserPromptID IN (6, 5049, 6487, 6489)
  
-- select * from SEUserPrompt where UserPromptID in (6661) 
-- inidividual artifact notes
SELECT '-- UPDATING SEUserPromptResponse.EvaluateeID For individual artifact prompts'
SELECT 'UPDATE SEUserPromptResponse SET EvaluateeID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptResponseID=' + CONVERT(VARCHAR, UserPromptResponseID)
  FROM dbo.SEUserPromptResponse r
  JOIN dbo.seuserprompt p ON r.userpromptid=p.UserPromptID
  JOIN dbo.seuserprompttype t ON p.prompttypeid=t.UserPromptTypeID
 WHERE r.EvaluateeID=@OldUserID
   AND p.UserPromptID IN (6661)
   
 -- select * from SEUserPrompt where UserPromptID in (2, 4, 5863, 5865) 
 -- PreConfNotes, PostConfNotes, RubricNotes, RubricRecs
  SELECT '-- UPDATING SEUserPromptResponse.EvaluateeID For evalsession prompts'
SELECT 'UPDATE SEUserPromptResponse SET EvaluateeID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptResponseID=' + CONVERT(VARCHAR, UserPromptResponseID)
  FROM dbo.SEUserPromptResponse r
  JOIN dbo.seuserprompt p ON r.userpromptid=p.UserPromptID
  JOIN dbo.seuserprompttype t ON p.prompttypeid=t.UserPromptTypeID
 WHERE r.EvaluateeID=@OldUserID
   AND p.UserPromptID IN (2, 4, 5863, 5865)

 
SELECT '-- UPDATING SEUserPrompt.EvaluateeID'
SELECT 'UPDATE SEUserPrompt SET EvaluateeID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptID=' + CONVERT(VARCHAR, UserPromptID)
  FROM dbo.SEUserPrompt
 WHERE EvaluateeID=@OldUserID

SELECT '-- UPDATING SEUserPrompt.CreatedByUserID'
SELECT 'UPDATE SEUserPrompt SET CreatedByUserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptID=' + CONVERT(VARCHAR, UserPromptID)
  FROM dbo.SEUserPrompt
 WHERE CreatedByUserID=@OldUserID
  
SELECT '-- UPDATING SEUserPromptRubricRowAlignment.CreatedByUserID'
SELECT 'UPDATE SEUserPromptRubricRowAlignment SET CreatedByUserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE SEUserPromptRubricRowAlignmentID=' + CONVERT(VARCHAR, SEUserPromptRubricRowAlignmentID)
  FROM dbo.SEUserPromptRubricRowAlignment
 WHERE CreatedByUserID=@OldUserID
 
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
 
 
 /* have to be careful with this one: can only have one per schoolyear
 SELECT '-- UPDATING SEEvaluation.EvaluateeID'
SELECT 'UPDATE SEEvaluation SET EvaluateeID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE EvaluationID=' + CONVERT(VARCHAR, EvaluationID)
  FROM dbo.SEEvaluation
 WHERE EvaluateeID=@OldUserID
*/
 
  
 SELECT '-- UPDATING stateeval_repo.dbo.RepositoryItem.OwnerID'
 SELECT 'UPDATING stateeval_repo.dbo.RepositoryItem SET OwnerID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE RepositoryItemID=' + CONVERT(VARCHAR, RepositoryItemID)
  FROM stateeval_repo.dbo.RepositoryItem
 WHERE OwnerID=@oldUserID
 
 SELECT '-- UPDATING SEArtifact.UserID'
 SELECT 'UPDATE SEArtifact SET UserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE ArtifactID=' + CONVERT(VARCHAR, ArtifactID)
  FROM dbo.SEArtifact
 WHERE UserID=@oldUserID
 
 SELECT '-- UPDATING SERubricPLDTextOverride.UserID'
 SELECT 'UPDATE SERubricPLDTextOverride SET UserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE SERubricPLDTextOverrideID=' + CONVERT(VARCHAR, SERubricPLDTextOverrideID)
  FROM dbo.SERubricPLDTextOverride
 WHERE UserID=@OldUserID
 
SELECT '-- UPDATING SEEvalSession.EvaluateeUserID'
SELECT 'UPDATE SEEvalSession SET EvaluateeUserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE EvalSessionID=' + CONVERT(VARCHAR, EvalSessionID)
  FROM dbo.SEEvalSession
 WHERE EvaluateeUserID=@OldUserID   

SELECT '-- UPDATING SERubricRowAnnotation.UserID'
SELECT 'UPDATE SERubricRowAnnotation SET UserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE SERubricRowAnnotationID=' + CONVERT(VARCHAR, SERubricRowAnnotationID)
  FROM SERubricRowAnnotation 
 WHERE UserID=@OldUserID
 
SELECT '-- UPDATING SEFrameworkNodeScore.SEUserID'
SELECT 'UPDATE SEFrameworkNodeScore SET SEUserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE FrameworkNodeScoreID=' + CONVERT(VARCHAR, FrameworkNodeScoreID)
  FROM dbo.SEFrameworkNodeScore
 WHERE SEUserID=@OldUserID

SELECT '-- UPDATING SERubricRowScore.SEUserID'
SELECT 'UPDATE SERubricRowScore SET SEUserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE SEUserID=' + CONVERT(VARCHAR, @OldUserID) + 'AND RubricRowID=' + CONVERT(VARCHAR, RubricRowID) + ' AND EvalSessionID=' + CONVERT(VARCHAR, EvalSessionID)
  FROM dbo.SERubricRowScore
 WHERE SEUserID=@OldUserID

   
 
 
 
 
 
 
 
 
 