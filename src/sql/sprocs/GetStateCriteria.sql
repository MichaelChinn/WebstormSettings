IF exists (SELECT * FROm sysobjects WHERE id = object_id('dbo.GetStateCriteria') and sysstat & 0xf = 4)
   BEGIN
      PRINT '.. Dropping sproc GetStateCriteria.'
      DROP PROCEDURE dbo.GetStateCriteria
   END
GO
PRINT '.. Creating sproc GetStateCriteria.'
GO

CREATE PROCEDURE dbo.GetStateCriteria
AS

SET NOCOUNT ON 

SELECT c.*
  FROM dbo.vStateCriterion c
 ORDER BY Sequence


