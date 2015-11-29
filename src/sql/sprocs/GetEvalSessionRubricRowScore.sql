IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetEvalSessionRubricRowScore') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvalSessionRubricRowScore.'
      DROP PROCEDURE dbo.GetEvalSessionRubricRowScore
   END
GO
PRINT '.. Creating sproc GetEvalSessionRubricRowScore.'
GO

CREATE PROCEDURE dbo.GetEvalSessionRubricRowScore
	@pEvalSessionID	BIGINT
	,@pRubricRowID BIGINT
AS

SET NOCOUNT ON 

SELECT PerformanceLevelID
  FROM dbo.SERubricRowScore
 WHERE EvalSessionID=@pEvalSessionID
   AND RubricRowID=@pRubricRowID

