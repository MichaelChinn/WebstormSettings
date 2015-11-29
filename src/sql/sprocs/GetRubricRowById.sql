IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetRubricRowById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRubricRowById.'
      DROP PROCEDURE dbo.GetRubricRowById
   END
GO
PRINT '.. Creating sproc GetRubricRowById.'
GO

CREATE PROCEDURE dbo.GetRubricRowById
	@pRubricRowID BIGINT
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vRubricRow
 WHERE RubricRowID=@pRubricRowID

