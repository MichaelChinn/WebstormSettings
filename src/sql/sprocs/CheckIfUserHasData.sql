if exists (select * from sysobjects 
where id = object_id('dbo.CheckIfUserHasData') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc CheckIfUserHasData.'
      drop procedure dbo.CheckIfUserHasData
   END
GO
PRINT '.. Creating sproc CheckIfUserHasData.'
GO
CREATE PROCEDURE CheckIfUserHasData
	 @pPersonID INT,
	 @pSeUserid BIGINT = 0
AS
SET NOCOUNT ON 



DECLARE @SEUserID BIGINT
SELECT @SEUserID=SEUserID FROM SEUser WHERE Username=CONVERT(VARCHAR, @pPersonID) + '_edsUser'

IF @pSEUserId <> 0 select	@SEUserId = @pSEUserid



DECLARE @EvalSessionCount INT, @ArtifactCount INT, @ResponseEntryCount INT, @SummativeFNScoreCount INT, @SummativeRRScoreCount INT

SELECT @EvalSessionCount=COUNT(EvalSessionID)
  FROM SEEvalSession 
 WHERE EvaluateeUserID=@SEUserID
 
 SELECT @ArtifactCount=COUNT(ArtifactID)
   FROM dbo.SEArtifact
  WHERE UserID=@SEUserID
  
 SELECT @ResponseEntryCount=COUNT(UserPromptResponseEntryID)
   FROM SEUserPromptResponseEntry
  WHERE UserID=@SEUserID
  
 SELECT @SummativeFNScoreCount=COUNT(SummativeFrameworkNodeScoreID)
   FROM dbo.SESummativeFrameworkNodeScore
  WHERE EvaluateeID=@SEUserID OR SEUserID=@SEUserID
 
  SELECT @SummativeRRScoreCount=COUNT(SummativeRubricRowScoreID)
   FROM dbo.SESummativeRubricRowScore
  WHERE EvaluateeID=@SEUserID OR SEUserID=@SEUserID

 SELECT @pPersonID AS PersonID
       ,@seUserid AS SEUserid
	   ,@EvalSessionCount AS EvalSessionCount
       ,@ArtifactCount AS ArtifactCount
       ,@ResponseEntryCount AS ResponseEntryCount
       ,@SummativeFNScoreCount AS SummativeFNScore
       ,@SummativeRRScoreCount AS SummativeRRScore
	   
       
       
    
       
 
       
     
 
 
 
 
 

