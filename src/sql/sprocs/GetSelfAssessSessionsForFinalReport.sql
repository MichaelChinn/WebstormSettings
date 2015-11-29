IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetSelfAssessSessionsForFinalReport') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetSelfAssessSessionsForFinalReport.'
      DROP PROCEDURE dbo.GetSelfAssessSessionsForFinalReport
   END
GO
PRINT '.. Creating sproc GetSelfAssessSessionsForFinalReport.'
GO

CREATE PROCEDURE dbo.GetSelfAssessSessionsForFinalReport
	@pEvaluateeUserId	BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vEvalSession s
 WHERE EvaluateeUserID=@pEvaluateeUserId
   AND s.IsSelfAssess=1
   AND s.SchoolYear = @pSchoolYear
   AND s.DistrictCode = @pDistrictCode
   AND s.IncludeInFinalReport=1
 ORDER BY s.SessionKey ASC



