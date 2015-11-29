GO
IF OBJECT_ID('dbo.CheckIfEDSUserHasData_fn') IS NOT NULL
    BEGIN
        PRINT '.. Dropping CheckIfEDSUserHasData_fn';
        DROP FUNCTION dbo.CheckIfEDSUserHasData_fn;
    END;
GO
PRINT '.. Creating function CheckIfEDSUserHasData_fn.';
GO
CREATE FUNCTION CheckIfEDSUserHasData_fn ( @pPersonID INT )
RETURNS @rtnUserDataCounts TABLE
    (
      PersonId BIGINT ,
      SEUserId BIGINT ,
      EvalSessionCount INT ,
      ArtifactCount INT ,
      ResponseEntryCount INT ,
      SummativeFNScore INT ,
      SummativeRRScore INT
    )
AS
    BEGIN

        DECLARE @SEUserID BIGINT;
        SELECT  @SEUserID = SEUserID
        FROM    SEUser
        WHERE   Username = CONVERT(VARCHAR, @pPersonID) + '_edsUser';


        DECLARE @EvalSessionCount INT ,
            @ArtifactCount INT ,
            @ResponseEntryCount INT ,
            @SummativeFNScoreCount INT ,
            @SummativeRRScoreCount INT;

        SELECT  @EvalSessionCount = COUNT(EvalSessionID)
        FROM    SEEvalSession
        WHERE   EvaluateeUserID = @SEUserID;
 
        SELECT  @ArtifactCount = COUNT(ArtifactID)
        FROM    dbo.SEArtifact
        WHERE   UserID = @SEUserID;
  
        SELECT  @ResponseEntryCount = COUNT(UserPromptResponseEntryID)
        FROM    SEUserPromptResponseEntry
        WHERE   UserID = @SEUserID;
  
        SELECT  @SummativeFNScoreCount = COUNT(SummativeFrameworkNodeScoreID)
        FROM    dbo.SESummativeFrameworkNodeScore
        WHERE   EvaluateeID = @SEUserID
                OR SEUserID = @SEUserID;
 
        SELECT  @SummativeRRScoreCount = COUNT(SummativeRubricRowScoreID)
        FROM    dbo.SESummativeRubricRowScore
        WHERE   EvaluateeID = @SEUserID
                OR SEUserID = @SEUserID;

        INSERT  @rtnUserDataCounts
                ( PersonId ,
                  SEUserId ,
                  EvalSessionCount ,
                  ArtifactCount ,
                  ResponseEntryCount ,
                  SummativeFNScore ,
                  SummativeRRScore 
                )
                SELECT  @pPersonID AS PersonID ,
                        @SEUserID AS SEUserid ,
                        @EvalSessionCount AS EvalSessionCount ,
                        @ArtifactCount AS ArtifactCount ,
                        @ResponseEntryCount AS ResponseEntryCount ,
                        @SummativeFNScoreCount AS SummativeFNScore ,
                        @SummativeRRScoreCount AS SummativeRRScore;
	   

       
        RETURN;    
    
       
    END;
       
     
 
 
 
 
 

