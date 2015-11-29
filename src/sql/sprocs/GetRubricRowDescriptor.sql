IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetRubricRowDescriptor') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRubricRowDescriptor.'
      DROP PROCEDURE dbo.GetRubricRowDescriptor
   END
GO
PRINT '.. Creating sproc GetRubricRowDescriptor.'
GO

CREATE PROCEDURE dbo.GetRubricRowDescriptor
	@pRubricRowID	BIGINT
	,@pPerformanceLevelID SMALLINT
AS

SET NOCOUNT ON 

IF (@pPerformanceLevelID = 1)
BEGIN
SELECT PL1Descriptor
  FROM dbo.SERubricRow
 WHERE RubricRowID=@pRubricRowID

END
ELSE IF (@pPerformanceLevelID = 2)
BEGIN

SELECT PL2Descriptor
  FROM dbo.SERubricRow
 WHERE RubricRowID=@pRubricRowID

END
ELSE IF (@pPerformanceLevelID = 3)
BEGIN

SELECT PL3Descriptor
  FROM dbo.SERubricRow
 WHERE RubricRowID=@pRubricRowID

END
ELSE IF (@pPerformanceLevelID = 4)
BEGIN

SELECT PL4Descriptor
  FROM dbo.SERubricRow
 WHERE RubricRowID=@pRubricRowID

END



