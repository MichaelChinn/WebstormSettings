if exists (select * from sysobjects 
where id = object_id('dbo.GetAssignedUserPrompts') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetAssignedUserPrompts.'
      drop procedure dbo.GetAssignedUserPrompts
   END
GO
PRINT '.. Creating sproc GetAssignedUserPrompts.'
GO
CREATE PROCEDURE GetAssignedUserPrompts
	 @pPromptTypeID SMALLINT,
	 @pSchoolYear SMALLINT,
	 @pDistrictCode VARCHAR(20),
	 @pUserID BIGINT
AS
SET NOCOUNT ON 

SELECT p.*
  FROM dbo.vUserPrompt p (NOLOCK)
  JOIN dbo.vUserPromptResponse r (NOLOCK) ON p.UserPromptID=r.UserPromptID
 WHERE r.PromptTypeID=@pPromptTypeID
   AND r.EvaluateeID=@pUserID
   AND r.SchoolYear=@pSchoolYear
   AND r.DistrictCode=@pDistrictCode
 ORDER BY r.Sequence ASC

   
