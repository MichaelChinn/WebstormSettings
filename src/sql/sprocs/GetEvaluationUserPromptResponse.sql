if exists (select * from sysobjects 
where id = object_id('dbo.GetEvaluationUserPromptResponse') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetEvaluationUserPromptResponse.'
      drop procedure dbo.GetEvaluationUserPromptResponse
   END
GO
PRINT '.. Creating sproc GetEvaluationUserPromptResponse.'
GO
CREATE PROCEDURE GetEvaluationUserPromptResponse
	 @pSchoolYear SMALLINT,
	 @pEvaluateeID BIGINT,
	 @pUserPromptID BIGINT,
	 @pDistrictCode VARCHAR(20)
AS
SET NOCOUNT ON 

SELECT r.*
  FROM dbo.vUserPromptResponse r
 WHERE r.UserPromptID=@pUserPromptID
   AND r.EvaluateeID=@pEvaluateeID
   AND r.SchoolYear=@pSchoolYear
   AND r.DistrictCode=@pDistrictCode

   
