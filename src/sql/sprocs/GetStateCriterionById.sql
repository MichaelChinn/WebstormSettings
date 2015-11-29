IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetStateCriterionById') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetStateCriterionById.'
      DROP PROCEDURE dbo.GetStateCriterionById
   END
GO
PRINT '.. Creating sproc GetStateCriterionById.'
GO

CREATE PROCEDURE dbo.GetStateCriterionById
	@pCriterionID BIGINT
AS

SET NOCOUNT ON 

SELECT c.*
  FROM dbo.vStateCriterion c
 WHERE c.StateCriterionID=@pCriterionID

