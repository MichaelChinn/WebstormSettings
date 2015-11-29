IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetRubricRowAnnotation') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetRubricRowAnnotation.'
      DROP PROCEDURE dbo.GetRubricRowAnnotation
   END
GO
PRINT '.. Creating sproc GetRubricRowAnnotation.'
GO

CREATE PROCEDURE dbo.GetRubricRowAnnotation
	@pRubricRowID BIGINT
   ,@pSessionID BIGINT
   ,@pUserID	BIGINT
AS

SET NOCOUNT ON 

SELECT *
  FROM dbo.vRubricRowAnnotation (NOLOCK)
 WHERE EvalSessionID=@pSessionID
   AND RubricRowID=@pRubricRowID
   AND UserID=@pUserID

