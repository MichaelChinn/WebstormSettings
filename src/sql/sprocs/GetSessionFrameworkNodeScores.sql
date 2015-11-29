IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSessionFrameworkNodeScores') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSessionFrameworkNodeScores.'
      DROP PROCEDURE dbo.GetSessionFrameworkNodeScores
   END
GO
PRINT '.. Creating sproc GetSessionFrameworkNodeScores.'
GO

CREATE PROCEDURE dbo.GetSessionFrameworkNodeScores
	@pSessionID	BIGINT
AS

SET NOCOUNT ON 

SELECT FrameworkNodeScoreID
	  ,fns.FrameworkNodeID
	  ,fns.PerformanceLevelID
	  ,fns.EvalSessionID
	  ,fns.SEUserID
  FROM dbo.SEFrameworkNodeScore fns
 WHERE fns.EvalSessionID=@pSessionID

