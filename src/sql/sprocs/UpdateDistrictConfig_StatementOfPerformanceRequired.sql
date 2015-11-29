if exists (select * from sysobjects 
where id = object_id('dbo.UpdateDistrictConfig_StatementOfPerformanceRequired') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc UpdateDistrictConfig_StatementOfPerformanceRequired.'
      drop procedure dbo.UpdateDistrictConfig_StatementOfPerformanceRequired
   END
GO
PRINT '.. Creating sproc UpdateDistrictConfig_StatementOfPerformanceRequired.'
GO
CREATE PROCEDURE UpdateDistrictConfig_StatementOfPerformanceRequired
	@pDistrictCode VARCHAR(50)
	,@pSchoolYear INT
	,@pEvaluationTypeID SMALLINT
	,@pRequired BIT

AS
SET NOCOUNT ON 

UPDATE dbo.SEDistrictConfiguration
   SET  StatementOfPerformanceIsRequired=@pRequired
 WHERE SchoolYear=@pSchoolYear
   AND DistrictCode=@pDistrictCode
   AND EvaluationTypeID=@pEvaluationTypeID

   


