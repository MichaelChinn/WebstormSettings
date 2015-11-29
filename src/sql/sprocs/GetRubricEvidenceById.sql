IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetRubricEvidenceById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRubricEvidenceById.'
      DROP PROCEDURE dbo.GetRubricEvidenceById
   END
GO
PRINT '.. Creating sproc GetRubricEvidenceById.'
GO

CREATE PROCEDURE dbo.GetRubricEvidenceById
	@pId BIGINT
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vRubricEvidence
 WHERE RubricEvidenceID=@pId

