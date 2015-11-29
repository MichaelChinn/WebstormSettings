if exists (select * from sysobjects 
where id = object_id('dbo.UpdateDistrictConfig_FinalReportTitle') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateDistrictConfig_FinalReportTitle.'
      drop procedure dbo.UpdateDistrictConfig_FinalReportTitle
   END
GO
PRINT '.. Creating sproc UpdateDistrictConfig_FinalReportTitle.'
GO
CREATE PROCEDURE UpdateDistrictConfig_FinalReportTitle
	@pDistrictCode VARCHAR(50)
	,@pSchoolYear INT
	,@pEvaluationTypeID SMALLINT
	,@pFinalReportTitle VARCHAR(200)

AS
SET NOCOUNT ON 

UPDATE dbo.SEDistrictConfiguration
   SET FinalReportTitle=@pFinalReportTitle
 WHERE SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   AND EvaluationTypeID=@pEvaluationTypeID

   


