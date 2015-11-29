GO
IF OBJECT_ID ('dbo.GetIsItemImmutable') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc GetIsItemImmutable.'
      DROP PROCEDURE dbo.GetIsItemImmutable
   END
GO
PRINT '.. Creating sproc GetIsItemImmutable.'
GO
CREATE PROCEDURE dbo.GetIsItemImmutable
(
	@pItemId		BIGINT
)
AS


	select dbo.ItemIsImmutable_fn(@pItemId)
