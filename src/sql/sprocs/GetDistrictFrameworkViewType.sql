IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetDistrictFrameworkViewType') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetDistrictFrameworkViewType.'
      DROP PROCEDURE dbo.GetDistrictFrameworkViewType
   END
GO
PRINT '.. Creating sproc GetDistrictFrameworkViewType.'
GO

CREATE PROCEDURE dbo.GetDistrictFrameworkViewType
	@pDistrictCode VARCHAR(20)
	,@pEvaluationTypeID SMALLINT
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT FrameworkViewTypeID
  FROM dbo.SEDistrictConfiguration
 WHERE DistrictCode=@pDistrictCode
   AND EvaluationTypeID=@pEvaluationTypeID
   AND SchoolYear=@pSchoolYear






