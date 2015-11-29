GO
IF OBJECT_ID ('dbo.GetIsItemUsed') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc GetIsItemUsed.'
      DROP PROCEDURE dbo.GetIsItemUsed
   END
GO
PRINT '.. Creating sproc GetIsItemUsed.'
GO
CREATE PROCEDURE dbo.GetIsItemUsed
(
	@pItemId		BIGINT
)
AS


	select dbo.ItemIsUsed_fn(@pItemId)
