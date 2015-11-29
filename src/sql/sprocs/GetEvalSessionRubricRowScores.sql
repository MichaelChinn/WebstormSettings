IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalSessionRubricRowScores') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionRubricRowScores.'
      DROP PROCEDURE dbo.GetEvalSessionRubricRowScores
   END
GO
PRINT '.. Creating sproc GetEvalSessionRubricRowScores.'
GO

CREATE PROCEDURE dbo.GetEvalSessionRubricRowScores
	@pEvalSessionID	BIGINT
AS

SET NOCOUNT ON 

SELECT RubricRowID
	  ,EvalSessionID
	  ,PerformanceLevelID
	  ,SEUserID 
  FROM dbo.SERubricRowScore
 WHERE EvalSessionID=@pEvalSessionID

