

DECLARE @OldUserID BIGINT, @NewUserID BIGINT
SELECT @OldUserID = 16485 
SELECT @NewUserID = 36430

SELECT '-- UPDATING SEUserPrompt.CreatedByUserID'
SELECT 'UPDATE SEUserPrompt SET CreatedByUserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptID=' + CONVERT(VARCHAR, UserPromptID)
  FROM dbo.SEUserPrompt
 WHERE CreatedByUserID=@OldUserID
 
 SELECT '-- UPDATING SEUserPromptRubricRowAlignment.CreatedByUserID'
SELECT 'UPDATE SEUserPromptRubricRowAlignment SET CreatedByUserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE SEUserPromptRubricRowAlignmentID=' + CONVERT(VARCHAR, SEUserPromptRubricRowAlignmentID)
  FROM dbo.SEUserPromptRubricRowAlignment
 WHERE CreatedByUserID=@OldUserID
 
SELECT '-- UPDATING SEUserPromptResponseEntry.UserID'
 SELECT 'UPDATE SEUserPromptResponseEntry SET UserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptResponseEntryID=' + CONVERT(VARCHAR, UserPromptResponseEntryID)
  FROM dbo.SEUserPromptResponseEntry
 WHERE UserID=@oldUserID

SELECT '-- UPDATING SEUserPromptResponse.EvaluateeID For evaluation'
SELECT 'UPDATE SEUserPromptResponse SET EvaluateeID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptResponseID=' + CONVERT(VARCHAR, UserPromptResponseID)
  FROM dbo.SEUserPromptResponse r
  JOIN dbo.seuserprompt p ON r.userpromptid=p.UserPromptID
  JOIN dbo.seuserprompttype t ON p.prompttypeid=t.UserPromptTypeID
 WHERE r.EvaluateeID=@OldUserID

 
 
 
 
   
 
 
 
 
 
 
 
 
 