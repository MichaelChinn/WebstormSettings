if exists (select * from sysobjects 
where id = object_id('dbo.UpdateDistrictConfig_ObservationReportTitle') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateDistrictConfig_ObservationReportTitle.'
      drop procedure dbo.UpdateDistrictConfig_ObservationReportTitle
   END
GO
PRINT '.. Creating sproc UpdateDistrictConfig_ObservationReportTitle.'
GO
CREATE PROCEDURE UpdateDistrictConfig_ObservationReportTitle
	@pDistrictCode VARCHAR(50)
	,@pSchoolYear INT
	,@pEvaluationTypeID SMALLINT
	,@pReportTitle VARCHAR(200)

AS
SET NOCOUNT ON 

UPDATE dbo.SEDistrictConfiguration
   SET ObservationReportTitle=@pReportTitle
 WHERE SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   AND EvaluationTypeID=@pEvaluationTypeID

   


