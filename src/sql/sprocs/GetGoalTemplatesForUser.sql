if exists (select * from sysobjects 
where id = object_id('dbo.GetGoalTemplatesForUser') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalTemplatesForUser'
      drop procedure dbo.GetGoalTemplatesForUser
   END
GO
PRINT '.. Creating sproc GetGoalTemplatesForUser'
GO

CREATE PROCEDURE GetGoalTemplatesForUser
	 @pUserID BIGINT
	 ,@pDistrictCode VARCHAR(20)
	 ,@pSchoolYear SMALLINT
	 ,@pGoalTemplateTypeID SMALLINT
AS
SET NOCOUNT ON 


SELECT *
  FROM dbo.vGoalTemplate
 WHERE UserID=@pUserID
   AND DistrictCode=@pDistrictCode
   AND SchoolYear=@pSchoolYear
   AND GoalTemplateTypeID=@pGoalTemplateTypeID
