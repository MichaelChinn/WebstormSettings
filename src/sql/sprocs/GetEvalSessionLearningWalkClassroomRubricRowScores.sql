IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalSessionLearningWalkClassroomRubricRowScores') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionLearningWalkClassroomRubricRowScores.'
      DROP PROCEDURE dbo.GetEvalSessionLearningWalkClassroomRubricRowScores
   END
GO
PRINT '.. Creating sproc GetEvalSessionLearningWalkClassroomRubricRowScores.'
GO

CREATE PROCEDURE dbo.GetEvalSessionLearningWalkClassroomRubricRowScores
	@pEvalSessionID	BIGINT
   ,@pClassroomID BIGINT
   ,@pUserID BIGINT
AS

SET NOCOUNT ON 

SELECT RubricRowID
	  ,EvalSessionID
	  ,PerformanceLevelID
	  ,SEUserID 
  FROM dbo.SERubricRowScore
 WHERE EvalSessionID=@pEvalSessionID
   AND LearningWalkClassroomID=@pClassroomID
   AND SEUserID=@pUserID

