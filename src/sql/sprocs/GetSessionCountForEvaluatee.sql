IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSessionCountForEvaluatee') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSessionCountForEvaluatee.'
      DROP PROCEDURE dbo.GetSessionCountForEvaluatee
   END
GO
PRINT '.. Creating sproc GetSessionCountForEvaluatee.'
GO

CREATE PROCEDURE dbo.GetSessionCountForEvaluatee
	 @pUserID	BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
	,@pEvalTypeID SMALLINT
AS

SET NOCOUNT ON 
 
SELECT COUNT(s.EvalSessionID) 
  FROM dbo.SEEvalSession s (NOLOCK)
 WHERE s.SchoolYear=@pSchoolYear
   AND s.DistrictCode=@pDistrictCode
   AND s.EvaluateeUserID=@pUserID
   AND s.EvaluationTypeID=@pEvalTypeID

