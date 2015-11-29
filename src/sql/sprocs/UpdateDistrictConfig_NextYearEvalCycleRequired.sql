if exists (select * from sysobjects 
where id = object_id('dbo.UpdateDistrictConfig_NextYearEvalCycleRequired') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateDistrictConfig_NextYearEvalCycleRequired.'
      drop procedure dbo.UpdateDistrictConfig_NextYearEvalCycleRequired
   END
GO
PRINT '.. Creating sproc UpdateDistrictConfig_NextYearEvalCycleRequired.'
GO
CREATE PROCEDURE UpdateDistrictConfig_NextYearEvalCycleRequired
	@pDistrictCode VARCHAR(50)
	,@pSchoolYear INT
	,@pEvaluationTypeID SMALLINT
	,@pRequired BIT

AS
SET NOCOUNT ON 

UPDATE dbo.SEDistrictConfiguration
   SET NextYearEvalCycleIsRequired=@pRequired
 WHERE SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   AND EvaluationTypeID=@pEvaluationTypeID

   


