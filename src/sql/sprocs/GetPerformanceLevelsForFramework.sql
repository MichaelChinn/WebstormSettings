IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetPerformanceLevelsForFramework') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetPerformanceLevelsForFramework.'
      DROP PROCEDURE dbo.GetPerformanceLevelsForFramework
   END
GO
PRINT '.. Creating sproc GetPerformanceLevelsForFramework.'
GO

CREATE PROCEDURE dbo.GetPerformanceLevelsForFramework
	@pFrameworkId	BIGINT
AS

SET NOCOUNT ON 

SELECT * 
  FROM dbo.vFrameworkPerformanceLevel
 WHERE FrameworkID=@pFrameworkID

