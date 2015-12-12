IF EXISTS ( SELECT  *
            FROM    sysobjects
            WHERE   id = OBJECT_ID('dbo.DataCountForUser')
                    AND sysstat & 0xf = 4 )
    BEGIN
        PRINT '.. Dropping sproc DataCountForUser.'
        DROP PROCEDURE dbo.DataCountForUser
    END
GO
PRINT '.. Creating sproc DataCountForUser.'
GO
CREATE PROCEDURE DataCountForUser
    @pPersonID INT ,
    @pDataCount INT OUTPUT
AS
    SET NOCOUNT ON 

    DECLARE @SEUserID BIGINT
    SELECT  @SEUserID = SEUserID
    FROM    SEUser
    WHERE   Username = CONVERT(VARCHAR, @pPersonID) + '_edsUser'

    DECLARE @EvalSessionCount INT ,
        @ArtifactCount INT ,
        @ResponseEntryCount INT ,
        @SummativeFNScoreCount INT ,
        @SummativeRRScoreCount INT

    SELECT  @EvalSessionCount = COUNT(EvalSessionID)
    FROM    SEEvalSession
    WHERE   EvaluateeUserID = @SEUserID
 
    SELECT  @ArtifactCount = COUNT(ArtifactID)
    FROM    dbo.SEArtifact
    WHERE   UserID = @SEUserID
  
    SELECT  @ResponseEntryCount = COUNT(UserPromptResponseEntryID)
    FROM    SEUserPromptResponseEntry
    WHERE   UserID = @SEUserID
  
    SELECT  @SummativeFNScoreCount = COUNT(SummativeFrameworkNodeScoreID)
    FROM    dbo.SESummativeFrameworkNodeScore
    WHERE   EvaluateeID = @SEUserID
            OR SEUserID = @SEUserID
 
    SELECT  @SummativeRRScoreCount = COUNT(SummativeRubricRowScoreID)
    FROM    dbo.SESummativeRubricRowScore
    WHERE   EvaluateeID = @SEUserID
            OR SEUserID = @SEUserID



        SELECT  @pDataCOunt = @EvalSessionCount + @ArtifactCount
                + @ResponseEntryCount + @SummativeFNScoreCount
                + @SummativeRRScoreCount 

   

    RETURN
       
    
       
 
       
     
 
 
 
 
 

