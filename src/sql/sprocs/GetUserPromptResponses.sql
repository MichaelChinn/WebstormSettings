if exists (select * from sysobjects 
where id = object_id('dbo.GetUserPromptResponses') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetUserPromptResponses.'
      drop procedure dbo.GetUserPromptResponses
   END
GO
PRINT '.. Creating sproc GetUserPromptResponses.'
GO
CREATE PROCEDURE GetUserPromptResponses
	 @pDistrictCode VARCHAR(20),
	 @pSchoolYear SMALLINT,
	 @pEvaluateeID BIGINT,
	 @pPromptTypeID SMALLINT
AS
SET NOCOUNT ON 

SELECT r.*
  FROM dbo.vUserPromptResponse r
 WHERE r.DistrictCode=@pDistrictCode
   AND r.SchoolYear=@pSchoolYear
   AND r.EvaluateeID=@pEvaluateeID
   AND r.PromptTypeID=@pPromptTypeID
 ORDER BY r.Sequence ASC

   
