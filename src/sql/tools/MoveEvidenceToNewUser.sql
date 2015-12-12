

DECLARE @OldUserID BIGINT, @NewUserID BIGINT, @EvalSessionID BIGINT

SELECT @OldUserID = 2750 
SELECT @NewUserID = 6536
 
 SELECT '-- UPDATING stateeval_repo.dbo.RepositoryItem.OwnerID'
 SELECT 'UPDATE stateeval_repo.dbo.RepositoryItem SET OwnerID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE RepositoryItemID=' + CONVERT(VARCHAR, RepositoryItemID)
  FROM stateeval_repo.dbo.RepositoryItem
 WHERE OwnerID=@oldUserID
 
 SELECT '-- UPDATING SEArtifact.UserID'
 SELECT 'UPDATE SEArtifact SET UserID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE ArtifactID=' + CONVERT(VARCHAR, ArtifactID)
  FROM dbo.SEArtifact
 WHERE UserID=@oldUserID
 
 -- ArtifactNotes, ArtifactRecommendations, IndividualArtifactNotes
   SELECT '-- UPDATING SEUserPromptResponse.EvaluateeID For evaluation and artifact prompts'
SELECT 'UPDATE SEUserPromptResponse SET EvaluateeID=' + CONVERT(VARCHAR, @NewUserID) + ' WHERE UserPromptResponseID=' + CONVERT(VARCHAR, UserPromptResponseID)
  FROM dbo.SEUserPromptResponse r
  JOIN dbo.seuserprompt p ON r.userpromptid=p.UserPromptID
  JOIN dbo.seuserprompttype t ON p.prompttypeid=t.UserPromptTypeID
 WHERE r.EvaluateeID=@OldUserID
   AND p.Title in ('ArtifactNotes', 'ArtifactRecommendations', 'IndividualArtifactNotes')

 





 
 
 
 
 
 
 
 