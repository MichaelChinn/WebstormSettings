if exists (select * from sysobjects 
where id = object_id('dbo.UpdateDistrictConfig_SelfAssessReportTitle') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateDistrictConfig_SelfAssessReportTitle.'
      drop procedure dbo.UpdateDistrictConfig_SelfAssessReportTitle
   END
GO
PRINT '.. Creating sproc UpdateDistrictConfig_SelfAssessReportTitle.'
GO
CREATE PROCEDURE UpdateDistrictConfig_SelfAssessReportTitle
	@pDistrictCode VARCHAR(50)
	,@pSchoolYear INT
	,@pEvaluationTypeID SMALLINT
	,@pReportTitle VARCHAR(200)

AS
SET NOCOUNT ON 

UPDATE dbo.SEDistrictConfiguration
   SET  SelfAssessReportTitle=@pReportTitle
 WHERE SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   AND EvaluationTypeID=@pEvaluationTypeID

   


