GO
IF OBJECT_ID ('dbo.GetItemRefCount') IS NOT NULL
   BEGIN
      PRINT '.. Dropping sproc GetItemRefCount.'
      DROP PROCEDURE dbo.GetItemRefCount
   END
GO
PRINT '.. Creating sproc GetItemRefCount.'
GO
CREATE PROCEDURE dbo.GetItemRefCount
(
	@pItemId		BIGINT
)

AS
begin
	select ReferenceCount from dbo.AppUsageCount 
	where repositoryItemID = @pItemId
end
