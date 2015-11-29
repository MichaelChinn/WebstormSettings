IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetObserveSessionsForFinalReport') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetObserveSessionsForFinalReport.'
      DROP PROCEDURE dbo.GetObserveSessionsForFinalReport
   END
GO
PRINT '.. Creating sproc GetObserveSessionsForFinalReport.'
GO

CREATE PROCEDURE dbo.GetObserveSessionsForFinalReport
	@pEvaluateeUserId	BIGINT
	,@pSchoolYear SMALLINT
	,@pDistrictCode VARCHAR(20)
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vEvalSession s
 WHERE EvaluateeUserID=@pEvaluateeUserId
   AND s.IsSelfAssess=0
   AND s.SchoolYear = @pSchoolYear
   AND s.DistrictCode = @pDistrictCode
   AND s.IncludeInFinalReport=1
 ORDER BY s.SessionKey ASC



