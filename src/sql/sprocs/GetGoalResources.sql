IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetGoalResources') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetGoalResources.'
      DROP PROCEDURE dbo.GetGoalResources
   END
GO
PRINT '.. Creating sproc GetGoalResources.'
GO

CREATE PROCEDURE dbo.GetGoalResources
	 @pDistrictCode VARCHAR(20)
	,@pSchoolCode VARCHAR(20)
	,@pSchoolYear SMALLINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vResource 
 WHERE ((DistrictCode=@pDistrictCode AND SchoolCode='')
    OR (DistrictCode=@pDistrictCode AND SchoolCode=@pSchoolCode))
   AND ResourceTypeID=2 -- GOAL
   AND SchoolYear=@pSchoolYear



