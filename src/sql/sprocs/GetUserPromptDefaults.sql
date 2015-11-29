if exists (select * from sysobjects 
where id = object_id('dbo.GetUserPromptDefaults') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetUserPromptDefaults.'
      drop procedure dbo.GetUserPromptDefaults
   END
GO
PRINT '.. Creating sproc GetUserPromptDefaults.'
GO
CREATE PROCEDURE GetUserPromptDefaults
	 @pUserID BIGINT
	 ,@pPromptTypeID SMALLINT
	 ,@pSchoolYear SMALLINT
	 ,@pDistrictCode VARCHAR(20)
AS
SET NOCOUNT ON 


SELECT d.*
  FROM dbo.vUserPromptConferenceDefault d
 WHERE d.EvaluateeID=@pUserID
   AND d.UserPromptTypeID=@pPromptTypeID
   AND d.SchoolYear = @pSchoolYear
   AND d.DistrictCode=@pDistrictCode
   
