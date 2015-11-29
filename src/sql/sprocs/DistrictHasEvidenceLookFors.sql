IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.DistrictHasEvidenceLookFors') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc DistrictHasEvidenceLookFors.'
      DROP PROCEDURE dbo.DistrictHasEvidenceLookFors
   END
GO
PRINT '.. Creating sproc DistrictHasEvidenceLookFors.'
GO

CREATE PROCEDURE dbo.DistrictHasEvidenceLookFors
	@pDistrictCode VARCHAR(20)
   ,@pSchoolYear SMALLINT
   ,@pEvaluationTypeID SMALLINT
AS

SET NOCOUNT ON 

IF EXISTS (SELECT rr.RubricRowID
             FROM dbo.SERubricRow rr
             JOIN dbo.SERubricRowFrameworkNode rrfn ON rr.RubricRowID=rrfn.RubricRowID
             JOIN dbo.SEFrameworkNode fn ON rrfn.FrameworkNodeID=fn.FrameworkNodeID
             JOIN dbo.SEFramework f ON fn.FrameworkID=f.FrameworkID
            WHERE f.SchoolYear=@pSchoolYear
              AND f.DistrictCode=@pDistrictCode
              AND f.EvaluationTypeID=@pEvaluationTypeID
              AND rr.DESCRIPTION <> '')
BEGIN
	SELECT 1
END
ELSE
BEGIN
	SELECT 0
END


