if exists (select * from sysobjects 
where id = object_id('dbo.GetLWEvalSessionScore') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetLWEvalSessionScore..'
      drop procedure dbo.GetLWEvalSessionScore
   END
GO
PRINT '.. Creating sproc GetLWEvalSessionScore..'
GO
CREATE PROCEDURE GetLWEvalSessionScore
	 @pEvalSessionID		BIGINT
	,@pClassroomID			BIGINT
	,@pUserID				BIGINT
AS
SET NOCOUNT ON

DECLARE @Score SMALLINT
SELECT @Score = 0
SELECT @Score=PerformanceLevelID 
 FROM dbo.SELearningWalkSessionScore
WHERE EvalSessionID=@pEvalSessionID
  AND ClassroomID=@pClassroomID
  AND SEUserID=@pUserID
  
 SELECT @Score AS Score




